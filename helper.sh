#!/bin/bash
echo "---------------------------------"
echo "1. Get a document"
echo "2. Snapshot"
echo "3. Index"
echo "4. Mapping"
echo -n "Choose options: "
read OPTION

if [ $OPTION -eq 1 ]; then
    bash get-document.sh
elif [ $OPTION -eq 2 ]; then
    bash snapshot/helper.sh
elif [ $OPTION -eq 3 ]; then
    bash index/helper.sh
elif [ $OPTION -eq 4 ]; then
    bash mapping/helper.sh
else
    echo "Invalid option"
fi