#!/usr/bin/bash

blue="\e[34m"
reset="\e[97m"

ascii="${blue}
(::)
${reset}
"

Menu() {
    clear
    echo -e "$ascii"
    echo "📋 Menu"
    echo -e "${blue}[1]${reset} 🛡️ * Install sec tools"
    echo -e "${blue}[2]${reset} 🛠️ * Install tools"
    echo -e "${blue}[3]${reset} 🏴 * Configure Arch"
    echo -e "${blue}[0]${reset} Exit"
    read -p "Choose an option: " option
    case $option in
        1) InstallSecTools ;;
        2) InstallTools ;;
        3) ConfigureArch ;;
        0) exit ;;
        *) echo -e "${red}❌ Wrong option. Try again${reset}"; echo ; Menu ;;
    esac
}

InstallSecTools() {
    clear
    echo -e "${blue}🛡️[*]${reset} Sec tools ${blue}[*]${reset}"
    sh setup/sectools.sh
}

InstallTools() {
    clear
    echo -e "${blue}🛠️[*]${reset} Tools ${blue}[*]${reset}"
    sh setup/tools.sh
}

ConfigureArch() {
    clear
    echo -e "${blue}🛠️[*]${reset} Arch .dotfiles ${blue}[*]${reset}"
    sh setup/arch.sh
}
Menu
