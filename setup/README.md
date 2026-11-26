# Security tools (Kali, Ubuntu and Arch)

`sectools.sh` installs security tools independently of the desktop installer. Run it from
the repository root as a regular user with sudo; with no arguments it only shows help.
It detects the system from `/etc/os-release` and uses `apt-get` (Kali, Ubuntu) or `pacman`
(Arch); source-built groups need Ubuntu 24.04+. Other systems are rejected.

## Quick start

```bash
./setup/sectools.sh --server --dry-run     # preview
./setup/sectools.sh --server               # base, recon, DNS, network and web
./setup/sectools.sh --passwords            # add groups at any time
export PATH="$HOME/.local/share/sectools/bin:$PATH"
```

`--dry-run` can preview another system with `--os=kali|ubuntu|arch`. `--all` selects every
group, including GUI apps; prefer `--server` on remote machines.

## Groups

| Group | Tools |
| --- | --- |
| `--base` | jq, curl, wget, nmap, whois, dig, net-tools, hping |
| `--recon` | subfinder, chaos, httpx, dnsx, nuclei, amass, ffuf, gau, waybackurls, assetfinder, mapcidr, asnmap |
| `--helpers` | notify, hakrevdns, gf, fff, httprobe, anew, unfurl, qsreplace, meg, goop, and others |
| `--dns` | massdns, puredns, DNSRecon |
| `--screenshots` | gowitness, Chromium |
| `--metasploit` | Kali and Arch packages; separate upstream install on Ubuntu |
| `--passwords` | John the Ripper, hashcat, hashcat-utils, Hydra, clinfo |
| `--network` | tcpdump, tshark, socat, mtr, iperf3, traceroute, ethtool, nethogs |
| `--web` | sqlmap, mitmproxy, testssl.sh, nikto |
| `--wireless` | aircrack-ng, iw, hcxtools |
| `--forensics` | binwalk, foremost, Sleuth Kit, ExifTool, YARA |
| `--reverse` | radare2, GDB, strace, ltrace, checksec, hexedit |
| `--audit` | Lynis, ShellCheck |
| `--crypto` | age, GnuPG, OpenSSL |
| `--wireshark-gui` | Wireshark |
| `--antivirus` | ClamAV |

## Behavior

- System packages come from the official repositories. Nothing runs unattended (no `-y`/`--noconfirm`), and no AUR, PPA or extra repository is added.
- `--upgrade-system` explicitly upgrades the whole system first.
- Go tools are built from source with `@latest` (Amass v5 from `@main`); DNSRecon is installed with pipx. Versions are not pinned.
- Missing packages or failed builds are reported, and the script exits with status 1.
- Firewall, SSH, groups, services, credentials, wordlists and tool templates are not configured.

## Notes

- Executables go to `~/.local/share/sectools/bin` (override with `SECTOOLS_HOME`). Putting it first in PATH selects ProjectDiscovery's `httpx` over the Python one.
- Hashcat needs a compute runtime: check with `hashcat -I`. `--opencl-cpu` adds PoCL; GPU runtimes are up to you.
- `--go-latest` installs the latest stable Go (SHA-256 verified) in `~/.local/share/sectools/toolchains` without replacing the system Go; add `~/.local/share/sectools/go/bin` to PATH.
- Some tools need their own setup: PureDNS resolvers, GF patterns, JSubfinder signatures, API keys for Chaos/Notify, `freshclam` for ClamAV, and the `wireshark` group for live capture.

## Tests

```bash
bash -n setup/sectools.sh
python3 setup/test_sectools.py   # mocked package managers; installs nothing
```
