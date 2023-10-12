#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

echo -n "Enter index name: "
    read INDEX
echo -n "Enter alias name : "
    read ALIAS_NAME


# Đổi tên index mới thành tên index cũ
curl --user $CURL_USER -X POST "${HOST}/_aliases" -H 'Content-Type: application/json' -d'
{
    "actions": [
    {
        "add": {
        "index": "'$INDEX'",
        "alias": "'$ALIAS_NAME'"
        }
    }
    ]
}' | jq .



