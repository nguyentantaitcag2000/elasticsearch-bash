#!/bin/bash

# Change working directory to the directory of this script
cd "$(dirname "$0")"

echo "---------------------------------"
echo "1. Snapshot"
echo "2. Index"
echo "3. Mapping"
echo "4. Document"
echo "5. Alias"
echo "6. Reindex"
echo "7. Reindex From JSON of database by lazycodet created"
echo -n "Choose options: "
read OPTION


if [ $OPTION -eq 1 ]; then
    bash snapshot/helper.sh
elif [ $OPTION -eq 2 ]; then
    bash index/helper.sh
elif [ $OPTION -eq 3 ]; then
    bash mapping/helper.sh
elif [ $OPTION -eq 4 ]; then
    bash document/helper.sh
elif [ $OPTION -eq 5 ]; then
    bash alias/helper.sh
elif [ $OPTION -eq 6 ]; then
    bash reindex.sh
elif [ $OPTION -eq 7 ]; then
    bash reindex2.sh
else
    echo "Invalid option"
fi