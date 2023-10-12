#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Lấy danh sách các repository và lưu vào một biến
REPOS=$(curl -s --silent --user $CURL_USER "$HOST/_cat/repositories?v" | awk 'NR>1 {print $1}')

echo "Available repositories:"
echo "$REPOS"

# Lặp qua từng repository và truy vấn danh sách snapshot
for RES_NAME in $REPOS; do
    echo "--------------------------------------"
    echo "Snapshots in repository: $RES_NAME"
    echo "--------------------------------------"
    curl -s --user $CURL_USER "$HOST/_snapshot/$RES_NAME/_all" | jq '.snapshots[].snapshot'
done
