#!/bin/bash

set -e
# Change working directory to the directory of this script
cd "$(dirname "$0")"
# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
echo "--------------------"
echo "WARNING: Before reindex, you should create a snapshot to backup data !"
echo "--------------------"
echo -n "Enter old index name: "
    read OLD_INDEX
echo -n "Enter new index name: "
    read NEW_INDEX

# Kiểm tra xem OLD_INDEX nếu có nhiều hơn 1 alias sẽ dừng lại và báo thông báo cho người dùng
########## Truy vấn tên alias của OLD_INDEX
ALIAS_RESULT=$(curl -s --user $CURL_USER -X GET "${HOST}/${OLD_INDEX}/_alias")

########## Lấy danh sách tên alias
ALIAS_NAMES=$(echo $ALIAS_RESULT | jq -r ".${OLD_INDEX}.aliases | keys[]")

# Kiểm tra nếu ALIAS_NAMES rỗng, yêu cầu người dùng nhập tên alias
if [ -z "$ALIAS_NAMES" ]; then
    echo "No alias found for $OLD_INDEX."
    echo -n "Please enter an alias name: "
    read ALIAS_NAMES
else
    ########## Đếm số lượng alias (nếu ALIAS_NAMES không rỗng)
    ALIAS_COUNT=$(echo "$ALIAS_NAMES" | wc -l)

    ########## Kiểm tra số lượng alias
    if [ "$ALIAS_COUNT" -gt 1 ]; then
        echo "ERROR: The index $OLD_INDEX has more than one alias."
        exit 1
    fi
fi
########## Lưu trữ tên alias duy nhất
ALIAS_NAME=$ALIAS_NAMES

# Reindex dữ liệu và thay đổi giá trị từ bool sang int
curl -s --user $CURL_USER -X POST "${HOST}/_reindex" -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "'$OLD_INDEX'"
  },
  "dest": {
    "index": "'$NEW_INDEX'"
  }
}' | jq .
#Hỏi có đồng ý thay thế index cũ thành index mới luôn không
read -p "Are you want replace alias of old index forgit new index after reindex? (y/n) " answer
case $answer in
    [Yy]* ) 
        # Tạo một tên alias ngẫu nhiên cho index cũ để index mới có thể gắn alias này cho nó
        RANDOM_ALIAS="${OLD_INDEX}_$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)"

        ############ Thêm alias ngẫu nhiên vào OLD_INDEX
        curl -s --user $CURL_USER -X POST "${HOST}/_aliases" -H 'Content-Type: application/json' -d'
        {
          "actions": [
            {
              "add": {
                "index": "'$OLD_INDEX'",
                "alias": "'$RANDOM_ALIAS'"
              }
            }
          ]
        }' | jq .

        # Alias cũ cho Index mới 
        curl -s --user $CURL_USER -X POST "${HOST}/_aliases" -H 'Content-Type: application/json' -d'
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


         ############ Xóa alias index cũ 
        bash alias/_delete_alias.sh $OLD_INDEX $ALIAS_NAME 
        
       
        ;;
    [Nn]* )
        echo "Bye !"
        exit
        ;;
    * ) 
        echo "Vui lòng trả lời y hoặc n."
        ;;
esac
