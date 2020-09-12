# 单纯同步json到5M主
FROM_DIR=/home/ftp/deepin-community-store/
TO_DIR=/home/ftp/json/

cd $FROM_DIR

find store -type d -exec mkdir -p $TO_DIR\{\} \;

for i in `find store -iname "*.json" -type f` 
do
di=${i%/*}
cp $i $TO_DIR$di -u
done

cd $TO_DIR

rsync -rztP --delete-after /home/ftp/json/  spark@101.132.134.206::json --password-file=/etc/rsyncpasswd

