#!/bin/bash

# Change working directory to the directory of this script
cd "$(dirname "$0")"

echo "---------------------------------"
echo "1. Elasticsearch"
echo "2. Check disk usage"
echo -n "Choose options: "
read OPTION


if [ $OPTION -eq 1 ]; then
    bash elasticsearch/helper.sh
elif [ $OPTION -eq 2 ]; then
    echo ""
    echo "=========Disk Usage=========="
    echo ""
    echo "=========="
    echo "==> MB <=="
    echo "=========="
    bash system/check-disk-usage.sh
    echo ""
    echo ""
    echo "=========="
    echo "==> GB <=="
    echo "=========="

    bash system/check-disk-usage.sh GB
else
    echo "Invalid option"
fi