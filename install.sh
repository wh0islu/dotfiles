#!/usr/bin/sh

Menu() {
    clear
    echo "$ascii"
    echo "[1] - sec tools [Ubuntu]"
    echo "[2] - .config [Arch]"
    echo "[3] - .config [Ubuntu]"
    echo "[0] - Exit"
    printf "Choose an option: "
    read option
    case $option in
        1) InstallSecTools ;;
        2) ConfigArch ;;
        3) ConfigUbuntu ;;
        0) exit ;;
        *) echo "❌ Wrong option. Try again"; echo ; Menu ;;
    esac
}

InstallSecTools() {
    clear
    sh setup/sectools.sh
}

ConfigArch() {
    clear
    sh setup/config_arch.sh
}

ConfigUbuntu(){
    clear
    sh setup/config_ubuntu.sh
}
Menu
