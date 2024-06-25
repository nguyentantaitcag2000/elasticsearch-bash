#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
echo "-------------------------------------------"
echo "-----------------Indices-------------------"
echo "-------------------------------------------"
curl -s --user $CURL_USER -XGET "$HOST/_cat/indices?v"
echo "-------------------------------------------"
echo "-----------------Aliases-------------------"
echo "-------------------------------------------"
# Hiển thị danh sách các alias
curl -s --user $CURL_USER -XGET "$HOST/_cat/aliases?v"

echo "--------------Indices string---------------"

# Tạo một string comma-separated từ danh sách indices
indices=$(curl -s --user $CURL_USER -XGET "$HOST/_cat/indices?v" | awk '{print $3}' | grep -v "^index$")

# Khởi tạo biến indices_string rỗng
indices_string=""

# Duyệt qua từng chỉ mục và thêm vào indices_string, ngăn cách bằng dấu phẩy
for index in $indices; do
    indices_string="$indices_string$index,"
done

# Loại bỏ dấu phẩy cuối cùng nếu có
indices_string=$(echo $indices_string | sed 's/,$//')

echo "$indices_string"
