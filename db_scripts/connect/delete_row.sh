#!/bin/bash

function delete_row() {

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

    read -p "what is the primary key's value
    ==>" pri_value
    #Check if the primary key value exists in table
    if ! cut -f1 -d";" "$tb_name" | tail -n+4 | grep -w "$pri_value" >/dev/null; then
        echo -e " ${RED}The value doesn't exists${NC}"
        return 1
    fi
    #Get the row number where it matches the primary key entered by user
    row_number=$(awk -v var=$pri_value -F";" \
        '{if($1==var && NR>3)\
    {print NR}}' $tb_name)

    
    chmod +w $tb_name
    #Delete the line in file
    sed -i "${row_number}d" $tb_name
    echo -e " ${BGreen}Value has been deleted successfully${NC}"
    echo "
    -------------------------------------------------------------
    "
}
