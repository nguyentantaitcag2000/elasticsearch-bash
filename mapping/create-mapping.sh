#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Hỏi tên index
echo -n "Enter new INDEX name: "
read INDEX

# Hỏi tên file mapping
echo -n "Enter mapping file name (example: ./config/personal-post-mapping.json): "
read FILE_NAME

# Kiểm tra xem file có tồn tại không
if [ ! -f $FILE_NAME ]; then
    echo "File not found!"
    exit 1
fi

# Sử dụng nội dung của tệp đó trong lệnh curl
curl --user $CURL_USER -X PUT "$HOST/$INDEX" -H 'Content-Type: application/json' --data-binary "@$FILE_NAME" | jq .
