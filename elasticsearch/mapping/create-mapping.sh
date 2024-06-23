#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ../../function.sh
SCRIPT_DIR=$(get_document_root)
source "$SCRIPT_DIR/.env"

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
# ANSI color codes
RED='\033[0;31m'
NC='\033[0m' # No Color

# Hỏi tên index
echo -n "Enter new INDEX name: "
read INDEX
msgEnterFileName="Enter mapping file name (example: personal-post-mapping.json): "
while true; do

    # Hỏi tên file mapping
    echo -n "$msgEnterFileName"
    read FILE_NAME
    FILE_NAME_VALID="$FILE_NAME"
    # Kiểm tra nếu FILE_NAME không chứa ".json" thì thêm vào
    if [[ ! "$FILE_NAME" == *".json" ]]; then
        FILE_NAME_VALID="${FILE_NAME}.json"
    fi

    FILE_NAME_FULL="./config/${FILE_NAME_VALID}"

    # Kiểm tra xem file có tồn tại không
    if [[ "$FILE_NAME" == "x" ]]; then
        exit 1
    elif [ ! -f "$FILE_NAME_FULL" ]; then
        echo -e "${RED}${FILE_NAME_FULL} - File not found!${NC}"
        msgEnterFileName="Enter mapping file name again (Press 'x' to exit): "
    else
        break
    fi
done

# Sử dụng nội dung của tệp đó trong lệnh curl
curl --user $CURL_USER -X PUT "$HOST/$INDEX" -H 'Content-Type: application/json' --data-binary "@$FILE_NAME_FULL" | jq .
