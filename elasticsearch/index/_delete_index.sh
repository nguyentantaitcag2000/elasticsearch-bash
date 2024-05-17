#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

INDEX=$1
if [ -z "$INDEX" ]; then
    echo "Usage: $0 <INDEX> <ALIAS_NAME>"
    exit 1
fi

curl --user $CURL_USER -XDELETE "$HOST/$INDEX?pretty"