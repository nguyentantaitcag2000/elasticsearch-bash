#!/bin/bash

# Change working directory to the directory of this script
cd "$(dirname "$0")"

while true; do
    echo "---------------------------------"
    echo "0. Back"
    echo "1. List snapshot"
    echo "2. Create snapshot"
    echo "3. Delete snapshot"
    echo "4. Get snapshot"
    echo "5. Check snapshot"
    
    echo "6. Restore a snapshot"
    echo "x. Exit"
    echo -n "Choose options: "
    read OPTION

    case $OPTION in
        1)
            bash list-snapshot.sh
            ;;
        2)
            bash create-snapshot.sh
            ;;
        3)
            bash delete-snapshot.sh
            ;;
        4)
            bash get-snapshot.sh
            ;;
        5)
            bash check-snapshot.sh
            ;;
       
        6)
            bash restore-snapshot.sh
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
