#!/bin/bash

function list_tables() {
    #Count the number of tables to display message if there are no tables created
    if (($(ls | wc -w) == 0)); then
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        "
        echo -e "${BBlue}\tThere are no tables to display\n${NC}"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        "
        return 1 # 1 for false
    fi
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "
    echo -e "${BBlue}$(ls )\n${NC}"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "
}
