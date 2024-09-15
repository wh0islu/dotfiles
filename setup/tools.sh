#!/usr/bin/bash

blue="\e[34m"
green="\e[32m"
red="\e[31m"
reset="\e[97m"

check_file_exists() {
    local file="$1"
    [ -f "$file" ]
}

install_app() {
    local appname="$1"
    local app="$2"
    echo "${blue}🚀[+]${reset} Installing ${appname}${blue}[+]${reset}"
    sudo apt install $app -y
}

neovim_config() {
    echo "${blue}🔧[+]${reset} Installing prerequisites for Neovim ${blue}[+]${reset}"
    sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential || {
        echo "${red}❌[!]${reset} Failed to install prerequisites ${red}[!]${reset}"
        exit 1
    }

    echo "${blue}📥[+]${reset} Cloning Neovim repository ${blue}[+]${reset}"
    cd $HOME
    git clone https://github.com/neovim/neovim || {
        echo "${red}❌[!]${reset} Failed to clone Neovim repository ${red}[!]${reset}"
        exit 1
    }

    echo "${blue}⚙️[+]${reset} Building Neovim ${blue}[+]${reset}"
    cd neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo || {
        echo "${red}❌[!]${reset} Failed to build Neovim ${red}[!]${reset}"
        exit 1
    }

    echo "${blue}✅[+]${reset} Checking out stable branch ${blue}[+]${reset}"
    git checkout stable || {
        echo "${red}❌[!]${reset} Failed to checkout stable branch ${red}[!]${reset}"
        exit 1
    }
    sudo make install
    echo "${green}🎉[+]${reset} Neovim installation complete ${green}[+]${reset}"
}

echo "${blue}🔄[*]${reset} Update and upgrade ${blue}[*]${reset}"
sudo apt update && sudo apt upgrade -y

install_go() {
    echo "${red}❌[!]${reset} Go isn't installed ${red}[!]${reset}"
    read -p "Would you like to install Go? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
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

if ! command -v go &>/dev/null; then
    install_go
else
    echo "${green}✅[*]${reset} Go is already installed ${green}[*]${reset}"
    echo "${blue}⏩[*]${reset} Skipping Go installation ${blue}[*]${reset}"
fi

clear
sleep 1
echo "${blue}📦[*]${reset} Install applications ${blue}[*]${reset}"
install_app "Python v3" "python3"
install_app "Python Venv" "python3.12-venv"
install_app "UFW" "ufw"
install_app "Tree" "tree"
install_app "7zip" "7zip"
install_app "Transmission" "transmission"
install_app "Git" "git"
install_app "xbindkeys" "xbindkeys"
install_app "ninja-build" "ninja-build"
install_app "gettext" "gettext"
install_app "cmake" "cmake"
install_app "unzip" "unzip"
install_app "curl" "curl"
install_app "build-essential" "build-essential"
install_app "neofetch" "neofetch"
echo "${green}✅[*]${reset} Done. ${green}[*]${reset}"
sleep 1
clear

echo "${blue}🚀[+]${reset} Neovim installation ${blue}[+]${reset}"
neovim_config
echo "${green}✅[*]${reset} Done. ${green}[*]${reset}"

