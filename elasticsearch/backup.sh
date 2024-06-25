#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Tạo thư mục backup với ngày giờ hiện tại
backup_dir="backup/$(date +'%Y-%m-%d-%Hh%Mm%Ss')"
mkdir -p "$backup_dir"
mapping_dir="$backup_dir/mapping";
mkdir -p "$mapping_dir"
alias_dir="$backup_dir/alias"
mkdir -p "$alias_dir"
# Lấy danh sách các index
indices=$(curl -s --user $CURL_USER -XGET "$HOST/_cat/indices?v" | awk '{print $3}')

# Lặp qua từng index và xuất dữ liệu vào file JSON
for index in $indices; do
  echo "----------------------------------"
  echo "Exporting data from index: $index"
  # Thay đổi kích thước --max-time để phù hợp với index lớn hơn
  curl -s --user $CURL_USER -XGET "$HOST/$index/_search?size=10000" --max-time 600 | jq -c '.hits.hits[] | { index: { _index: ._index, _id: ._id } }, ._source' > "$backup_dir/$index.json"

  echo "Exporting mapping for index: $index"
  curl -s --user $CURL_USER -XGET "$HOST/$index/_mapping" --max-time 600 | jq -c '.[] | {mappings: .mappings}' > "$mapping_dir/${index}.json"

  echo "Exporting alias for index: $index"
  # Lấy danh sách các alias
aliases=$(curl -s --user $CURL_USER -XGET "$HOST/$index/_alias" --max-time 600 | jq -r '.[].aliases | keys[]')

  # Tạo một mảng JSON rỗng
  echo '{ "actions": [' > "$alias_dir/${index}.json"
  
  # Duyệt qua từng alias và thêm vào mảng JSON
  first=true
  for alias in $aliases; do
    if [ "$first" = true ]; then
      first=false
    else
      echo ',' >> "$alias_dir/${index}.json"
    fi
    echo "  { \"add\": { \"index\": \"$index\", \"alias\": \"$alias\" } }" >> "$alias_dir/${index}.json"
  done

  # Đóng mảng JSON và kết thúc file
  echo ']' >> "$alias_dir/${index}.json"
  echo '}' >> "$alias_dir/${index}.json"
done

echo "Data export complete."
