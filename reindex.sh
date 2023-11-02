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

########## Đếm số lượng alias
ALIAS_COUNT=$(echo "$ALIAS_NAMES" | wc -l)

########## Kiểm tra số lượng alias
if [ "$ALIAS_COUNT" -gt 1 ]; then
    echo "ERROR: The index $OLD_INDEX has more than one alias."
    exit 1
fi
########## Lưu trữ tên alias duy nhất
ALIAS_NAME=$ALIAS_NAMES # ALIAS_NAME có khả năng bị rỗng nếu index không có alias
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
        # Giả sử ban đầu có 2 index truyền vào là:
        # _ group_post_1
        # _ group_post_2 (chưa có dữ liệu)

        # Thì bây giờ nó đã trở thành
        # _Trường hợp 1:
        # ___ group_post_1
        # ___ group_post_2 (Đã có dữ liệu và giữ liệu group_post_2 giống y như group_post_1)
        # _Trường hợp 2:
        # group_post group_post_1
        # ___ group_post_2 (Đã có dữ liệu và giữ liệu group_post_2 giống y như group_post_1)
        
        # Bây giờ ta mong muốn kết quả là:
        # group_post group_post_2

        # Đầu tiên ta sẽ xóa đi index
        bash index/_delete_index.sh $OLD_INDEX
        
        

        # Alias cũ cho Index mới
        # Lúc này nếu trường hợp 1 thì rõ ràng không có alias ta sẽ lấy tên của old index làm alias
        # -- Kiểm tra nếu ALIAS_NAME rỗng, gán giá trị mặc định là INDEX
        if [ -z "$ALIAS_NAME" ]; then
            ALIAS_NAME=$OLD_INDEX
        fi
         
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
        ;;
    [Nn]* )
        echo "Bye !"
        exit
        ;;
    * ) 
        echo "Vui lòng trả lời y hoặc n."
        ;;
esac
