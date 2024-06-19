#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Lấy version của Elasticsearch
VERSION=$(curl -s --user $CURL_USER -X GET "${HOST}" | jq -r '.version.number')

echo "Elasticsearch version: ${VERSION}"
