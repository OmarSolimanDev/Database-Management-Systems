#!/bin/bash

#Create a directory with the db name
function create_database() {
    read -p "what is the database name 
    ==> " db_name
    #Check if the name is in correct syntax, no special characters and doesn't start with number
    if ! synatax_checker $db_name; then
        return 1 #1 for false
    fi
    #Check if this name has not been already taken before
    if db_checker "./database/" "$db_name"; then
        echo -e " ${RED}The already name exists!${NC}"
        return 1 #1 for false
    fi
    echo "valid name creating "$db_name" database"
    mkdir ./database/"$db_name"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "
    echo -e " ${BGreen}\t\tDatabase $db_name has been created successfully\n${NC}"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "
}
