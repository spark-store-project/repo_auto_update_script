REPOPATH="/home/ftp/deepin-community-store" #设置软件源目录
FRESH=0 #刷新状态初始化
cd $REPOPATH #进入根目录
pwd #显示路径

rm ../submit/仓库状态：就绪
echo syncing > ../submit/仓库状态：同步中
#先同步,不删除
rsync -avz -P /home/ftp/deepin-community-store/ spark@47.100.240.146::spark --password-file=/etc/rsync_passwd

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

rm ../submit/仓库状态：发布中
echo ready > ../submit/仓库状态：就绪
