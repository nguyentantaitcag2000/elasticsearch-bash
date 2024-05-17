#!/bin/bash

# Change working directory to the directory of this script
cd "$(dirname "$0")"

while true; do
    echo "---------------------------------"
    echo "0. Back"
    echo "1. List index"
    echo "2. Create a new index"
    echo "3. Delete index"
    echo "4. Replace a old index to a new index"
    echo "x. Exit"
    echo -n "Choose options: "
    read OPTION

    case $OPTION in
        1)
            bash all_index.sh
            ;;
        2)
            bash create_index.sh
            ;;
        3)
            bash delete_index.sh
            ;;
        4)
            bash replace_index.sh
            ;;
        0)
            bash ../helper.sh
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
