#!/bin/bash
# Change working directory to the directory of this script
# Get the directory of this script
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Running on Linux"
    SCRIPT_DIR="$( dirname "$(realpath "$0")" )"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "Running on Windows"
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
    echo "Unsupported operating system"
    exit 1
fi
# Change working directory to the directory of this script
cd "$SCRIPT_DIR"
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