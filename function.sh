#!/bin/bash
# Define ANSI color codes
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Function to get script directory based on OS
# It is like SERVER['DOCUMENT_ROOT'] in php 
get_document_root() {
    local os_type="$OSTYPE"
    local script_dir=""

    if [[ "$os_type" == "linux-gnu"* ]]; then
        script_dir="$( dirname "$(realpath "$0")" )"
    elif [[ "$os_type" == "msys" || "$os_type" == "cygwin" ]]; then
        script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    else
        echo "Unsupported operating system"
        exit 1
    fi

    echo "$script_dir"
}