REPOPATH="/home/ftp/deepin-community-store" #设置软件源目录
cd $REPOPATH #进入根目录
echo "星火刷新daemon守护启动，已经进入仓库目录，目录为"
pwd #显示路径
echo "进入待命状态"
#生成文件
#apt-ftparchive packages . > Packages
#apt-ftparchive release . > Release

while true; do
if [ -f "${REPOPATH}/refresh.flag" ];then
#删除flag
rm ${REPOPATH}/refresh.flag
#进入update阶段

find "${REPOPATH}" -name '*.update' -print0 | xargs -0 file-rename -f -v 's/\.update$//'
#以上来源abcfy2

cd store #进入store目录

for i in `ls` #for循环遍历store目录下的文件
do
    if [ -d $i ] ; then #如果当前变量的是目录
        cd $i #进入目录
        if [ -f 'applist.json' ];then #如果存在特定文件
            rm applist.json #删除
            cat `find . -name 'app.json' -type f`|jq -s . > applist.json
            #查找所有的json文件
            echo "商店信息写入完毕"
        fi
        cd ..
    fi

done

date
touch ${REPOPATH}/finish-refresh.flag

#以上来源pluto
else 
sleep 30
fi
done
