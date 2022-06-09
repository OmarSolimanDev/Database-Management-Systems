#!/bin/bash
function insert_row() {

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
    #Get the column names
    line1=$(sed -n '1p' $tb_name) 
    #Get the column metadata
    line2=$(sed -n '2p' $tb_name) 
    #Get the constraints
    line3=$(sed -n '3p' $tb_name) 

    #Defining new delimeter to parse the line into thr array
    old_ifs="$IFS"
    IFS=";"

    #Define an array for column names
    col_names_arr=($line1)
    #Define an array for metadata
    col_metadata_arr=($line2)
    #Define an array for column constraints
    col_constraints_arr=($line3)
    IFS="$old_ifs"

    chmod +w $tb_name
    line_value=""
    for ((i = 0; i < ${#col_names_arr[@]}; i++)); do
        while true; do
            read -p "enter value of ${col_names_arr[$i]} column: " col_value
            #Checking for no special characters!
            if ! syntax_validation "$col_value"; then #Checking for no special characters!
                continue
            fi
            #Check if value matchers the null constraints
            if ! null_validation "$col_value" "${col_constraints_arr[$i]}"; then
                continue
            fi
            #Check if value matches the metadata
            if ! value_validation "$col_value" "${col_metadata_arr[$i]}"; then
                continue
            fi
            #If its the first column -primary key- check is value is unique
            if ((i == 0)); then
                if ! unique_value $tb_name $col_value; then
                    continue
                fi
            fi

            line_value+="$col_value;"
            break
        done

    done
    #Remove the ; from the end of the line
    line_value=${line_value::-1}
    #Append new line with the updated values
    echo $line_value >>$tb_name
    echo -e " ${BGreen}Value has been added sucessfully${NC}"
    echo "
    -------------------------------------------------------------
    "

}
