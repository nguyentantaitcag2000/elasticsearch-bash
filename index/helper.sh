#!/bin/bash

while true; do
    echo "---------------------------------"
    echo "0. Back"
    echo "1. List index"
    echo "2. Delete index"
    echo "3. Exit"
    echo -n "Choose options: "
    read OPTION

    case $OPTION in
        1)
            bash index/all_index.sh
            ;;
        2)
            bash index/delete_index.sh
            ;;
        0)
            bash ~/bash/helper.sh
            ;;
        3)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
