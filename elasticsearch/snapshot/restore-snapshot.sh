#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Hỏi tên index
echo -n "Enter repository name: "
read RES_NAME

# Hien thi danh sach snap shot dang co
echo "All snapshot list:"
curl --user $CURL_USER "$HOST/_snapshot/$RES_NAME/_all" | jq '.snapshots[].snapshot'

echo -n "Enter name snapshot want restore: "
read SNAP_NAME

curl --user $CURL_USER -X POST "$HOST/_snapshot/$RES_NAME/$SNAP_NAME/_restore" -H 'Content-Type: application/json' -d '{
  "indices": "_all",
  "rename_pattern": "(.+)",
  "rename_replacement": "restored_$1"
}' | jq .