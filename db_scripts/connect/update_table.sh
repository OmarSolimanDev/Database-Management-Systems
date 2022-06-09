#!/bin/bash

#Function to update certain record
function update_row() {

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

    #Get the column names
    line1=$(sed -n '1p' $tb_name)
    #Get the column metadata
    line2=$(sed -n '2p' $tb_name)
    #Get the constraints
    line3=$(sed -n '3p' $tb_name)

    #Defining new delimeter to parse the line into thr array
    old_ifs="$IFS"
    IFS=";"

    #Get the row number where it matches the primary key entered by user
    row_number=$(awk -v var=$pri_value -F";" \
        '{if($1==var && NR>3)\
    {print NR}}' $tb_name)

    #Get the data of that specific record
    user_data=$(awk -v row=$row_number -F";" \
        '{if(NR==row)\
    {print $0}}' $tb_name)

    #Define an array for column names
    col_names_arr=($line1)
    #Define an array for metadata
    col_metadata_arr=($line2)
    #Define an array for column constraints
    col_constraints_arr=($line3)
    #Define an array for record data
    data_array=($user_data)
    #Restore the IFS
    IFS="$old_ifs"

    #Give write permission to table
    chmod +w $tb_name
    #Define line_value to append the new values entered by user
    line_value=""
    #Loop over the column names
    for ((i = 0; i < ${#col_names_arr[@]}; i++)); do
        while true; do
            echo "The value of ${col_names_arr[$i]} column is ${data_array[$i]} "
            read -p "Would you like to change it (y/n)
            ==>" answer
            if [[ $answer == [Yy] ]]; then
                read -p "enter value of ${col_names_arr[$i]} column: " col_value
                #Checking for no special characters!
                if ! syntax_validation "$col_value"; then 
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
            #If the user didn't want to change this value, keep the old value
            elif [[ $answer == [Nn] ]]; then
                line_value+="${data_array[$i]};"
            else
                echo -e " ${RED}The name doesn't exists${NC}"
                continue

            fi
            break
        done

    done
    #Remove the ; from the end of the line
    line_value=${line_value::-1}
    #Delete the old line in file
    sed -i "${row_number}d" $tb_name
    #Append new line with the updated values
    echo $line_value >>$tb_name
    echo -e " ${BGreen}Values has been updated successfully${NC}"
    echo "
    -------------------------------------------------------------
    "
}
