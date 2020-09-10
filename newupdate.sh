#文档：updating.flag：刷新锁定
#ready.flag：存在时表示仓库已就绪，用于下游同步trigger
#refresh.flag和finish-refresh.flag：和refresh.sh交互

REPOPATH="/home/ftp/deepin-community-store" #设置软件源目录

if [ ! -f $REPOPATH/ready.flag ]; then
echo "检测到其他同步进程,或者上次同步未完成,退出同步"
echo "等待其他同步进程完成或者 touch $REPOPATH/ready.flag"
exit 0 
fi

FRESH=0 #刷新状态初始化
cd $REPOPATH #进入根目录
touch updating.flag
rm -f ready.flag
pwd #显示路径

rm ../submit/仓库状态：就绪
echo syncing > ../submit/仓库状态：同步中
#先同步,不删除
#ossutil 用 ossutil 同步到oss而不是rsync 效率更高
/root/ossutil/ossutil64 cp /home/ftp/deepin-community-store/ oss://spark-store-2/ -ru --config-file=/root/.ossutilconfig
# rsync
# 镜像1
rsync -avz --delete -P  /home/ftp/deepin-community-store/ spark@203.195.233.60::spark --password-file=/etc/rsyncpasswd
# 镜像2
rsync -rztP --delete-after --port=21901 /home/ftp/deepin-community-store/ spark@198.100.145.152::spark --password-file=/etc/rsyncpasswd
#rsync -avz -P  /home/ftp/deepin-community-store/ spark@47.240.118.5::spark --password-file=/etc/rsync_passwd
#rsync -avz -P /home/ftp/deepin-community-store/ spark@app-store.githall.com::spark --password-file=/etc/rsync_passwd
#新加的
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


#ossutil
/root/ossutil/ossutil64 cp /home/ftp/deepin-community-store/ oss://spark-store-2/ -ru --config-file=/root/.ossutilconfig
#Rsync
# 镜像1
rsync -avz --delete -P  /home/ftp/deepin-community-store/ spark@203.195.233.60::spark --password-file=/etc/rsyncpasswd
# 镜像2
rsync -rztP --delete-after --port=21901 /home/ftp/deepin-community-store/ spark@198.100.145.152::spark --password-file=/etc/rsyncpasswd
#rsync -avz --delete -P  /home/ftp/deepin-community-store/ spark@47.240.118.5::spark --password-file=/etc/rsync_passwd
#rsync -avz --delete -P /home/ftp/deepin-community-store/ spark@app-store.githall.com::spark --password-file=/etc/rsync_passwd

rm ../submit/仓库状态：发布中
echo ready > ../submit/仓库状态：就绪
rm $REPOPATH/updating.flag
touch $REPOPATH/ready.flag
