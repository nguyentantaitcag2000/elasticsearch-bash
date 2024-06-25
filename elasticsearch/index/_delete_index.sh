#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env
source ../../function.sh

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

INDEX=$1
if [ -z "$INDEX" ]; then
    echo "Usage: $0 <INDEX> <ALIAS_NAME>"
    exit 1
fi

response=$(curl -s --user $CURL_USER -XDELETE "$HOST/$INDEX?pretty")
# Khi xoá thành công kêt quả sẽ có dạng: {"acknowledged" : true}
if echo "$response" | jq -e '.acknowledged == true' >/dev/null; then
    echo "${green}Delete ${orange}$INDEX${reset} ${green}index is successful.${reset}"
else
    echo "${red}Delete failed: $(echo $response | jq -r '.error.reason // "Unknown error"')${reset}"
    exit 1
fi