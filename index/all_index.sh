#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
echo "-------------------------------------------"
echo "-----------------Indices-------------------"
echo "-------------------------------------------"
curl -s --user $CURL_USER -XGET "$HOST/_cat/indices?v"
echo "-------------------------------------------"
echo "-----------------Aliases-------------------"
echo "-------------------------------------------"
# Hiển thị danh sách các alias
curl -s --user $CURL_USER -XGET "$HOST/_cat/aliases?v"