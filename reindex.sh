#!/bin/bash

CONDITION_REINDEX="if (ctx._source.ip_post_status == true) { ctx._source.ip_post_status = 1 } else if (ctx._source.ip_post_status == false) { ctx._source.ip_post_status = 2 }"

set -e
# Kiểm tra xem biến đã được truyền vào hay chưa
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <old_index> <new_index>"
    exit 1
fi

OLD_INDEX=$1
NEW_INDEX=$2

# Reindex dữ liệu và thay đổi giá trị từ bool sang int
curl --user $CURL_USER -X POST "http://localhost:9200/_reindex" -H 'Content-Type: application/json' -d'
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

# Xóa index cũ
curl --user $CURL_USER -X DELETE "http://localhost:9200/$OLD_INDEX"

# Đổi tên index mới thành tên index cũ
curl --user $CURL_USER -X POST "http://localhost:9200/_aliases" -H 'Content-Type: application/json' -d'
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