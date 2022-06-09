#!/bin/bash

#Function to delete database
function db_delete() {
    read -p "what is the database name 
    ==>" db_name
    echo "$db_name"
    #Checking syntax to check there are no special characters
    if ! synatax_checker $db_name; then
        return 1 #1 for false
    fi
    #Checking if the db doesn't exists return 1 for false
    if ! db_checker "./database" "$db_name"; then
        echo -e " ${RED}The name doesnt exists${NC}"
        return 1 #1 for false
    fi
    
    #Creating loop to make sure the user enters the right answer
    while true; do
    read -p "Database found
     are you sure you want to delete $db_name database (y/n)?
     ==> " answer

        #If answer is Y or y, delete the database
        if [[ $answer == [Yy] ]]; then
            echo "Deleting in progress"
            rm -r database/"$db_name"
            break
        #If answer is n or N, do nothing and exit
        elif [[ $answer == [Nn] ]]; then
            echo "Ok, Goodbye!"
            break
        #If anything else, print invalid and repeat the question
        else
            echo -e " ${RED}Invalid Input${NC}"
            continue
        fi
    done
    echo -e " ${BGreen}Database $db_name has been deleted successfully${NC}"
    echo "
    -------------------------------------------------------------
    "
}
