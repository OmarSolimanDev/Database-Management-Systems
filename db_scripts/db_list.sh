#!/bin/bash

#Function to list all databases 
function listing_database() {
    #Check if the number of db is zero, display a message
    if (($(ls database | wc -w) == 0)); then
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        "
        echo -e "${BBlue}\tThere are no database to display\n${NC}"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        "
        return 1 # 1 for false
    fi

    echo "Listing all databases:"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "
    echo -e "${BBlue}$(ls database)\n${NC}"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "
}
