#!/usr/bin/bash

blue="\e[34m"
green="\e[32m"
red="\e[31m"
reset="\e[97m"

sudo apt update 1>/dev/null 2>/dev/null

check_file_exists() {
    local file="$1"
    [ -f "$file" ]
}

install_app() {
    local appname="$1"
    local app="$2"
    echo "${blue}🚀[+]${reset} Installing ${appname}${blue}[+]${reset}"
    sudo apt install "$app" -y 1>/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "${red}❌[!]${reset} Failed to install ${appname} ${red}[!]${reset}"
    else
        echo "${green}✅[!]${reset} ${appname} installed successfully ${green}[!]${reset}"
    fi
}

go_tool() {
    local tool_name="$1"
    local tool="$2"
    echo "${blue}🔧[+]${reset} Installing ${tool_name} ${blue}[+]${reset}"
    go install "$tool@latest"
}

install_go() {
    read -p "Would you like to install Go? [y/N] " answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo "${red}❓[!]${reset} Enter the version of Go you want to install (e.g., 1.17.5) ${red}[!]${reset} > "
        read -r go_version
        echo "${red}🔑[!]${reset} Please enter the SHA256 hash for the downloaded file ${red}[!]${reset} > "
        read -r official_sha256
        local filename="go${go_version}.linux-amd64.tar.gz"
        if check_file_exists "$filename"; then
            echo "⏭️ Skipping download as $filename already exists."
        else
            wget -q --show-progress "https://golang.org/dl/go${go_version}.linux-amd64.tar.gz"
            if [ $? -ne 0 ]; then
                echo "${blue}❌[!]${reset} Failed to download ${filename}. Exiting. ${blue}[!]${reset}"
                return
            fi
        fi
        go_sha256=$(sha256sum "$filename" | awk '{print $1}')
        if [ "$go_sha256" = "$official_sha256" ]; then
            echo "${green}✅[*****]${reset}\n$go_sha256\n$official_sha256\n${green}[*****]${reset}"
            echo "${green}✅[!]${reset} Hash match ${green}[!]${reset}"
            echo "${blue}🚀[+]${reset} Installing Go ${blue}[+]${reset}"

            sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$filename"
            if [ -f "$HOME/.zshrc" ]; then
                echo "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.zshrc"
                export PATH=$PATH:/usr/local/go/bin
                . "$HOME/.zshrc"
                if command -v go &>/dev/null; then
                    go version
                    echo "${green}✅[!]${reset} Done. Go installed ${green}[!]${reset}"
		    install_sectools
		    echo "export PATH=\$PATH:\$HOME/go/bin" >> "$HOME/.zshrc"
                    sleep 1
                else
                    echo "${red}❌[!]${reset} Failed to install Go ${red}[!]${reset}"
                fi
            elif [ -f "$HOME/.bashrc" ]; then
                echo "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.bashrc"
                . "$HOME/.bashrc"
                export PATH=$PATH:/usr/local/go/bin
                if command -v go &>/dev/null; then
                    go version
                    echo "${green}✅[!]${reset} Done. Go installed ${green}[!]${reset}"
		    install_sectools
		    echo "export PATH=\$PATH:\$HOME/go/bin" >> "$HOME/.bashrc"
                    sleep 1
                else
                    echo "${red}❌[!]${reset} Failed to install Go ${red}[!]${reset}"
                fi
            fi
        else
            echo "${red}❌[!]${reset} Hash does not match ${red}[!]${reset}"
        fi
    else
        echo "${blue}⏩[*]${reset} Skipping Go installation ${blue}[*]${reset}"
    fi
}
install_sectools() {
    source "$HOME/.bashrc" 2>/dev/null || source "$HOME/.zshrc" 2>/dev/null
    go_tool "Subfinder" "github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
    go_tool "Chaos" "github.com/projectdiscovery/chaos-client/cmd/chaos"
    go_tool "Httpx" "github.com/projectdiscovery/httpx/cmd/httpx"
    go_tool "DNSX" "github.com/projectdiscovery/dnsx/cmd/dnsx"
    go_tool "Nuclei" "github.com/projectdiscovery/nuclei/v3/cmd/nuclei"
    go_tool "Notify" "github.com/projectdiscovery/notify/cmd/notify"
    go_tool "Gowitness" "github.com/sensepost/gowitness"
    go_tool "Hakrevdns" "github.com/hakluke/hakrevdns"
    go_tool "Waybackurls" "github.com/tomnomnom/waybackurls"
    go_tool "Assetfinder" "github.com/tomnomnom/assetfinder"
    go_tool "GF" "github.com/tomnomnom/gf"
    go_tool "fff" "github.com/tomnomnom/fff"
    go_tool "Httprobe" "github.com/tomnomnom/httprobe"
    go_tool "Anew" "github.com/tomnomnom/anew"
    go_tool "Unfurl" "github.com/tomnomnom/unfurl"
    go_tool "qsreplace" "github.com/tomnomnom/qsreplace"
    go_tool "Meg" "github.com/tomnomnom/meg"
    go_tool "gau" "github.com/lc/gau/v2/cmd/gau"
    go_tool "Goop" "github.com/deletescape/goop"
    go_tool "Hakcheckrul" "github.com/hakluke/hakcheckurl"
    go_tool "sdlookup" "github.com/j3ssie/sdlookup"
    go_tool "Metabigor" "github.com/j3ssie/metabigor"
    go_tool "PureDNS" "github.com/d3mondev/puredns/v2"
    go_tool "xurlfind3r" "github.com/hueristiq/xurlfind3r/cmd/xurlfind3r"
    go_tool "subjs" "github.com/lc/subjs"
    go_tool "JSubfinder" "github.com/ThreatUnkown/jsubfinder"
    go_tool "getJS" "github.com/003random/getJS"
    go_tool "Mapcidr" "github.com/projectdiscovery/mapcidr/cmd/mapcidr"
    go_tool "Amass" "github.com/owasp-amass/amass/v4/..."
    go_tool "ffuf" "github.com/ffuf/ffuf/v2"
    go_tool "rayder" "github.com/devanshbatham/rayder"
    go_tool "asnmap" "github.com/projectdiscovery/asnmap/cmd/asnmap"
}

core() {
    install_go
    echo "${blue}🐍[*]${reset} Setting up Python environment"
    install_app "Python 3" "python3"
    install_app "Python venv" "python3.12-venv"
    install_app "Pip" "python3-pip"
    
    echo "${blue}📦[*]${reset} Setting up Virtual Environment"
    mkdir -p "$HOME/.virtualenvs" && python3 -m venv "$HOME/.virtualenvs/sec"
    source "$HOME/.virtualenvs/sec/bin/activate"
    pip install --upgrade pip 1>/dev/null 2>pip_error.log
    
    echo "${blue}🔧[*]${reset} Installing apt tools"
    install_app "jq" "jq"
    install_app "git" "git"
    install_app "curl" "curl"
    install_app "wget" "wget"
    install_app "nmap" "nmap"
    install_app "whois" "whois"
    install_app "host" "host"
    install_app "net-tools" "net-tools"
    install_app "dnsenum" "dnsenum"
    install_app "dnsrecon" "dnsrecon"
    install_app "hping3" "hping3"
    install_app "ncat" "ncat"
}

core
