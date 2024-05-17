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
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
printf "%-20s => %-20s\n" "Alias" "Index"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
for INDEX in $INDICES; do
    ALIAS=$(curl -s --user $CURL_USER -X GET "${HOST}/$INDEX/_alias" | jq -r ".${INDEX}.aliases | keys[]")
    echo ""
    if [ -z "$ALIAS" ]; then
        printf "%-20s => %-20s\n" "" "$INDEX"
    else
        printf "%-20s => %-20s\n" "$ALIAS" "$INDEX"
    fi
done
echo ""
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo ""