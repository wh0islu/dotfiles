#!/usr/bin/env bash
# Standalone security-tool installer for Ubuntu and Arch Linux.
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./setup/sectools.sh [GROUPS] [--dry-run] [--upgrade-system]

Choose one or more groups:
  --base          jq, curl, wget, nmap/ncat, whois, bind, net-tools, hping
  --recon         Subfinder, Chaos, httpx, dnsx, Nuclei, Amass, ffuf,
                  gau, waybackurls, assetfinder, mapcidr, asnmap
  --helpers       Additional Go utilities from the original installer
  --dns           massdns, puredns, DNSRecon (isolated with pipx)
  --screenshots   gowitness and Chromium
  --metasploit    Metasploit (Arch package; separate upstream setup on Ubuntu)
  --passwords     John the Ripper, Hashcat, hashcat-utils, Hydra, clinfo
  --network       tcpdump, tshark, socat, mtr, iperf3, traceroute, ethtool, nethogs
  --web           SQLmap, mitmproxy, testssl.sh, Nikto
  --wireless      aircrack-ng, iw, hcxtools
  --forensics     binwalk, foremost, Sleuth Kit, ExifTool, YARA
  --reverse       radare2, GDB, strace, ltrace, checksec, hexedit
  --audit         Lynis and ShellCheck
  --crypto        age, GnuPG, OpenSSL
  --wireshark-gui Wireshark graphical interface
  --antivirus     ClamAV (signature download and services configured separately)
  --server        Base, recon, DNS, network and web tools (no GUI)
  --all           All groups above

Options:
  --dry-run       Print commands without downloads or changes
  --upgrade-system
                  Upgrade the system with apt-get upgrade or pacman -Syu
  --os=NAME       Preview ubuntu or arch; requires --dry-run
  --opencl-cpu    Add PoCL for CPU OpenCL support (not included in --all)
  --go-latest     Install the latest stable Go from go.dev in the user directory
  -h, --help      Show this help

No group selected: show help without installing anything.
Distribution is detected from /etc/os-release. Ubuntu 24.04+ is the target.
Run as your regular user; package installation uses sudo and asks for confirmation.
User tools: ~/.local/share/sectools/bin (or $SECTOOLS_HOME/bin).
Rerunning installs the latest upstream Go tools and updates DNSRecon.
EOF
}

base=false recon=false helpers=false dns=false screenshots=false metasploit=false
passwords=false network=false web=false wireless=false forensics=false reverse=false
audit=false crypto=false wireshark_gui=false antivirus=false opencl_cpu=false
dry_run=false upgrade_system=false selected=false
go_latest=false
preview_os=
for arg in "$@"; do
    case "$arg" in
        --base) base=true; selected=true ;;
        --recon) recon=true; selected=true ;;
        --helpers) helpers=true; selected=true ;;
        --dns) dns=true; selected=true ;;
        --screenshots) screenshots=true; selected=true ;;
        --metasploit) metasploit=true; selected=true ;;
        --passwords) passwords=true; selected=true ;;
        --network) network=true; selected=true ;;
        --web) web=true; selected=true ;;
        --wireless) wireless=true; selected=true ;;
        --forensics) forensics=true; selected=true ;;
        --reverse) reverse=true; selected=true ;;
        --audit) audit=true; selected=true ;;
        --crypto) crypto=true; selected=true ;;
        --wireshark-gui) wireshark_gui=true; selected=true ;;
        --antivirus) antivirus=true; selected=true ;;
        --opencl-cpu) opencl_cpu=true; selected=true ;;
        --go-latest) go_latest=true; selected=true ;;
        --server) base=true recon=true dns=true network=true web=true; selected=true ;;
        --os=*) preview_os=${arg#--os=} ;;
        --all)
            base=true recon=true helpers=true dns=true screenshots=true metasploit=true
            passwords=true network=true web=true wireless=true forensics=true reverse=true
            audit=true crypto=true wireshark_gui=true antivirus=true
            selected=true ;;
        --dry-run) dry_run=true ;;
        --upgrade-system) upgrade_system=true ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
    esac
done
if ! "$selected"; then usage; exit 0; fi

# Match exact distribution IDs; related distributions are not assumed compatible.
if [[ -n $preview_os ]]; then
    if ! "$dry_run"; then
        echo '--os is only supported with --dry-run.' >&2
        exit 2
    fi
    ID=$preview_os
    VERSION_ID=preview
    PRETTY_NAME="$preview_os (preview)"
