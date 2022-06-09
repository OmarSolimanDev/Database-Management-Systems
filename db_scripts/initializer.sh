#!/bin/bash

#This function creates database folder -where 
#all the user's db will be created- if not created already
#Also, this function gives execute permission to all script files

function initialization(){
    if [ ! -d "database" ] 
    then
        mkdir "database"
    fi

    chmod +x db_scripts/db_create.sh
    chmod +x db_scripts/db_delete.sh
    chmod +x db_scripts/db_list.sh
    chmod +x db_scripts/db_connect.sh
    chmod +x db_scripts/db_checker.sh
    chmod +x db_scripts/db_create.sh

    chmod +x db_scripts/connect/create_table.sh
    chmod +x db_scripts/connect/list_tables.sh
    chmod +x db_scripts/connect/delete_table.sh
    chmod +x db_scripts/connect/drop_table.sh
    chmod +x db_scripts/connect/insert_row.sh
    chmod +x db_scripts/connect/select_table.sh
    chmod +x db_scripts/connect/update_table.sh
}