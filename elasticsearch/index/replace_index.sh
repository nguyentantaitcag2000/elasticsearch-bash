#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

echo "--------------------"
echo "WARNING: Before replace, you should create a snapshot to backup data !"
echo "--------------------"

echo -n "Enter old index name: "
    read OLD_INDEX
echo -n "Enter new index name: "
    read NEW_INDEX

# Truy vấn tên alias của OLD_INDEX
ALIAS_RESULT=$(curl -s --user $CURL_USER -X GET "${HOST}/${OLD_INDEX}/_alias")

# Sử dụng jq để lấy tên alias từ kết quả
ALIAS_NAME=$(echo $ALIAS_RESULT | jq -r 'keys[0]')

# Xóa index cũ
curl --user $CURL_USER -X DELETE "${HOST}/$OLD_INDEX"

# Đổi tên index mới thành tên index cũ
curl --user $CURL_USER -X POST "${HOST}/_aliases" -H 'Content-Type: application/json' -d'
{
    "actions": [
    {
        "add": {
        "index": "'$NEW_INDEX'",
        "alias": "'$ALIAS_NAME'"
        }
    }
    ]
}' | jq .