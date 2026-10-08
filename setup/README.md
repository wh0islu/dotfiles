# Security tools (Ubuntu Server and Arch Linux)

`sectools.sh` is independent of the desktop installer. Run it from the repository
root as your regular user with sudo access. With no arguments it only displays
help. It reads `/etc/os-release` and selects `apt-get` on Ubuntu or `pacman` on
Arch. Other distribution IDs are rejected before making changes.

Ubuntu 24.04 LTS or newer is the target for the complete toolset. Older Ubuntu
releases can use package-only groups; source-tool groups require 24.04+ for the
Go and Python baseline. Package availability depends on the release, architecture
and enabled repositories. This script is not a generic installer for every Linux
distribution, macOS or Windows.

## Ubuntu server quick start

Run these commands on the server from the repository root:

```bash
./setup/sectools.sh --server --dry-run
./setup/sectools.sh --server
export PATH="$HOME/.local/share/sectools/bin:$PATH"

# Add password auditing separately.
./setup/sectools.sh --passwords
```

`--server` selects base, recon, DNS, network and web tools. It does not select
GUI applications, a browser, wireless tools, Metasploit or a compute runtime.
Add the printed PATH export to your shell configuration once for future logins.

To preview Ubuntu commands from an Arch machine:

```bash
./setup/sectools.sh --server --os=ubuntu --dry-run
```

`--os=ubuntu` and `--os=arch` only work with `--dry-run`; real installations always
use the detected distribution. A preview does not query the remote server or
verify package candidates.

## Selecting groups

```bash
# Preview a small installation first.
./setup/sectools.sh --base --recon --dry-run

# Install those groups; the package manager asks for confirmation.
./setup/sectools.sh --base --recon

# Add individual groups later.
./setup/sectools.sh --dns
./setup/sectools.sh --helpers
./setup/sectools.sh --screenshots
./setup/sectools.sh --metasploit

# Add password auditing and everyday network/web diagnostics.
./setup/sectools.sh --passwords --network --web --dry-run
./setup/sectools.sh --passwords --network --web

# Preview all groups, including larger GUI and antivirus dependencies.
./setup/sectools.sh --all --dry-run
```

| Group | Tools |
| --- | --- |
| `--base` | jq, curl, wget, nmap (including ncat), whois, bind (dig/host), net-tools, hping |
| `--recon` | subfinder, chaos, httpx, dnsx, nuclei, amass, ffuf, gau, waybackurls, assetfinder, mapcidr, asnmap |
| `--helpers` | notify, hakrevdns, gf, fff, httprobe, anew, unfurl, qsreplace, meg, goop, hakcheckurl, sdlookup, metabigor, xurlfind3r, subjs, jsubfinder, getJS, rayder |
| `--dns` | massdns, puredns, DNSRecon |
| `--screenshots` | gowitness, Chromium |
| `--metasploit` | Arch package; separate upstream installation on Ubuntu |
| `--passwords` | John the Ripper (`john`), hashcat, hashcat-utils, Hydra, clinfo |
| `--network` | tcpdump, tshark (`wireshark-cli`), socat, mtr, iperf3, traceroute, ethtool, nethogs |
| `--web` | sqlmap, mitmproxy, testssl.sh, nikto |
| `--wireless` | aircrack-ng, iw, hcxtools |
| `--forensics` | binwalk, foremost, Sleuth Kit, ExifTool, YARA |
| `--reverse` | radare2, GDB, strace, ltrace, checksec, hexedit |
| `--audit` | Lynis, ShellCheck |
| `--crypto` | age, GnuPG, OpenSSL |
| `--wireshark-gui` | Wireshark Qt interface |
| `--antivirus` | ClamAV |

System tools use the distribution repositories. `--all` selects every group in
the table, including GUI applications; prefer `--server` on a remote machine.
The hardware-related `--opencl-cpu` option remains explicit.

## Choosing tools for everyday tasks

