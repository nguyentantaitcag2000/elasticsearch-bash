#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env
source ../function.sh

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Kiểm tra nếu host đang sống
echo "Checking if Elasticsearch host is alive..."
status_code=$(curl -o /dev/null -s -w "%{http_code}" --user $CURL_USER -XGET "$HOST")

if [ "$status_code" -ne 200 ]; then
  echo "${red}Error: Elasticsearch host is not reachable. Status code: $status_code ${reset}"
  exit 1
else
  echo "Elasticsearch host is live. Proceeding with backup..."
fi

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

  # Kiểm tra nếu không có alias, bỏ qua việc tạo file JSON
  if [ -z "$aliases" ]; then
    echo "No aliases found for index $index. Skipping alias export."
    continue
  fi

  # Tạo một mảng JSON với các alias
  {
    echo '{ "actions": ['
    first=true
    for alias in $aliases; do
      if [ "$first" = true ]; then
        first=false
      else
        echo ','
      fi
      echo "  { \"add\": { \"index\": \"$index\", \"alias\": \"$alias\" } }"
    done
    echo ']'
    echo '}'
  } > "$alias_dir/${index}.json"
done

# Zip the backup folder
zip_file="G:/My Drive/General/Backup Data/ElasticSearch/backup_$(date +'%Y-%m-%d-%Hh%Mm%Ss').zip"
echo "Creating zip archive: $zip_file"
(cd "$backup_dir" && zip -r "$zip_file" .)

# Optionally, remove the unzipped backup folder
rm -rf "$backup_dir"

echo "Data export complete. Backup saved as $zip_file."
