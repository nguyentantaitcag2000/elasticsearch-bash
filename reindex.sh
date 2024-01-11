#!/bin/bash

set -e
# Change working directory to the directory of this script
cd "$(dirname "$0")"
# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
echo "--------------------"
echo "WARNING: Before reindex"
echo "1. You must prevent all user insert & update & delete to index!"
echo ""
echo "2. You must copy the current Index (because reindexing may"
echo "encounter an error, and at this time the old index has already"
echo "been deleted, so if this error occurs, it will lead to data loss)"
echo ""
echo "3. You Must waiting the progress clone index have been already successs"
echo ""
echo "--------------------"
# Nhập tên index cũ và mới
read -p "Enter old index name: " OLD_INDEX
read -p "Enter new index name: " NEW_INDEX
# Hỏi xem người dùng muốn đổi tên trường không
read -p "Do you want rename a field (y/n): " RENAME_FIELD
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

# Khai báo mảng để lưu trữ danh sách các trường cũ và mới
OLD_FIELDS=()
NEW_FIELDS=()

# Reindex dữ liệu
if [ "$RENAME_FIELD" = "y" ]; then
    while true; do
        # Nhập tên trường cũ và mới nếu người dùng muốn đổi
        read -p "Enter old field name (Enter to exit): " OLD_FIELD
        [ -z "$OLD_FIELD" ] && break
        read -p "Enter new field name: " NEW_FIELD
        # Thêm trường cũ và mới vào mảng
        OLD_FIELDS+=("$OLD_FIELD")
        NEW_FIELDS+=("$NEW_FIELD")
    done

    # Duyệt qua mảng và thực hiện reindex cho từng cặp trường cũ và mới
    for ((i=0; i<${#OLD_FIELDS[@]}; i++)); do
        # Escape special characters in the script
        ESCAPED_OLD_FIELD=$(printf "%s" "${OLD_FIELDS[i]}" | sed 's/"/\\"/g')
        ESCAPED_NEW_FIELD=$(printf "%s" "${NEW_FIELDS[i]}" | sed 's/"/\\"/g')
        SCRIPT+="ctx._source.${ESCAPED_NEW_FIELD} = ctx._source.remove('${ESCAPED_OLD_FIELD}');"
    done

    curl -s --user $CURL_USER -X POST "${HOST}/_reindex" -H 'Content-Type: application/json' -d"
    {
      \"source\": {
        \"index\": \"$OLD_INDEX\"
      },
      \"dest\": {
        \"index\": \"$NEW_INDEX\"
      },
      \"script\": {
        \"source\": \"$SCRIPT\"
      }
    }" | jq .
else
    curl -s --user $CURL_USER -X POST "${HOST}/_reindex" -H 'Content-Type: application/json' -d"
    {
      \"source\": {
        \"index\": \"$OLD_INDEX\"
      },
      \"dest\": {
        \"index\": \"$NEW_INDEX\"
      }
    }" | jq .
fi

# Giả sử ban đầu có 2 index truyền vào là:
# _ group_post_1
# _ group_post_2 (chưa có dữ liệu)

# Thì bây giờ nó đã trở thành

# _Trường hợp 1: (lần đầu reindex nên chưa có alias)
# ___ group_post_1
# ___ group_post_2 (Đã có dữ liệu và giữ liệu group_post_2 giống y như group_post_1)

# _Trường hợp 2: (Đã từng reindex trước đây mới có dạng này)
# group_post group_post_1
# ___ group_post_2 (Đã có dữ liệu và giữ liệu group_post_2 giống y như group_post_1)

# Bây giờ ta mong muốn kết quả là:
# group_post group_post_2


# Nếu $ALIAS_NAME trống sẽ là trường hợp đầu tiên, xóa đi index cũ
if [ -z "$ALIAS_NAME" ]; then
    # bash index/_delete_index.sh $OLD_INDEX
    #Lúc này rới vào trường hợp 1, ta sẽ không xóa nó đi vì làm như vậy rất nguy hiểm, lỡ như trong quá trình reindex xảy
    #.. ra lỗi sẽ dẫn tới mất dữ liệu nên nếu gặp trường hợp này ta sẽ dừng lại chương trình tại đây và thông báo các bước
    # tiếp theo cho người dùng cần làm thủ công
    echo "This index is first time to reindex, you must do a some manual steps, this program will stop in here"
    exit 1
else
    #Lúc này là trường hợp 2, khi ở trường hợp này ta sẽ set alias cho nó là rỗng bằng cách xóa đi alias của nó
    #.. Sau đó sẽ có dạng:
    # ___ group_post_1
    # ___ group_post_2 (Đã có dữ liệu và giữ liệu group_post_2 giống y như group_post_1)
    bash alias/_delete_alias.sh $OLD_INDEX $ALIAS_NAME

    # Lúc này khi chạy đoạn command gán alias phía dưới nó sẽ có dạng
    # ___ group_post_1
    # group_post group_post_2 (Đã có dữ liệu và giữ liệu group_post_2 giống y như group_post_1)
fi
# Ngược lại vẫn giữ nguyên index cũ



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
