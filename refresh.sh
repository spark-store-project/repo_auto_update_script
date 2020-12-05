REPOPATH="/home/ftp/deepin-community-store" #设置软件源目录
cd $REPOPATH #进入根目录
echo "================================================"
echo "星火刷新daemon守护启动，已经进入仓库目录，目录为"
pwd #显示路径
echo "守护模式已经开启，正在持续检测旗帜信号"
echo "================================================"
#生成文件
#apt-ftparchive packages . > Packages
#apt-ftparchive release . > Release

while true; do
if [ -f "${REPOPATH}/refresh.flag" ];then
#删除flag
echo "检测到旗帜refresh.flag已经插入，收到信号，拔除旗帜"
rm ${REPOPATH}/refresh.flag
#进入update阶段
echo "开始刷新第一阶段：处理旧式投稿工具的.update文件"
find "${REPOPATH}" -name '*.update' -print0 | xargs -0 file-rename -f -v 's/\.update$//'
echo ".update已经去除，刷新第一阶段完成"
#以上来源abcfy2
echo "开始刷新第二阶段：json合并"
cd store #进入store目录

for i in `ls` #for循环遍历store目录下的文件
do
    if [ -d $i ] ; then #如果当前变量的是目录
        cd $i #进入目录
        if [ -f 'applist.json' ];then #如果存在特定文件
            rm applist.json #删除
            cat `find . -name 'app.json' -type f`|jq -s . > applist.json
            #查找所有的json文件
            echo "分类信息写入完毕"
        fi
        cd ..
    fi

done
echo "所有分类遍历完毕，json信息已经整合完成，刷新第二阶段完毕"

# 同步json
echo "开始刷新第三阶段：同步推送"
bash /root/jsonrsy.sh
#同步 图片
bash /root/syn_jsonpic_jsd.sh
touch ${REPOPATH}/finish-refresh.flag

sleep 2
echo "================================================"
echo "刷新进程结束，插入finish-refresh.flag以便其他进程读取"
echo "================================================"
sleep 3
reset
echo "星火刷新daemon守护已完成刷新"
echo "刷新时间为"
date
echo "已进入守护模式，正在持续检测旗帜信号"
#以上来源pluto
else 
sleep 5
fi
done
