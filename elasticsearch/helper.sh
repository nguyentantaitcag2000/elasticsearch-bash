#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change working directory to the directory of this script
cd "$SCRIPT_DIR"

echo "---------------------------------"
echo "1. Snapshot"
echo "2. Index"
echo "3. Mapping"
echo "4. Document"
echo "5. Alias"
echo "6. Reindex"
echo "7. Sync"
echo "8. Check Shard"
echo -n "Choose options: "
read OPTION

if [ $OPTION -eq 1 ]; then
    bash "$SCRIPT_DIR/snapshot/helper.sh"
elif [ $OPTION -eq 2 ]; then
    bash "$SCRIPT_DIR/index/helper.sh"
elif [ $OPTION -eq 3 ]; then
    bash "$SCRIPT_DIR/mapping/helper.sh"
elif [ $OPTION -eq 4 ]; then
    bash "$SCRIPT_DIR/document/helper.sh"
elif [ $OPTION -eq 5 ]; then
    bash "$SCRIPT_DIR/alias/helper.sh"
elif [ $OPTION -eq 6 ]; then
    bash "$SCRIPT_DIR/reindex.sh"
elif [ $OPTION -eq 7 ]; then
    bash "$SCRIPT_DIR/sync/sync.sh"
elif [ $OPTION -eq 8 ]; then
    bash "$SCRIPT_DIR/check-shard.sh"
else
    echo "Invalid option"
fi
