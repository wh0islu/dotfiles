#!/usr/bin/bash

blue="\e[34m"
green="\e[32m"
red="\e[31m"
reset="\e[97m"

sudo apt update 1>/dev/null 2>/dev/null

install_app() {
    local appname="$1"
    local app="$2"
    echo "${blue}🚀[+]${reset} Installing ${appname}${blue}[+]${reset}"
    sudo apt install "$app" -y
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

install_go() {
    read -p "Would you like to install Go? [y/N] " answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo "${red}❓[!]${reset} Enter the version of Go you want to install (e.g., 1.17.5) ${red}[!]${reset} > "
        read -r go_version
        echo "${red}🔑[!]${reset} Please enter the SHA256 hash for the downloaded file ${red}[!]${reset} > "
        read -r official_sha256
        local filename="go${go_version}.linux-amd64.tar.gz"
        if [ -f "$filename" ]; then
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
            echo "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.profile"
            export PATH=$PATH:/usr/local/go/bin
            source "$HOME/.profile"

            if command -v go &>/dev/null; then
                go version
                echo "${green}✅[!]${reset} Done. Go installed ${green}[!]${reset}"
                sleep 1
            else
                echo "${red}❌[!]${reset} Failed to install Go ${red}[!]${reset}"
            fi
        else
            echo "${red}❌[!]${reset} Hash does not match ${red}[!]${reset}"
        fi
    else
        echo "${blue}⏩[*]${reset} Skipping Go installation ${blue}[*]${reset}"
    fi
}

zsh_config() {
    chsh -s $(which zsh)
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    zsh
}
core() {
    echo
    sleep 1
    echo "${blue}🐍[*]${reset} Python settings ${blue}[*]${reset}"
    install_app "Python v3" "python3"
    install_app "Python Venv" "python3.12-venv"
    install_app "UFW" "ufw"
    install_app "Tree" "tree"
    install_app "7zip" "p7zip-full"
    install_app "Transmission" "transmission-cli"
    install_app "Git" "git"
    install_app "xbindkeys" "xbindkeys"
    install_app "ninja-build" "ninja-build"
    install_app "gettext" "gettext"
    install_app "cmake" "cmake"
    install_app "unzip" "unzip"
    install_app "curl" "curl"
    install_app "latexmk" "latexmk"
    install_app "zathura" "zathura"
    install_app "zathura-pdf-poppler" "zathura-pdf-poppler"
    install_app "build-essential" "build-essential"
    install_app "neofetch" "neofetch"
    install_app "zsh" "zsh"
    install_app "openvpn" "openvpn"
    install_app "ipcalc" "ipcalc"
    echo "${green}✅[*]${reset} Done. ${green}[*]${reset}"
    sleep 1

    echo "${blue}🚀[+]${reset} Neovim installation ${blue}[+]${reset}"
    neovim_config
    echo "${blue}🚀[+]${reset} Go installation ${blue}[+]${reset}"
    install_go
    echo "${blue}🚀[+]${reset} ZSH config ${blue}[+]${reset}"
    zsh_config
    echo "${green}✅[*]${reset} Done. ${green}[*]${reset}"
}

core
