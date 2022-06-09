#!/bin/bash
function select_row() {

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

    #Defining new delimeter to parse the line into thr array
    old_ifs="$IFS"
    IFS=";"
    #Define an array for column names
    col_names_arr=($line1)
    #Restore the IFS
    IFS="$old_ifs"
    #Define columns array to append the column numbers the user wants to select
    columns=()

    chmod +w $tb_name
    for ((i = 0; i < ${#col_names_arr[@]}; i++)); do
        while true; do
            read -p "Would you like to select the ${col_names_arr[$i]} column (y/n)?
            ==>" answer
            #If user wants to select this column, append column number in columns array
            #Add 1 to start from column 1 instead of zero
            if [[ $answer == [Yy] ]]; then
                columns+=("$((i + 1))")
                break
            elif [[ $answer == [Nn] ]]; then
                break
            else
                echo -e " ${RED}Invalid Input${NC}"
                continue
            fi
        done
    done
    #Counting number of lines of tables
    if (($(awk 'END { print NR }' $tb_name) == 3)); then
        echo "Table is empty"
    else
        #Display the columns user selected
        echo -e "${Purple}$(head -1 $tb_name | sed -r 's/;+/\t/g')${NC}"
        cut -d";" -f"${columns[*]}" $tb_name | sed -r  -e 's/;+/\t/g' -e '1,3d'
    fi
    #######################################################
    # we spent hours in this code , pay your respect
    # for it , as it will not be used.
    #  awk -v col_array="${columns[*]}" -v line=" " \
    # -F";" 'BEGIN {split(col_array,element," ");}\
    # {for (e in element){line=line " " $element[e] ;} \
    # line=line "\n";} \
    # END { print line ;}' stud | sed -r 's/;+/\t/g'
    ########################################################
    echo "
    -------------------------------------------------------------
    "
}
