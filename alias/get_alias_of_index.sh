#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

echo -n "Enter index name: "
    read INDEX

# Truy vấn tên alias của OLD_INDEX
ALIAS_RESULT=$(curl -s --user $CURL_USER -X GET "${HOST}/${INDEX}/_alias")

# Sử dụng jq để lấy tất cả tên alias từ kết quả
ALIAS_NAMES=$(echo $ALIAS_RESULT | jq -r ".${INDEX}.aliases | keys[]")
echo ""
# Xuất tên alias
if [ -z "$ALIAS_NAMES" ]; then
    echo "There are no aliases for index $INDEX"
else

    echo "ALIAS names of index $INDEX are:"
    echo ""
    counter=1
    for alias in $ALIAS_NAMES; do
        echo "$counter. $alias"
        counter=$((counter + 1))
    done
fi
echo ""