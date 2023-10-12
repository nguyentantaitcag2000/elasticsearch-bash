#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Hỏi tên index
echo -n "Enter your index name: "
read INDEX

# Hỏi ID của document
echo -n "Enter ID of document: "
read DOC_ID

# Thực hiện cURL để lấy document
curl --user $CURL_USER "$HOST/$INDEX/_doc/$DOC_ID" | jq .