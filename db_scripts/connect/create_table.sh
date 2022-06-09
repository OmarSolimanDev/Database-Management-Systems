#!/bin/bash
line1=""   # This line will Contain the names of the columns
line2=""   # This line will Contain the metadata of the columns
line3="4;" # This line will Contain the constraints of the columns

#Function to choose column datatype
function col_datatype() {
    while true; do
        options=("String" "Integer")
        select opt in "${options[@]}"; do
            case $REPLY in
            1) return 1 ;;
            2) return 2 ;;
            *)
                echo -e " ${RED}Invalid Input${NC}"
                break
                ;;
            esac
        done
    done
}

#Function to choose column constraints
function col_constraints() {
    while true; do
        options=("Null" "Not Null")
        select opt in "${options[@]}"; do
            case $REPLY in
            1) return 3 ;; # 3 FOR NULL
            2) return 4 ;; # 4 FOR NOT NULL
            *)
                echo -e " ${RED}Invalid Input${NC}"
                break
                ;;
            esac
        done
    done
}

#Function to create columns
function create_cols() {
    echo "***Note the primary key is the first column***"

    while true; do
        read -p "Primary column name: " pri_name
        #Check if primary key has no special characters nor starts with number
        if ! synatax_checker $pri_name; then
            echo -e " ${RED}Invalid Syntax${NC}"
            continue #1 for false
        fi

        col_datatype #Getting primary key's meta data

        line2="$?;"        # Primary key's metadata
        line1="$pri_name;" # Primary key's name

        break
    done

    #Create table after checking user entered primary key
    touch "$tb_name"
    #Creating column names
    while true; do
        read -p " Would you like to add another column (y/n)?" answer
        if [[ $answer == [nN] ]]; then
            echo "Goodbye!"
            break
        elif [[ $answer == [Yy] ]]; then
            read -p "what is column name 
            ==> " col_name
            #Check if column name has no special characters nor starts with number
            if ! synatax_checker $col_name; then
                continue 
            fi
            #Check if user has entered this table name before
            if [[ "$line1" == *"$col_name"* ]]; then
                echo -e " ${RED}This name has been used before. Please enter different name${NC}"
                continue
            fi

            col_datatype
            line2+="$?;"
            col_constraints
            line3+="$?;" # Column's constraints
            line1+="$col_name;"
        else
            echo -e " ${RED}Invalid Input${NC}"
            continue
        fi

    done

    #Remove the last semicolon from all lines
    line1=${line1::-1}
    line2=${line2::-1}
    line3=${line3::-1}

    echo $line1 >$tb_name  #table names
    echo $line2 >>$tb_name #metadata
    echo $line3 >>$tb_name #metadata
    echo "__________________________________________________
    
    "
    echo -e " ${BGreen}\tTable has been added successfully${NC}\n"
    echo "__________________________________________________"
    return 0 #0 for true
}

function create_table() {
    read -p "Please enter the table name
        ==>" tb_name
    #Check if table name has no special characters nor starts with number
    if ! synatax_checker $tb_name; then
        return 1 #1 for false
    fi
    #Check is tb_name already exists
    if db_checker "./" "$tb_name"; then
        echo -e " ${RED}The name already exists${NC}"
        return 1 #1 for false
    fi

    
    create_cols
    return 0
}
