#!/bin/bash

CONDITION_REINDEX="if (ctx._source.ip_post_status == true) { ctx._source.ip_post_status = 1 } else if (ctx._source.ip_post_status == false) { ctx._source.ip_post_status = 2 }"

set -e

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

echo -n "Enter old index name: "
    read OLD_INDEX
echo -n "Enter new index name: "
    read NEW_INDEX


# Reindex dữ liệu và thay đổi giá trị từ bool sang int
curl --user $CURL_USER -X POST "${HOST}/_reindex" -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "'$OLD_INDEX'"
  },
  "dest": {
    "index": "'$NEW_INDEX'"
  },
  "script": {
    "source": "'$CONDITION_REINDEX'"
  }
}'
#Hỏi có đồng ý thay thế index cũ thành index mới luôn không
read -p "Are you want replace old index to new index after reindex? (y/n) " answer
case $answer in
    [Yy]* ) 
        # Xóa index cũ
        curl --user $CURL_USER -X DELETE "${HOST}/$OLD_INDEX"

        # Đổi tên index mới thành tên index cũ
        curl --user $CURL_USER -X POST "${HOST}/_aliases" -H 'Content-Type: application/json' -d'
        {
          "actions": [
            {
              "add": {
                "index": "'$NEW_INDEX'",
                "alias": "'$OLD_INDEX'"
              }
            }
          ]
        }'
        ;;
    [Nn]* )
        echo "Thoát!"
        exit
        ;;
    * ) 
        echo "Vui lòng trả lời y hoặc n."
        ;;
esac
