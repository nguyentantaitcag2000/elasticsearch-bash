#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Hỏi tên index
echo -n "Enter INDEX name: "
read INDEX

# Kiểm tra mapping của index
curl --user $CURL_USER "$HOST/$INDEX/_mapping?pretty"