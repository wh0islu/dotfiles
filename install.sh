#!/usr/bin/sh  # Changed from bash to sh, as FreeBSD uses sh by default

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
    echo "${blue}[1]${reset} 🛡️ * sec tools [FreeBSD]"
    echo "${blue}[2]${reset} 🛠️ * tools [FreeBSD]"
    echo "${blue}[3]${reset} 🏴 * Configure [FreeBSD]"
    echo "${blue}[0]${reset} Exit"
    printf "Choose an option: "
    read option
    case $option in
        1) InstallSecTools ;;
        2) InstallTools ;;
        3) ConfigureFreeBSD ;;
        0) exit ;;
        *) echo "${red}❌ Wrong option. Try again${reset}"; echo ; Menu ;;
    esac
}

InstallSecTools() {
    clear
    echo "${blue}🛡️[*]${reset} Sec tools ${blue}[*]${reset}"
    sh setup/sectools.sh
}

InstallTools() {
    clear
    echo "${blue}🛠️[*]${reset} Tools ${blue}[*]${reset}"
    sh setup/tools.sh
}

ConfigureFreeBSD() {
    clear
    echo "${blue}🛠️[*]${reset} FreeBSD Configuration ${blue}[*]${reset}"
    sh setup/freebsd.sh
}
Menu
