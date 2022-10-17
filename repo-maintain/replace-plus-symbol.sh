#!/bin/bash
REPO_PATH=/home/ftp/spark-store
cd "$REPO_PATH"
for DEB_WITH_PLUS_SYMBOL in `find . -name '*.deb' | grep +`;do
#### 文件改名
DEB_WITH_PLUS_SYMBOL_NAME=`basename "${DEB_WITH_PLUS_SYMBOL}"`
DEB_WITH_PLUS_SYMBOL_NAME_AFTER_CHANGE=`echo ${DEB_WITH_PLUS_SYMBOL_NAME} | sed 's/+/_plus_/g'`

if [ ! -e "`dirname ${DEB_WITH_PLUS_SYMBOL}`/${DEB_WITH_PLUS_SYMBOL_NAME_AFTER_CHANGE}" ];then
mv -v "${DEB_WITH_PLUS_SYMBOL}" "`dirname ${DEB_WITH_PLUS_SYMBOL}`/${DEB_WITH_PLUS_SYMBOL_NAME_AFTER_CHANGE}"
fi

if [ -e  "${DEB_WITH_PLUS_SYMBOL}.torrent" ] && [ ! -e "`dirname ${DEB_WITH_PLUS_SYMBOL}`/${DEB_WITH_PLUS_SYMBOL_NAME_AFTER_CHANGE}.torrent" ];then
#mv -v "${DEB_WITH_PLUS_SYMBOL}.torrent" "`dirname ${DEB_WITH_PLUS_SYMBOL}`/${DEB_WITH_PLUS_SYMBOL_NAME_AFTER_CHANGE}.torrent"
rm "${DEB_WITH_PLUS_SYMBOL}.torrent"
fi

if [ -e  "${DEB_WITH_PLUS_SYMBOL}.metalink" ] && [ ! -e "`dirname ${DEB_WITH_PLUS_SYMBOL}`/${DEB_WITH_PLUS_SYMBOL_NAME_AFTER_CHANGE}.metalink" ];then
mv -v "${DEB_WITH_PLUS_SYMBOL}.metalink" "`dirname ${DEB_WITH_PLUS_SYMBOL}`/${DEB_WITH_PLUS_SYMBOL_NAME_AFTER_CHANGE}.metalink"
fi

#### json更换

Filename_line=$(sed -n -e "/\"Filename\":/=" "`dirname ${DEB_WITH_PLUS_SYMBOL}`/app.json")
sed -i "$Filename_line"s/+/_plus_/g `dirname ${DEB_WITH_PLUS_SYMBOL}`/app.json

Torrent_address_line=$(sed -n -e "/\"Torrent_address\":/=" "`dirname ${DEB_WITH_PLUS_SYMBOL}`/app.json") 
sed -i "$Torrent_address_line"s/+/_plus_/g `dirname ${DEB_WITH_PLUS_SYMBOL}`/app.json


#####关键词行数取得




done