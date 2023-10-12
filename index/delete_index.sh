#!/bin/bash

echo -n "Enter INDEX name: "
read INDEX

read -p "Bạn có muốn tiếp tục delete? (y/n) " answer
case $answer in
    [Yy]* ) 
        # Đặt lệnh bạn muốn thực hiện khi người dùng trả lời 'y' hoặc 'Y' ở đây
        echo "Đang thực hiện lệnh..."
	curl --user $CURL_USER -XDELETE "http://localhost:9200/$INDEX?pretty"
        ;;
    [Nn]* )
        # Thoát script nếu người dùng trả lời 'n' hoặc 'N'
        echo "Thoát!"
        exit
        ;;
    * ) 
        echo "Vui lòng trả lời y hoặc n."
        ;;
esac
bash ~/bash/index/helper.sh