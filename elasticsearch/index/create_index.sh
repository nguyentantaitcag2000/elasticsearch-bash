#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

echo -n "Enter INDEX name to create: "
read INDEX

curl --user $CURL_USER -XPUT "$HOST/$INDEX?pretty&timeout=220s" | jq .