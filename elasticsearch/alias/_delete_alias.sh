#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

INDEX=$1
ALIAS_NAME=$2

echo "+ Index -> $INDEX"
echo "+ ALIAS_NAME -> $ALIAS_NAME"
# Kiểm tra xem đã truyền đủ tham số chưa
if [ -z "$INDEX" ] || [ -z "$ALIAS_NAME" ]; then
    echo "Usage: $0 <INDEX> <ALIAS_NAME>"
    exit 1
fi

# Xóa alias cũ
curl --user $CURL_USER -X POST "${HOST}/_aliases" -H 'Content-Type: application/json' -d'
{
    "actions": [
        {
            "remove": {
                "index": "'$INDEX'",
                "alias": "'$ALIAS_NAME'"
            }
        }
    ]
}' | jq .
