#!/bin/bash
source db_scripts/connect/create_table.sh
source db_scripts/connect/list_tables.sh
source db_scripts/connect/delete_table.sh
source db_scripts/connect/drop_table.sh
source db_scripts/connect/insert_row.sh
source db_scripts/connect/select_table.sh
source db_scripts/connect/update_table.sh
source db_scripts/connect/delete_row.sh

#Function to connect to database
function connect() {

    read -p "Please enter the name of the DB you want to connect to
    ==>" db_name

    #Check that name has no special characters or start with number
    if ! synatax_checker "$db_name"; then
        echo -e " ${RED}This syntax is invalid!${NC}"
        return 1 #1 for false
    fi
    #Check if the database exists to connect to it
    if ! db_checker "./database/" "$db_name"; then
        echo -e " ${RED}The name doesn't exists${NC}"
        return 1 #1 for false
    fi
    echo "-------------------------------------------------------------
        "

    echo -e "${BGreen}\t\t You're now in $db_name database\n${NC}"
    echo "-------------------------------------------------------------
        "
    #Connecting to Database

    cd ./database/$db_name

    #While loop to make sure the menu will be displayed in every iteration
    while true; do
        options=('Create Table' "list Tables" "Drop Table" "Insert into Table" "Select From Table"
            "Delete Table" "Update Table" "Delete row" "exit")

        select opt in "${options[@]}"; do
            case $REPLY in
            1)
                create_table
                break
                ;;
            2)
                list_tables
                break
                ;;
            3)
                drop_table
                break
                ;;
            4)
                insert_row
                break
                ;;
            5) 
                select_row
                break ;;
            6)
                delete_table
                break
                ;;
            7) 
                update_row
                break ;;
            8)
                delete_row
                break;;
            9) 
                break 2 ;;
            *) 
                echo -e " ${RED}Invalid Input${NC}"
                break ;;
            esac
        done
    done
    #Return to the main directory after exiting connect function
    cd ../../ #return to the main directory
    return 0  #0 for true
}
