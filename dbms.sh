#!/bin/bash
source db_scripts/db_create.sh
source db_scripts/db_delete.sh
source db_scripts/db_list.sh
source db_scripts/db_connect.sh
source db_scripts/db_checker.sh
source db_scripts/initializer.sh

RED='\033[0;31m'
NC='\033[0m'
BGreen='\033[1;32m'
BYellow='\033[1;33m'
BBlue='\033[1;34m'
Purple='\033[1;35m'


#Calling the initializer function to give execute permission for all files
chmod +x db_scripts/initializer.sh
initialization


#Changing the default select prompt string 
PS3="=>"

#Creating while loop to allow display the menu every iteration of select menu

while true; do
    options=("Create" "Delete" "Connect" "List" "Exit")
    select opt in ${options[@]}; do
        case $REPLY in
        1) #Calling create database function
            create_database
            break
            ;;
        2) #Calling delete database function
            db_delete
            break
            ;;
        3) #Calling connect database function
            connect
            break
            ;;
        4) #Calling list database function
            listing_database
            break
            ;;
        5) 
            exit ;;
        *) 
            echo -e " ${RED}Invalid Input${NC}"
            break ;;

        esac
    done
done
