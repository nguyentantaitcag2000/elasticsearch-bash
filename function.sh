#!/bin/bash
# Define ANSI color codes
red=$(tput setaf 1)
green=$(tput setaf 2)
orange=$(tput setaf 3)
reset=$(tput sgr0)
OS="unknown"
echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
else
    echo "Unsupported operating system"
    exit 1
fi
# Function to get script directory based on OS
# It is like SERVER['DOCUMENT_ROOT'] in php 
get_document_root() {
    local script_dir=""
    if [[ $OS == "linux" || $OS == "mac" ]]; then
        script_dir="$( dirname "$(realpath "$0")" )"
    elif [[ $OS == "windows" ]]; then
        script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    else
        echo "Unsupported operating system"
        exit 1
    fi

    echo "$script_dir"
}
