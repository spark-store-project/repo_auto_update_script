#文档：updating.flag：刷新锁定
#ready.flag：存在时表示仓库已就绪，用于下游同步trigger
#refresh.flag和finish-refresh.flag：和refresh.sh交互

REPOPATH="/home/ftp/spark-store" #设置软件源目录

if [ ! -f $REPOPATH/ready.flag ]; then
echo "检测到其他同步进程,或者上次同步未完成,退出同步"
echo "等待其他同步进程完成或者 touch $REPOPATH/ready.flag"
exit 0 
fi

FRESH=0 #刷新状态初始化
cd $REPOPATH #进入根目录
echo "================================================"
echo "星火仓库更新启动，已经进入仓库目录，目录为"
pwd #显示路径
echo "插入updating.flag旗帜锁，拔除ready.flag旗帜锁定"
touch updating.flag
rm -f ready.flag
echo "================================================"
echo "仓库状态更新：就绪--->同步中"
#rm ../submit/仓库状态：就绪
#echo syncing > ../submit/仓库状态：同步中
#先同步,不删除
#ossutil 用 ossutil 同步到oss而不是rsync 效率更高
ossutil cp /home/ftp/spark-store/ oss://spark-store-2/ -ru --config-file=/root/.ossutilconfig

# rsync
# 镜像1
#rsync -avz --delete -P  /home/ftp/spark-store/ spark@203.195.233.60::spark --password-file=/etc/rsyncpasswd
# 镜像2
#rsync -avz -P  /home/ftp/spark-store/ spark@47.240.118.5::spark --password-file=/etc/rsync_passwd
#rsync -avz -P /home/ftp/spark-store/ spark@app-store.githall.com::spark --password-file=/etc/rsync_passwd
# 
#第二条是镜像源，只有图片

#rm ../submit/仓库状态：同步中
echo "仓库状态更新：同步中--->哈希校验"
#echo hashing > ../submit/仓库状态：哈希校验
echo "第一遍同步已经完成，开始刷新apt"
#生成文件
apt-ftparchive packages . > Packages
sed -i 's@\./@@' Packages
apt-ftparchive release . > Release
echo "刷新完毕，开始签名"
rm InRelease
gpg --clear-sign  -o InRelease Release
echo "签名完毕"

echo "仓库状态更新：哈希校验--->刷新商店应用列表"
#rm ../submit/仓库状态：哈希校验
#echo refreshing > ../submit/仓库状态：刷新商店应用列表
#刷新json
echo "插入refresh.flag旗帜，拔除finish-refresh.flag旗帜，持续检测刷新状态"
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

echo "检测到finish-refresh.flag旗帜，仓库状态更新：刷新商店应用列表--->发布中"
#rm ../submit/仓库状态：刷新商店应用列表
#echo publishing > ../submit/仓库状态：发布中


#ossutil
ossutil cp /home/ftp/spark-store/ oss://spark-store-2/ -ru --config-file=/root/.ossutilconfig

#Rsync
# 镜像1
#rsync -avz --delete -P  /home/ftp/spark-store/ spark@203.195.233.60::spark --password-file=/etc/rsyncpasswd
# 镜像2
#rsync -avz --delete -P  /home/ftp/spark-store/ spark@47.240.118.5::spark --password-file=/etc/rsync_passwd
#rsync -avz --delete -P /home/ftp/spark-store/ spark@app-store.githall.com::spark --password-file=/etc/rsync_passwd


#同步json

rsync -rztP --delete-after /home/ftp/spark-store/  spark@101.132.134.206::json \
 --password-file=/etc/rsyncpasswd  --include "*/"  --include "*.json" --exclude='*'

#同步json png
bash /root/syn_jsonpic_jsd.sh

#rm ../submit/仓库状态：发布中
#echo ready > ../submit/仓库状态：就绪
echo "仓库状态更新：发布中--->就绪"
rm $REPOPATH/updating.flag
touch $REPOPATH/ready.flag
