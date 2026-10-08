"""Exercise installer control flow without package installation or network access."""
import os
import hashlib
import io
import json
from pathlib import Path
import subprocess
import tarfile
import tempfile
import unittest


class InstallerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="sectools-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.release = self.root / "os-release"
        self.release.write_text('ID=ubuntu\nVERSION_ID="24.04"\n')
        source = Path(__file__).with_name("sectools.sh").read_text()
        self.script = self.root / "sectools.sh"
        self.script.write_text(source.replace("/etc/os-release", str(self.release)))
        self.log = self.root / "commands"
        mocks = self.root / "mocks"
        mocks.mkdir()
        mock = '''#!/usr/bin/env bash
printf '%s %s\n' "${0##*/}" "$*" >> "$TEST_LOG"
case ${0##*/} in
  sudo) exit "${PACKAGE_EXIT:-0}" ;;
  apt-cache)
    if [[ $2 == "${MISSING_PACKAGE:-}" ]]; then
      echo '  Candidate: (none)'
    else
      echo '  Candidate: 1.0'
    fi ;;
  git) mkdir -p "${@: -1}/bin" ;;
  make) printf '#!/bin/sh\nexit 0\n' > "$2/bin/massdns" ;;
esac
'''
        for name in ("sudo", "apt-get", "apt-cache", "pacman", "go", "git", "make", "pipx"):
            path = mocks / name
            path.write_text(mock)
            path.chmod(0o755)
        self.env = dict(os.environ, PATH=f"{mocks}:{os.environ['PATH']}",
                        TEST_LOG=str(self.log), SECTOOLS_HOME=str(self.root / "tools with spaces"))

    def run_script(self, *args, **env):
        return subprocess.run(["bash", str(self.script), *args],
                              env=dict(self.env, **env), text=True, capture_output=True)

    def test_ubuntu_server_preview_has_no_side_effects(self):
        result = self.run_script("--server", "--dry-run")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("apt-get install --no-install-recommends", result.stdout)
        for name in ("dnsutils", "hping3", "golang-go", "python3-venv", "tshark", "mtr-tiny"):
            self.assertIn(name, result.stdout)
        for name in ("chromium", "wireshark-qt", "metasploit", "aircrack-ng", "pocl"):
            self.assertNotIn(name, result.stdout)
        self.assertFalse(self.log.exists())
        self.assertFalse((self.root / "tools with spaces").exists())

    def test_arch_detection_and_upgrade(self):
        self.release.write_text("ID=arch\n")
        result = self.run_script("--base", "--upgrade-system", "--dry-run")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("pacman -Syu --needed", result.stdout)
        self.assertNotIn("apt-get", result.stdout)

    def test_preview_override_cannot_install(self):
        result = self.run_script("--base", "--os=arch")
        self.assertEqual(result.returncode, 2)
        self.assertFalse(self.log.exists())
        result = self.run_script("--base", "--os=arch", "--dry-run")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("pacman", result.stdout)

    def test_unsupported_and_old_distributions(self):
        self.release.write_text('ID=fedora\nID_LIKE="arch ubuntu"\n')
        self.assertEqual(self.run_script("--base", "--dry-run").returncode, 1)
        self.release.write_text('ID=ubuntu\nVERSION_ID="22.04"\n')
        self.assertEqual(self.run_script("--server", "--dry-run").returncode, 1)
        self.assertEqual(self.run_script("--base", "--dry-run").returncode, 0)
        self.assertFalse(self.log.exists())

    def test_unavailable_metasploit_is_not_reported_as_success(self):
        result = self.run_script("--metasploit", "--dry-run")
        self.assertEqual(result.returncode, 1)
        self.assertIn("UNAVAILABLE", result.stderr)
        self.assertNotIn("apt-get install", result.stdout)

    @unittest.skipIf(os.geteuid() == 0, "Installer deliberately rejects root")
    def test_missing_candidate_allows_remaining_packages(self):
        result = self.run_script("--passwords", MISSING_PACKAGE="hashcat-utils")
        self.assertEqual(result.returncode, 1)
        self.assertIn("hashcat-utils", result.stderr)
        commands = self.log.read_text()
        install = next(line for line in commands.splitlines() if "apt-get install" in line)
        self.assertIn("john hashcat hydra clinfo", install)
        self.assertNotIn("hashcat-utils", install)
        self.assertNotIn("upgrade", commands)

    @unittest.skipIf(os.geteuid() == 0, "Installer deliberately rejects root")
    def test_package_failure_stops_source_builds(self):
        result = self.run_script("--server", PACKAGE_EXIT="1")
        self.assertEqual(result.returncode, 1)
        self.assertEqual(self.log.read_text().splitlines(), ["sudo apt-get update"])

    @unittest.skipIf(os.geteuid() == 0, "Installer deliberately rejects root")
    def test_mocked_server_install(self):
        result = self.run_script("--server", "--upgrade-system")
        self.assertEqual(result.returncode, 0, result.stderr)
        commands = self.log.read_text()
        self.assertIn("apt-get upgrade", commands)
        self.assertEqual(commands.count("go install "), 13)
        self.assertTrue((self.root / "tools with spaces/bin/massdns").exists())

    def test_latest_go_preview(self):
        result = self.run_script("--server", "--go-latest", "--dry-run")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("golang-go", result.stdout)
        self.assertIn("SHA-256", result.stdout)
        self.assertIn("/go/bin/go", result.stdout)
        self.assertFalse(self.log.exists())

    def prepare_go_download(self, corrupt=False):
        archive = self.root / "go.tar.gz"
        executable = b'#!/bin/sh\necho "go version go1.99.0 linux/amd64"\n'
        with tarfile.open(archive, "w:gz") as output:
            info = tarfile.TarInfo("go/bin/go")
            info.size = len(executable)
            info.mode = 0o755
            output.addfile(info, io.BytesIO(executable))
        checksum = hashlib.sha256(archive.read_bytes()).hexdigest()
        metadata = [{"stable": True, "files": [{
            "version": "go1.99.0", "filename": "go1.99.0.linux-amd64.tar.gz",
            "os": "linux", "arch": "amd64", "kind": "archive",
            "sha256": "0" * 64 if corrupt else checksum,
        }]}]
        (self.root / "releases.json").write_text(json.dumps(metadata))
        mocks = self.root / "mocks"
        (mocks / "uname").write_text('#!/bin/sh\necho x86_64\n')
        (mocks / "uname").chmod(0o755)
        (mocks / "curl").write_text('''#!/usr/bin/env bash
printf 'curl %s\n' "$*" >> "$TEST_LOG"
fixture="$FIXTURES/go.tar.gz"
for arg in "$@"; do
    if [[ $arg == *'mode=json'* ]]; then fixture="$FIXTURES/releases.json"; fi
done
cp "$fixture" "${@: -1}"
''')
        (mocks / "curl").chmod(0o755)
        self.env["FIXTURES"] = str(self.root)

    @unittest.skipIf(os.geteuid() == 0, "Installer deliberately rejects root")
    def test_latest_go_verified_install_and_rerun(self):
        self.prepare_go_download()
        result = self.run_script("--go-latest")
        self.assertEqual(result.returncode, 0, result.stderr)
        current = self.root / "tools with spaces/go"
        self.assertTrue(current.is_symlink())
        self.assertTrue((current / "bin/go").is_file())
        self.log.unlink()
        result = self.run_script("--go-latest")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(sum(line.startswith("curl ") for line in self.log.read_text().splitlines()), 1)

    @unittest.skipIf(os.geteuid() == 0, "Installer deliberately rejects root")
    def test_bad_checksum_preserves_previous_go(self):
        self.prepare_go_download(corrupt=True)
        home = self.root / "tools with spaces"
        previous = home / "previous"
        previous.mkdir(parents=True)
        (home / "go").symlink_to(previous)
        result = self.run_script("--go-latest")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((home / "go").resolve(), previous)
        self.assertFalse((home / "toolchains/go1.99.0-amd64").exists())
        self.assertEqual(list((home / "toolchains").iterdir()), [])


if __name__ == "__main__":
    unittest.main()
