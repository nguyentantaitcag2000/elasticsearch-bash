#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Lấy danh sách tất cả các index
INDICES=$(curl -s --user $CURL_USER -X GET "${HOST}/_cat/indices" | awk '{print $3}')
echo ""
echo "List of Indices and their Aliases:"
echo "---------------------------------"

# Duyệt qua từng index và kiểm tra alias
for INDEX in $INDICES; do
    ALIAS=$(curl -s --user $CURL_USER -X GET "${HOST}/$INDEX/_alias" | jq -r ".${INDEX}.aliases | keys[]")

    if [ -z "$ALIAS" ]; then
        echo "$INDEX =>"
    else
        echo "$INDEX => $ALIAS"
    fi
done
echo ""