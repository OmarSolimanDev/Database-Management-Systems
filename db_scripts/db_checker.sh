#! /bin/bash

#Creative use of globbing syntax can do a great deal of advanced pattern matching
# perhaps approaching regular expressions in terms of complexity.
shopt -s extglob
#you generally run a command with LC_ALL=C to avoid the user's settings to interfere with script
LC_ALL=C

#Function to check the string doesn't start with number and doesn't have special characters
function synatax_checker() {
    case $* in
    #If string starts with number raise error
    [0-9]*)
        echo -e " ${RED}The database's name mustn't start with number${NC}"
        return 1 #1 for false

        ;;
    #Only allow characters, spaces and characters in middle
    +([a-zA-Z0-9 ]))
        return 0 #0 for true
        ;;
    #Raise error if anything else
    *)
        echo -e " ${RED}Invalid input you can't enter empty name nor special characters${NC}"
        return 1 #1 for false

        ;;
    esac
}

#Function to check if database name exists before
function db_checker() {
    #List files in $1 directory and check is it has the specified db name $2
    if ls $1 2>/dev/null | grep -w "$2" >/dev/null 2>/dev/null;then
        return 0 #0 for true
    else
        return 1 #1 for false
    fi
}
#Function checks the user input against the null constraints of specific column
function null_validation() {

    #If value $1 is empty and constraint can be null
    if [[ -z $1 && (($2 == 3)) ]]; then # 3: null values allowed
        return 0
    #If value $1 is not empty and constraint can be null
    elif [[ ! -z $1 && (($2 == 3)) ]]; then # 3: non null values are allowed
        return 0
    #If value $1 is not empty and constraint cannot be null
    elif [[ ! -z $1 && (($2 == 4)) ]]; then # 4: null values are not allowed
        return 0
    else
        echo -e " ${RED}The value can't be null${NC}"
        return 1
    fi
}

#Checking value of table entry that could be empty,string or numbers but not special characters
function syntax_validation() {

    if [[ $1 == +([a-zA-Z0-9]) ]]; then
        echo -e " ${BGreen}Valid Syntax${NC}"
        return 0 # Alphanumic returns True/0
    elif [[ $1 == "" ]]; then
        echo -e " ${BGreen}Valid Syntax${NC}"
        return 0 # newline returns True/0
    else
        echo -e " ${RED}No special characters are allowed!${NC}"
        return 1 # Space only & wildcards return False/1
    fi

}

#Checking values of table entry against metadata of table 
function value_validation() {
    #If metadata is 1 then its a string
    if [[ (($2 == 1)) ]]; then          
        # 1: strings values allowed
        if [[ $1 == +([a-zA-Z]) ]]; then 
            return 0
        #Allow empty string
        elif [[ $1 == "" ]]; then
            return 0
        else
            echo -e " ${RED}Value must be string${NC}"
            return 1
        fi
    fi

    #If metadata is 2 then its an integer
    if [[ (($2 == 2)) ]]; then 
        # 2: numric values only allowed
        if [[ $1 == +([0-9]) ]]; then
            return 0
        #allow empty values too
        elif [[ $1 == "" ]]; then
            return 0
        else
            echo -e " ${RED}Value must be numeric${NC}"
            return 1

        fi
    fi

}

#Function to check the value of primary key is unique
function unique_value() {
    #counting the number of lines of table to check if it has no values 
    #-only column names, constraints and metadata-
    if (($(wc -l $1 | cut -d" " -f1) == 3)); then #checking if the table is empty!
        return 0
    fi
    #If table is not empty, get the first field in the table -primary key-
    #drop first 3 lines of the table and check if the value has existed before
    if cut -f1 -d";" "$1" | tail -n+4 | grep -w "$2" >/dev/null; then #To avoid printing
        echo -e " ${RED}Value must be unique${NC}"
        return 1
    fi

}
