REPOPATH="$1" #设置软件源目录
cd $REPOPATH #进入根目录
pwd



#进入update阶段
echo "开始刷新第一阶段：处理旧式投稿工具的.update文件"
for i in $(find store/upload_tgz -name '*.tar.gz');do tar -xvf $i -C store/; rm $i; done
for i in $(find aarch64-store/upload_tgz -name '*.tar.gz');do tar -xvf $i -C aarch64-store/; rm $i; done
find "." -name '*.update' -print0 | xargs -0 file-rename -f -v 's/\.update$//'
chmod 644 -R .
echo ".update已经去除，刷新第一阶段完成"
#以上来源abcfy2
echo "开始刷新第二阶段：json合并"
########转为使用download-rank排序
#cd store #进入store目录
#
#for i in `ls` #for循环遍历store目录下的文件
#do
#    if [ -d $i ] ; then #如果当前变量的是目录
#        cd $i #进入目录
#        if [ -f 'applist.json' ];then #如果存在特定文件
#            rm applist.json #删除
#            cat `find . -name 'app.json' -type f`|jq -s . > applist.json
#            #查找所有的json文件
#            echo "分类信息写入完毕"
#        fi
#        cd ..
#    fi
#
#done
/root/repo-scripts/repo_auto_update_script/repo-maintain/download-rank-json-gen.sh $REPOPATH/store
/root/repo-scripts/repo_auto_update_script/repo-maintain/download-rank-json-gen.sh $REPOPATH/aarch64-store
echo "所有分类遍历完毕，json信息已经整合完成，刷新第二阶段完毕"

# 同步json
echo "开始刷新第三阶段：同步推送"
bash /root/repo-scripts/repo_auto_update_script/repo-maintain/jsonrsy.sh
#同步 图片
#bash /root/repo-scripts/repo_auto_update_script/repo-maintain/pngrsy.sh

# 不再用 jsd 不需要同步了
# bash /root/syn_jsonpic_jsd.sh

echo "星火刷新daemon守护已完成刷新"
echo "刷新时间为"
date

#以上来源pluto


