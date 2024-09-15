#!/usr/bin/bash

blue="\e[34m"
green="\e[32m"
red="\e[31m"
reset="\e[97m"


install_app(){
    local appname="$1"
    local app="$2"
    echo "$blue[+]$reset Installing $appname"
    sudo apt install $app -y 1>/dev/null 2>error.log
}

neovim_config(){
    echo -e "$blue[+]$reset Installing prerequisites for Neovim$[+]$reset"
    sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential || {
        echo -e "$red[!]$reset Failed to install prerequisites $red[!]$reset"
        exit 1
    }

    echo -e "$blue[+]$reset Cloning Neovim repository $blue[]$rest"
    cd $HOME
    git clone https://github.com/neovim/neovim || {
        echo -e "$red[!]$reset Failed to clone Neovim repository $red[!]$reset"
        exit 1
    }

    echo -e "$blue[+]$reset Building Neovim $blue[+]$reset"
    cd neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo || {
        echo -e "$red[!]$reset Failed to build Neovim $blue[]$reset"
        exit 1
    }

    echo -e "$blue[+]$reset Checking out stable branch $blue[+]$reset"
    git checkout stable || {
        echo -e "$red[!]$reset Failed to checkout stable branch $red[!]$reset"
        exit 1
    }

    echo -e "$green[+]$reset Neovim installation complete $green[+]$reset"
}

echo "$blue[*]$reset Update and upgrade $blue[*]$reset"
sudo apt update && sudo apt upgrade -y
# Correção do bloco de instalação do Go
install_go() {
    echo "$red[!]$reset Go isn't installed $red[!]$reset"
    sleep 1
    echo "$red[!]$reset Enter the version of Go you want to install (e.g., 1.17.5) $red[!]$reset > "
    read -r go_version
    echo "$red[!]$reset Please enter the SHA256 hash for the downloaded file $red[!]$reset > "
    read -r official_sha256
    local filename="go${go_version}.linux-amd64.tar.gz"
    if [ -f "$filename" ]; then
        echo "Skipping download as $filename already exists."
    else
        wget -q --show-progress "https://golang.org/dl/go${go_version}.linux-amd64.tar.gz"
        if [ $? -ne 0 ]; then
            echo "$blue[!]$reset Failed to download $filename. Exiting. $blue[!]$reset"
            return
        fi
    fi
    go_sha256=$(sha256sum "$filename" | awk '{print $1}')
    if [ "$go_sha256" = "$official_sha256" ]; then
        echo "$green[*****]$reset\n$go_sha256\n$official_sha256\n$green[*****]$reset"
        echo "$green[!]$reset Hash match $green[!]$reset"
        echo "$blue[+]$reset Installing Go $blue[+]$reset"

        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$filename"
        if [ -f "$HOME/.zshrc" ]; then
            echo "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.zshrc"
            export PATH=$PATH:/usr/local/go/bin
            . "$HOME/.zshrc"
            if command -v go &>/dev/null; then
                go version
                echo "$green[!]$reset Done. Go installed $green[!]$reset"
                sleep 1
            else
                echo "$red[!]$reset Failed to install Go $red[!]$reset"
            fi
        elif [ -f "$HOME/.bashrc" ]; then
            echo "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.bashrc"
            . "$HOME/.bashrc"
            export PATH=$PATH:/usr/local/go/bin
            if command -v go &>/dev/null; then
                go version
                echo "$green[!]$reset Done. Go installed $green[!]$reset"
                sleep 1
            else
                echo "$red[!]$reset Failed to install Go $red[!]$reset"
            fi
        fi
    else
        echo "$red[!]$reset Hash does not match $red[!]$reset"
    fi
}
if [ -d "/usr/local/go" ]; then
    echo "$green[*]$reset Go is already installed $green[*]$reset"
    sleep 1
else
    install_go
    sleep 1
    echo "$blue[*]$reset Done $blue[*]$reset"
    echo "$blue[*]$reset Moving tools to /usr/bin/$blue[*]$reset" 
    sudo mv "$HOME"/go/bin/* /usr/bin/
fi

clear
sleep 1
echo "$blue[*]$reset Install applications $blue[*]$reset"
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
echo "$green[*]$reset Done. $green[*]$reset"
sleep 1
clear

echo -e "$blue[+]$reset Neovim installation $blue[+]$reset"
neovim_config
echo -e "$green[*]$reset Done. $green[*]$reset"
