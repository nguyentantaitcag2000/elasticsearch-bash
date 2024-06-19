#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

MY_PASS="${PASS_GPG}"
USERNAME_DB="${DB_USERNAME}"
PASSWORD_DB="${DB_PASSWORD}"

backup_file=/home/website/backup/backup_$(date +%F.%H%M%S).sql.gz
/usr/bin/mysqldump -u"$USERNAME_DB" -p"$PASSWORD_DB" lazycodet | gzip > $backup_file
/usr/bin/echo "$MY_PASS" | /usr/bin/gpg --batch --passphrase-fd 0 -c $backup_file
#rm $backup_file
/usr/bin/php /home/website/cron/upload-to-telegram.php $backup_file |& tee /home/website/cron/error.log 2>&1
rm $backup_file.gpg
