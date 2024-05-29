#!/bin/bash
# Define ANSI color codes
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
# Get the path dir had opened the terminal
CURRENT_DIR_OPENED_TERMINAL="$( cd "$(dirname "$0")" ; pwd -P )"
# Change working directory to the directory of this script
# Get the directory of this script
OS=""

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    SCRIPT_DIR="$( dirname "$(realpath "$0")" )"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS="Windows"
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
    echo "Unsupported operating system"
    exit 1
fi
echo "Running on $OS - $SCRIPT_DIR"
# Change working directory to the directory of this script
cd "$SCRIPT_DIR"
echo "$CURRENT_DIR_OPENED_TERMINAL"
echo "---------------------------------"
echo "1. Elasticsearch"
echo "2. Check disk usage"
echo "3. Open Git repository"
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
elif [ $OPTION -eq 3 ]; then
    
    # Change directory to the specified directory
    # if [[ "$OS" == "Windows" ]]; then
    #     # Check if the path starts with a "/"
    #     if [[ "${CURRENT_DIR_OPENED_TERMINAL:0:1}" == "/" ]]; then
    #         # Remove the leading "/" character
    #         CURRENT_DIR_OPENED_TERMINAL="${CURRENT_DIR_OPENED_TERMINAL:1}"
    #         # Insert ":" after the drive letter
    #         CURRENT_DIR_OPENED_TERMINAL="${CURRENT_DIR_OPENED_TERMINAL:0:1}:${CURRENT_DIR_OPENED_TERMINAL:1}"
    #     fi
    # fi
    
    #Working in (Linux & Window) [Git Bash, VS Code, CMD]
    cd "$CURRENT_DIR_OPENED_TERMINAL"
    URL="$(git config --get remote.origin.url)"
    if [[ "$URL" == "" ]]; then
        echo "${red}ERROR: You must specify the origin url of Git${reset}"
        exit 1
    fi
    start $(git config --get remote.origin.url)
    echo "${green}Open repository is successfully${reset}"
else
    echo "Invalid option"
fi