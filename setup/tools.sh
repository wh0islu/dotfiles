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
    cd $HOME
    git clone https://github.com/neovim/neovim
    cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
    git checkout stable
    sudo make install
}

echo "$blue[*]$reset Update and upgrade $blue[*]$reset"
sudo apt update && sudo apt upgrade -y

install_go() {
    echo "$red[!]$reset Go isn't installed $red[!]$reset"
    sleep 1
    echo "$red[!]$reset Enter the version of Go you want to install (e.g., 1.17.5) $red[!]$reset > "
    read -r go_version
    echo "$red[!]$reset Please enter the SHA256 hash for the downloaded file $red[!]$reset > "
    read -r official_sha256
    local filename="go${go_version}.linux-amd64.tar.gz"
    if check_file_exists "$filename"; then
        echo "Skipping download as $filename already exists."
    else
        wget -q --show-progress "https://golang.org/dl/go${go_version}.linux-amd64.tar.gz"
        if [ $? -ne 0 ]; then
            echo "$blue[!]$reset Failed to download $filename. Exiting. $blue[!]$reset"
            return
        fi
    fi
    go_sha256=$(sha256sum "go${go_version}.linux-amd64.tar.gz" | awk '{print $1}')
    if [ "$go_sha256" = "$official_sha256" ]; then
        echo "$green[*****]$reset\n$go_sha256\n$official_sha256\n$green[*****]$reset"
        echo "$green[!]$reset Hash match $green[!]$reset"
        echo "$blue[+]$reset Installing Go $blue[+]$reset"

        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go${go_version}.linux-amd64.tar.gz"
        if [ -f "$HOME/.zshrc" ]; then
            echo "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.zshrc"
            export PATH=$PATH:/usr/local/go/bin
            . $HOME/.bashrc
            if command -v go &>/dev/null; then
                go version
                echo "$green[!]$reset Done. Go installed $green[!]$reset"
                sleep 1
            else
                echo "$red[!]$reset Failed to install Go $red[!]$reset"
            fi
        Gelif [ -f "$HOME/.bashrc" ]; then
            echo "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.bashrc"
            . $HOME/.bashrc
            export PATH=$PATH:/usr/local/go/bin
            if command -v go &>/dev/null; then
                go version
                echo "$green[!]$reset Done. Go installed $green[!]$reset"
                sleep 1
            else
                echo "[!] Failed to install Go [!]"
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
install_app "Build essential" "buildssential"
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
echo "$green[*]$reset Done. $green[*]$reset"
sleep 1
clear
echo "$blue[+]$reset Neovim installation $blue[+]$reset"
neovim_config()
echo "$green[*]$reset Done. $green[*]$reset"
