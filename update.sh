REPOPATH="/home/ftp/deepin-community-store" #设置软件源目录
while true; do
cd $REPOPATH #进入根目录
pwd #显示路径
#生成文件
#apt-ftparchive packages . > Packages
#apt-ftparchive release . > Release

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
            echo "[" >> applist.json #写入数组的左边
            isFind="0" #设置标记，用来处理空文件
            for j in `find . -name '*.json' -type f` #查找所有的json文件
            do
                if [ -s $j ] ; then #如果文件存在切不为空
                    result=$(echo $j | grep "applist.json") #判断是否包含applist.json
                    if [ "$result" == "" ] ;then #不包含
                        isFind="1" #不是空文件
                        cat $j >>applist.json #json写入文件
                        echo ",">> applist.json #用逗号分隔
                    fi
                fi
            done

            if [ $isFind -eq "1" ];then #判断找到的文件是否是全空的
                sed -i '$d' applist.json #删除最后一行的逗号
            fi
            echo "]">> applist.json #写入右半部分
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
root@VM395:~# cat update.sh 
REPOPATH="/home/ftp/deepin-community-store" #设置软件源目录
FRESH=0 #刷新状态初始化
cd $REPOPATH #进入根目录
pwd #显示路径

rm ../submit/仓库状态：就绪
echo syncing > ../submit/仓库状态：同步中
#先同步,不删除
rsync -avz -P /home/ftp/deepin-community-store/ spark@47.100.240.146::spark --password-file=/etc/rsync_passwd
rsync -avz -P --exclude="*.deb" /home/ftp/deepin-community-store/ spark@39.106.2.2::spark --password-file=/etc/rsync_passwd
#第二条是镜像源，只有图片

rm ../submit/仓库状态：同步中
echo hashing > ../submit/仓库状态：哈希校验
#生成文件
apt-ftparchive packages . > Packages
sed -i 's@\./@@' Packages
apt-ftparchive release . > Release
rm InRelease
gpg --clear-sign  -o InRelease Release

rm ../submit/仓库状态：哈希校验
echo refreshing > ../submit/仓库状态：刷新商店应用列表
#刷新json
rm ${REPOPATH}/finish-refresh.flag
touch ${REPOPATH}/refresh.flag
while (("$FRESH=0"))
do
if [ -f "${REPOPATH}/finish-refresh.flag" ];then
FRESH=1
else
sleep 5
fi 
done
rm ../submit/仓库状态：刷新商店应用列表
echo publishing > ../submit/仓库状态：发布中


#Rsync
rsync -avz --delete -P /home/ftp/deepin-community-store/ spark@47.100.240.146::spark --password-file=/etc/rsync_passwd
rsync -avz --delete -P --exclude="*.deb" /home/ftp/deepin-community-store/ spark@39.106.2.2::spark --password-file=/etc/rsync_passwd

rm ../submit/仓库状态：发布中
echo ready > ../submit/仓库状态：就绪
