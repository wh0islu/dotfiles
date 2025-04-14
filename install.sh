#!/usr/bin/sh

blue="\033[34m"
reset="\033[97m"

ascii="${blue}
(::)
${reset}
"

Menu() {
    clear
    echo "$ascii"
    echo "📋 Menu"
    echo "${blue}[1]${reset} 🛡️ * sec tools [Ubuntu]"
    echo "${blue}[2]${reset} 🏴 * .config [Arch]"
    echo "${blue}[3]${reset} 🏴 * .config [Ubuntu]"
    echo "${blue}[0]${reset} Exit"
    printf "Choose an option: "
    read option
    case $option in
        1) InstallSecTools ;;
        2) ConfigArch ;;
        3) ConfigUbuntu ;;
        0) exit ;;
        *) echo "${red}❌ Wrong option. Try again${reset}"; echo ; Menu ;;
    esac
}

InstallSecTools() {
    clear
    echo "${blue}🛡️[*]${reset} Sec tools ${blue}[*]${reset}"
    sh setup/sectools.sh
}

ConfigArch() {
    clear
    echo "${blue}🛠️[*]${reset} .config Arch ${blue}[*]${reset}"
    sh setup/config_arch.sh
}

ConfigUbuntu(){
    clear
    echo "${blue}🛠️[*]${reset} .config Ubuntu ${blue}[*]${reset}"
    sh setup/config_ubuntu.sh
}
Menu
