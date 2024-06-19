#!/bin/bash
source ../function.sh
SCRIPT_DIR=$(get_document_root)

echo "Running on $OS - $SCRIPT_DIR"
# Nhập nội dung của file .env ở thư mục gốc
source "$SCRIPT_DIR/.env"

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Lấy version của Elasticsearch
VERSION=$(curl -s --user $CURL_USER -X GET "${HOST}" | "$SCRIPT_DIR/jq64" -r '.version.number')

echo "Elasticsearch version: ${VERSION}"
