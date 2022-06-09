#!/bin/bash

#Drop table is to remove the whole table
function drop_table() {
    read -p "what is the table name 
    ==>" tb_name
    echo "$tb_name"
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
        are you sure you want to delete $tb_name table (y/n)?
        ==> " answer
        #Delete the entire table if user confirmed
        if [[ $answer == [Yy] ]]; then
            echo "deleting in progress"
            rm -r "$tb_name"
            echo "
            -------------------------------------------------------------
            "
            echo -e " \n${BGreen}Table $tb_name has been dropped successfully${NC}"
            break
        #Do nothing if no
        elif [[ $answer == [Nn] ]]; then
            echo "Ok, Goodbye!"
            break
        else
            echo -e " ${RED}Invalid Input${NC}"
            continue
        fi
    done

    echo "
    -------------------------------------------------------------
    "
}
