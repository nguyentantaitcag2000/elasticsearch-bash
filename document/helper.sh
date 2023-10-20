#!/bin/bash

# Change working directory to the directory of this script
cd "$(dirname "$0")"

while true; do
    echo "---------------------------------"
    echo "0. Back"
    echo "1. Get document"
    echo "2. Delete document"
    
    echo "x. Exit"
    echo -n "Choose options: "
    read OPTION

    case $OPTION in
        1)
            bash get-document.sh
            ;;
        2)
            bash delete-document.sh
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
