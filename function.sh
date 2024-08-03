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
