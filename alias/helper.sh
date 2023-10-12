#!/bin/bash

# Change working directory to the directory of this script
cd "$(dirname "$0")"

while true; do
    echo "---------------------------------"
    echo "0. Back"
    echo "1. List Alias"
    echo "2. Get Alias of a index"
    echo "3. Delete Alias of a index"

    echo "x. Exit"
    echo -n "Choose options: "
    read OPTION

    case $OPTION in
        1)
            bash list_alias.sh
            ;;
        2)
            bash get_alias_of_index.sh
            ;;
        3)
            bash delete_alias.sh
            ;;
        0)
            bash ~/bash/helper.sh
            ;;
        x)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
