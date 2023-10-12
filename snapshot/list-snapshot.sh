#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Hỏi tên index
echo -n "Enter repository name: "
read RES_NAME

curl --user $CURL_USER "$HOST/_snapshot/$RES_NAME/_all" | jq '.snapshots[].snapshot'