else
    if [[ ! -r /etc/os-release ]]; then
        echo 'Cannot detect this operating system: /etc/os-release is missing.' >&2
        exit 1
    fi
    # shellcheck disable=SC1091
    source /etc/os-release
fi
case ${ID:-} in
    ubuntu) package_manager=apt-get ;;
    arch) package_manager=pacman ;;
    *) printf 'Unsupported distribution: %s. Supported: Ubuntu and Arch Linux.\n' "${ID:-unknown}" >&2; exit 1 ;;
esac
printf 'Detected: %s; package manager: %s\n' "${PRETTY_NAME:-$ID}" "$package_manager"
if [[ $ID == ubuntu && ${VERSION_ID:-} != preview ]] &&
    { "$recon" || "$helpers" || "$dns" || "$screenshots"; }; then
    if [[ ! ${VERSION_ID:-} =~ ^[0-9]+\.[0-9]+$ ]] || (( ${VERSION_ID%%.*} < 24 )); then
        echo 'Source-tool groups require Ubuntu 24.04+ (Go 1.21+ and Python 3.12+). No changes made.' >&2
        exit 1
    fi
fi

tool_home=${SECTOOLS_HOME:-"$HOME/.local/share/sectools"}
if [[ $tool_home != /* ]]; then
    echo 'SECTOOLS_HOME must be an absolute path.' >&2
    exit 2
fi
tool_bin="$tool_home/bin"
packages=()
go_tools=()
if "$base"; then packages+=(jq curl wget nmap whois bind net-tools hping); fi
if "$recon" || "$helpers" || "$dns" || "$screenshots"; then
    packages+=(git gcc make)
    if ! "$go_latest"; then packages+=(go); fi
fi
if "$go_latest"; then packages+=(curl jq ca-certificates tar gzip); fi
if "$dns"; then packages+=(python-pipx); fi
if "$screenshots"; then packages+=(chromium); fi
if "$metasploit"; then packages+=(metasploit); fi
if "$passwords"; then packages+=(john hashcat hashcat-utils hydra clinfo); fi
if "$network"; then packages+=(tcpdump wireshark-cli socat mtr iperf3 traceroute ethtool nethogs); fi
if "$web"; then packages+=(sqlmap mitmproxy testssl.sh nikto); fi
if "$wireless"; then packages+=(aircrack-ng iw hcxtools); fi
if "$forensics"; then packages+=(binwalk foremost sleuthkit perl-image-exiftool yara); fi
if "$reverse"; then packages+=(radare2 gdb strace ltrace checksec hexedit); fi
if "$audit"; then packages+=(lynis shellcheck); fi
if "$crypto"; then packages+=(age gnupg openssl); fi
if "$wireshark_gui"; then packages+=(wireshark-qt); fi
if "$antivirus"; then packages+=(clamav); fi
if "$opencl_cpu"; then packages+=(pocl); fi

failures=()
if [[ $ID == ubuntu ]]; then
    ubuntu_packages=()
    for package in "${packages[@]}"; do
        case $package in
            bind) ubuntu_packages+=(dnsutils) ;;
            hping) ubuntu_packages+=(hping3) ;;
            nmap) ubuntu_packages+=(nmap ncat) ;;
            go) ubuntu_packages+=(golang-go ca-certificates) ;;
            python-pipx) ubuntu_packages+=(pipx python3-venv python3-dev) ;;
            wireshark-cli) ubuntu_packages+=(tshark) ;;
            wireshark-qt) ubuntu_packages+=(wireshark) ;;
            mtr) ubuntu_packages+=(mtr-tiny) ;;
            perl-image-exiftool) ubuntu_packages+=(libimage-exiftool-perl) ;;
            pocl) ubuntu_packages+=(pocl-opencl-icd) ;;
            chromium) ubuntu_packages+=(chromium-browser) ;;
            metasploit)
                echo 'UNAVAILABLE: Metasploit needs separate upstream installation on Ubuntu; see setup/README.md.' >&2
                failures+=(metasploit)
                ;;
            *) ubuntu_packages+=("$package") ;;
        esac
    done
    packages=("${ubuntu_packages[@]}")
fi

if "$recon"; then
    go_tools+=(
        github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
        github.com/projectdiscovery/chaos-client/cmd/chaos@latest
        github.com/projectdiscovery/httpx/cmd/httpx@latest
        github.com/projectdiscovery/dnsx/cmd/dnsx@latest
        github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
        github.com/owasp-amass/amass/v5/cmd/amass@main
        github.com/ffuf/ffuf/v2@latest
        github.com/lc/gau/v2/cmd/gau@latest
        github.com/tomnomnom/waybackurls@latest
        github.com/tomnomnom/assetfinder@latest
        github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
        github.com/projectdiscovery/asnmap/cmd/asnmap@latest
    )
fi
if "$helpers"; then
    go_tools+=(
        github.com/projectdiscovery/notify/cmd/notify@latest
        github.com/hakluke/hakrevdns@latest
        github.com/tomnomnom/gf@latest
        github.com/tomnomnom/fff@latest
        github.com/tomnomnom/httprobe@latest
        github.com/tomnomnom/anew@latest
        github.com/tomnomnom/unfurl@latest
        github.com/tomnomnom/qsreplace@latest
        github.com/tomnomnom/meg@latest
        github.com/deletescape/goop@latest
        github.com/hakluke/hakcheckurl@latest
        github.com/j3ssie/sdlookup@latest
        github.com/j3ssie/metabigor@latest
        github.com/hueristiq/xurlfind3r/cmd/xurlfind3r@latest
        github.com/lc/subjs@latest
        github.com/ThreatUnkown/jsubfinder@latest
        github.com/003random/getJS@latest
        github.com/devanshbatham/rayder@latest
    )
fi
if "$dns"; then go_tools+=(github.com/d3mondev/puredns/v2@latest); fi
if "$screenshots"; then go_tools+=(github.com/sensepost/gowitness@latest); fi

run() {
    printf '+'
    printf ' %q' "$@"
    printf '\n'
    if ! "$dry_run"; then "$@"; fi
}

if ! "$dry_run"; then
    if (( EUID == 0 )); then
        echo 'Run as your regular user, without sudo.' >&2
        exit 1
    fi
    if ! command -v "$package_manager" >/dev/null; then
        printf 'Required package manager not found: %s\n' "$package_manager" >&2
        exit 1
    fi
fi

echo 'System packages and dependencies will be shown before confirmation.'
if [[ $ID == ubuntu ]]; then
    if ((${#packages[@]})); then
        run sudo apt-get update
        if ! "$dry_run"; then
            available=()
            for package in "${packages[@]}"; do
                candidate=$(LC_ALL=C apt-cache policy "$package" | awk '/Candidate:/ {print $2}')
                if [[ -n $candidate && $candidate != '(none)' ]]; then
                    available+=("$package")
                else
                    printf 'UNAVAILABLE: %s (check Ubuntu release and Universe/Multiverse repositories).\n' "$package" >&2
                    failures+=("$package")
                fi
            done
            packages=("${available[@]}")
        else
            echo 'Package candidates will be checked after apt-get update during installation.'
        fi
    fi
    if "$upgrade_system"; then run sudo apt-get upgrade; fi
    if ((${#packages[@]})); then
        run sudo apt-get install --no-install-recommends "${packages[@]}"
    fi
else
    pacman_mode=-S
    if "$upgrade_system"; then
        pacman_mode=-Syu
        echo 'Full system upgrade selected.'
    else
        echo 'Using existing package databases. Keep Arch fully updated; this does not refresh databases.'
    fi
    run sudo pacman "$pacman_mode" --needed "${packages[@]}"
fi

install_latest_go() (
    # Stage on the destination filesystem; publish only after checksum verification.
    set -euo pipefail
    case $(uname -m) in
        x86_64) go_arch=amd64 ;;
        aarch64|arm64) go_arch=arm64 ;;
        *) echo 'Latest Go installation currently supports x86_64 and arm64.' >&2; exit 1 ;;
    esac
    if "$dry_run"; then
        echo "Would query https://go.dev/dl/?mode=json for the latest stable Linux/$go_arch archive."
        echo "Would verify its SHA-256, extract into $tool_home/toolchains, and update $tool_home/go."
        exit 0
    fi
    mkdir -p "$tool_home/toolchains"
    stage=$(mktemp -d "$tool_home/toolchains/.download.XXXXXXXX")
    trap 'rm -rf -- "$stage"' EXIT
    curl --fail --location --proto '=https' --proto-redir '=https' --retry 3 \
        'https://go.dev/dl/?mode=json' -o "$stage/releases.json"
    record=$(jq -er --arg arch "$go_arch" '
        [.[] | select(.stable == true)][0].files[] |
        select(.os == "linux" and .arch == $arch and .kind == "archive") |
        [.version, .filename, .sha256] | @tsv' "$stage/releases.json")
    IFS=$'\t' read -r version filename checksum <<< "$record"
    [[ $version =~ ^go[0-9]+\.[0-9]+\.[0-9]+$ &&
       $filename == "$version.linux-$go_arch.tar.gz" &&
       $checksum =~ ^[0-9a-f]{64}$ ]] || { echo 'Invalid Go release metadata.' >&2; exit 1; }
    destination="$tool_home/toolchains/$version-$go_arch"
    if [[ -e $tool_home/go && ! -L $tool_home/go ]]; then
        echo "Refusing to replace a non-symlink: $tool_home/go" >&2
        exit 1
    fi
    if [[ ! -e $destination ]]; then
        curl --fail --location --proto '=https' --proto-redir '=https' --retry 3 \
            "https://go.dev/dl/$filename" -o "$stage/archive.tar.gz"
        if ! printf '%s  %s\n' "$checksum" "$stage/archive.tar.gz" | sha256sum --check --status; then
            echo 'Go archive checksum mismatch; keeping the previous installation.' >&2
            exit 1
        fi
        tar -xzf "$stage/archive.tar.gz" -C "$stage" --no-same-owner
        env -u GOROOT GOTOOLCHAIN=local "$stage/go/bin/go" version
        mv -T "$stage/go" "$destination"
    fi
    env -u GOROOT GOTOOLCHAIN=local "$destination/bin/go" version
    ln -s "$destination" "$stage/current"
    mv -Tf "$stage/current" "$tool_home/go"
)

go_command=go
if "$go_latest"; then
    install_latest_go
    go_command="$tool_home/go/bin/go"
fi
if ((${#go_tools[@]})); then
    run mkdir -p "$tool_bin"
fi
for module in "${go_tools[@]}"; do
    # Amass supports a pure-Go build without the optional libpostal dependency.
    cgo=1
    if [[ $module == github.com/owasp-amass/amass/* ]]; then cgo=0; fi
    if ! run env -u GOROOT GOBIN="$tool_bin" CGO_ENABLED="$cgo" GOTOOLCHAIN=auto "$go_command" install "$module"; then
        failures+=("$module")
    fi
done

build_dir=''
cleanup() {
    if [[ -n $build_dir ]]; then rm -rf -- "$build_dir"; fi
}
trap cleanup EXIT

install_massdns() {
    if "$dry_run"; then
        local source_dir='<temporary-directory>/massdns'
    else
        build_dir=$(mktemp -d) || return
        local source_dir="$build_dir/massdns"
    fi
    run git clone --depth 1 https://github.com/blechschmidt/massdns.git "$source_dir" || return
    run make -C "$source_dir" || return
    run install -m 755 "$source_dir/bin/massdns" "$tool_bin/massdns"
}

if "$dns"; then
    if ! install_massdns; then failures+=(massdns); fi
    if ! run env PIPX_HOME="$tool_home/pipx" PIPX_BIN_DIR="$tool_bin" \
        pipx install --force 'git+https://github.com/darkoperator/dnsrecon.git'; then
        failures+=(dnsrecon)
    fi
fi

if ((${#go_tools[@]})); then
    printf '\nAdd this directory to your shell PATH to use the user tools:\n'
    printf 'export PATH=%q:"$PATH"\n' "$tool_bin"
fi
if "$go_latest"; then
    printf '\nTo use the downloaded Go in new shells, add:\n'
    printf 'export PATH=%q:"$PATH"\n' "$tool_home/go/bin"
fi
if "$dns"; then echo 'PureDNS needs a resolver list; see setup/README.md.'; fi
if "$helpers"; then echo 'GF patterns and JSubfinder signatures require configuration; see setup/README.md.'; fi
if "$metasploit"; then echo 'Metasploit selection covers the package only; database and service setup are separate.'; fi
if "$passwords"; then
    echo 'Hashcat needs a compatible compute runtime. Check devices with hashcat -I; see setup/README.md.'
fi
if "$antivirus"; then echo 'ClamAV needs signatures before scanning; see setup/README.md.'; fi
if "$network" || "$wireshark_gui"; then
    echo 'Live packet capture permissions are configured separately; see setup/README.md.'
fi
if ((${#failures[@]})); then
    printf '\nUnavailable or failed installations:\n'
    printf '  %s\n' "${failures[@]}" >&2
    exit 1
fi
if "$dry_run"; then
    echo 'Dry run complete. No changes made.'
else
    echo 'Selected installations completed.'
fi
