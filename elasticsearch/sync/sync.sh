#!/bin/bash
# Change working directory to the directory of this script
cd "$(dirname "$0")"
# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
DOCUMENT_ROOT="${DOCUMENT_ROOT}"

# Truyền 2 biến vào tệp PHP
php sync.php $HOST $CURL_USER $DOCUMENT_ROOT