| Task | Group and examples |
| --- | --- |
| Recover passwords or audit password strength | `--passwords`: John and Hashcat for hashes; Hydra for authentication testing |
| Diagnose connectivity and traffic | `--network`: mtr/traceroute for routes, iperf3 for bandwidth, tcpdump/tshark for packets, nethogs for per-process traffic |
| Inspect HTTP and TLS behavior | `--web`: mitmproxy for HTTP inspection, testssl.sh for TLS checks; Nikto and SQLmap for web security testing |
| Examine Wi-Fi configuration and captures | `--wireless`: iw, aircrack-ng and hcxtools |
| Inspect files, metadata and disk images | `--forensics`: ExifTool for metadata, binwalk for embedded data, foremost for recovery, Sleuth Kit for filesystem analysis, YARA for matching rules |
| Debug programs and examine binaries | `--reverse`: GDB/radare2, strace/ltrace, checksec and hexedit |
| Review local configuration and scripts | `--audit`: Lynis for system auditing and ShellCheck for shell scripts |
| Encrypt files and inspect certificates | `--crypto`: age, GnuPG and OpenSSL |

## Hashcat compute runtime

Installing Hashcat alone does not guarantee a working compute device. Its
[upstream requirements](https://hashcat.net/hashcat/) depend on your CPU/GPU and
driver stack. Inspect available devices after installation:

```bash
hashcat -I
clinfo
```

For CPU OpenCL support, explicitly select PoCL:

```bash
./setup/sectools.sh --passwords --opencl-cpu --dry-run
./setup/sectools.sh --passwords --opencl-cpu
```

PoCL brings additional compiler/runtime dependencies. GPU runtimes are not
automatically selected: use the runtime appropriate to your hardware, following
the [Arch GPGPU documentation](https://wiki.archlinux.org/title/GPGPU).
Wordlists are not downloaded automatically.

## Dependencies and updates

Only selected groups and their dependencies are installed. Go groups need Go,
Git, GCC and Make for source builds. DNSRecon also needs pipx, which keeps
its Python dependencies isolated from system Python and project environments.
Chromium is only selected by `--screenshots`; Metasploit is only selected by
`--metasploit`. `--all` includes both.

Pacman uses `-S --needed` with the existing package databases. Keep your Arch
installation fully updated. To refresh databases and upgrade the entire system
in the same transaction, explicitly add `--upgrade-system`. Pacman displays
transitive dependencies before asking for confirmation. The installer does not
use `--noconfirm` or configure AUR/BlackArch.

On Ubuntu, it runs `apt-get update`, checks package candidates, then uses
`apt-get install --no-install-recommends`. `--upgrade-system` additionally runs
`apt-get upgrade`; otherwise no general system upgrade is requested, although
APT may upgrade requested packages or required dependencies. Unavailable
packages are reported, remaining packages are installed, and the script exits
with status 1 to indicate an incomplete selection. It does not silently add
PPAs or other distributions' repositories. Many security packages require the
Ubuntu Universe component; check the reported package and your repository
configuration if a candidate is missing.

The script does not configure firewall rules, SSH, group memberships or services.
Distribution package installation scripts may start services or ask configuration
questions (for example iperf3, Wireshark or ClamAV). Review the package manager
transaction before confirming. No unattended `-y` mode is used.

Go builds set `GOTOOLCHAIN=auto`, allowing Go 1.21+ to fetch a newer toolchain
when required by a module, without replacing the system Go installation. See
[Go toolchain management](https://go.dev/doc/toolchain).

Go tools are installed from the module paths printed by `--dry-run`, using
`@latest`, except [Amass v5](https://owasp-amass.github.io/docs/), whose documented
source install uses `@main`. Amass is built without optional libpostal support.
[massdns](https://github.com/blechschmidt/massdns) is built from its upstream default
branch, and [DNSRecon](https://github.com/darkoperator/dnsrecon) is installed from
its upstream repository with pipx. These are moving versions, not a pinned,
reproducible toolchain. Older helper projects may fail with current Go versions;
failures are listed and produce a nonzero exit status. Rerunning a group updates
its source-installed tools; the package manager handles distribution packages.

## Shell configuration

User-installed executables live in a dedicated directory to avoid overwriting
other tools, including the unrelated Python executable also named `httpx`.
Add this line once to your shell configuration, or run it in the current shell:

```bash
export PATH="$HOME/.local/share/sectools/bin:$PATH"
```

Putting this directory first selects ProjectDiscovery's `httpx`. Activating a
Python environment may change that precedence; `command -v httpx` shows which
one will run. `SECTOOLS_HOME=/absolute/path` overrides the installation directory;
use the corresponding `bin` directory in PATH. The installer prints the exact
export command and does not edit your shell files.

## Tool-specific configuration

- PureDNS requires a resolver file supplied with its `--resolvers` option, and
  massdns must be on PATH. See the [PureDNS instructions](https://github.com/d3mondev/puredns).
- GF requires patterns in `~/.gf`; choose the patterns you need from the
  [upstream examples](https://github.com/tomnomnom/gf/tree/master/examples).
- JSubfinder needs its `.jsf_signatures.yaml` configuration. Follow its
  [upstream instructions](https://github.com/ThreatUnknown/jsubfinder). The Go
  module still uses the original `ThreatUnkown` spelling.
- API-backed tools such as Chaos and Notify need your own provider credentials
  or configuration. No credentials are written by this installer.
- Nuclei manages its templates separately. This installer only builds the CLI.
- Metasploit is available through the Arch package. On Ubuntu, `--metasploit`
  is reported as unavailable and produces exit status 1 (including with `--all`).
  Follow the [official Metasploit installer documentation](https://docs.metasploit.com/docs/using-metasploit/getting-started/nightly-installers.html)
  separately if needed. The script does not add Rapid7 repositories or initialize
  PostgreSQL.
- Ubuntu's `chromium-browser` package may install Chromium through Snap. Select
  `--screenshots` only if that fits your server; it is excluded from `--server`.
- Ubuntu's `john` package may offer fewer formats than Arch's Jumbo build. Check
  the installed build before assuming support for a particular hash format.
- Wireshark/tshark live capture may require membership in the `wireshark` group
  and a new login session. The installer does not change group memberships or
  capabilities. Reading existing capture files does not require live capture
  access. See [Arch's Wireshark documentation](https://wiki.archlinux.org/title/Wireshark).
- ClamAV needs a signature database. Configure/update it with `freshclam` before
  using `clamscan`; service setup and signature downloads remain separate. See
  [Arch's ClamAV documentation](https://wiki.archlinux.org/title/ClamAV).
- mitmproxy's certificate trust is configured separately for the client you
  intend to inspect; the installer does not add certificate authorities.
- Wireless capture capabilities depend on your adapter and driver. The installer
  does not change interface modes or stop network services.

## Difference from the old Debian installer

This restores the original Go utility list with Amass updated to v5, translates
system package names for Ubuntu and Arch, and adds massdns as PureDNS's required dependency.
DNSenum is not included: it is absent from the configured official Arch package
databases and needs additional Perl dependencies. No AUR helper or third-party
package repository is added just for it. DNSRecon is available via `--dns`.
There is no shared Python 3.10 environment or manually replaced system Go.

## Installer checks

`test_sectools.py` is an optional development test suite. It substitutes package
managers and downloads with local fixtures; it is not called by the installer
and is not needed to install or use the tools. It checks detection, failures and
checksum handling without installing system packages or accessing the network.

```bash
bash -n setup/sectools.sh
python3 setup/test_sectools.py
```

The tests use distribution fixtures and mocked commands to exercise detection,
package mapping, dry runs, missing packages and failure handling. They do not
install packages or prove that every upstream tool builds on every Ubuntu release.

## Latest stable Go

By default, Go comes from the distribution package manager. To select the latest
stable release published in the [official Go download metadata](https://go.dev/dl/?mode=json):

```bash
./setup/sectools.sh --server --go-latest --dry-run
./setup/sectools.sh --server --go-latest

# Install or update only the user-managed Go toolchain and its download dependencies.
./setup/sectools.sh --go-latest
```

This option supports Linux x86_64 and ARM64, installs curl/jq and archive/CA
dependencies, verifies the official SHA-256 before extraction, and stores Go in
`~/.local/share/sectools/toolchains/<version>-<architecture>`. The `go` symlink
inside `~/.local/share/sectools` selects the verified version. The distribution's
Go package and `/usr/local/go` are not replaced. Existing version directories are
reused; previous versions are retained. Download or checksum failure leaves the
previous selection intact. Dry runs do not fetch metadata or archives.

When combined with tool groups, builds explicitly use this Go executable. For
interactive use in future shells, add the printed export to your shell config:

```bash
export PATH="$HOME/.local/share/sectools/go/bin:$PATH"
go version
```

No release number is hardcoded: each real invocation queries the current stable
release. This option does not change the Python requirements for the DNS group.
