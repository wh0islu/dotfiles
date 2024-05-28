#!/usr/bin/bash

blue="\e[34m"
green="\e[32m"
red="\e[31m"
reset="\e[97m"
ascii="${blue}
 _____             _  _____ 	
/__   \_ __ _   _ | |/__   \	
  / /\/ '__| | | / __) / /\/
 / /  | |   		
 \/   |_|	 
${reset}
"

Menu(){

    clear
    echo "$ascii"
    echo "Menu"
    echo "$blue[1]$reset * Install sec tools"
    echo "$blue[2]$reset * Install tools"
    echo "$blue[0]$reset * Exit"
    read option
    case $option in
	1) InstallSecTools ;;
	2) InstallTools ;;
	0) exit ;;
	*) "Wrong option. Try again"; echo ; Menu ;;
    esac
}

InstallSecTools(){
    clear
    echo "$blue[*]$reset Sec tools $blue[*]$reset"
    sh setup/sectools.sh
}

InstallTools(){
    clear
    echo "$blue[*]$reset tools $blue[*]$reset"
    sh setup/tools.sh
}

Menu
