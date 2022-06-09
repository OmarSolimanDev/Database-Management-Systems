#!/bin/bash

#Function to delete table data
function delete_table() {
    read -p "what is the table name 
    ==>" tb_name
    #Check if table name has no special characters nor starts with number
    if ! synatax_checker $tb_name; then
        return 1 #1 for false
    fi
    #Check that table exists
    if ! db_checker "./$tb_name" "$tb_name"; then
        echo -e " ${RED}The name doesn't exists${NC}"
        return 1 #1 for false
    fi
    
    while true; do
        read -p "Table found
        are you sure you want to delete $tb_name table (y/n) ?
        ==> " answer
        #If user confirmed, delete starting from line 4
        if [[ $answer == [Yy] ]]; then
            echo "deleting in progress"
            sed -i '4,$d' $tb_name
            echo "
            -------------------------------------------------------------
            "
            echo -e " \n${BGreen}Table $tb_name has been deleted successfully${NC}"
            break
        #Do nothing if user said no
        elif [[ $answer == [Nn] ]]; then
            echo "Ok, Goodbye!"
            break
        else
            echo -e " ${RED}Invalid Option${NC}"
            continue
        fi
    done
    echo "
    -------------------------------------------------------------
    "
}
