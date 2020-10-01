#json同步脚本
FROM_DIR=/home/ftp/deepin-community-store/
TO_DIR=/home/ftp/json/

# 从gitee上拉去已合并的pr
cd $TO_DIR
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jerrygithub
git pull origin
echo " 从gitee拉取完毕"

# 从仓库更新json,从中文json生成英文
cd $FROM_DIR
find store -type d -exec mkdir -p $TO_DIR\{\} \;

for i in `find store -iname "*.json" -type f` 
do
		di=${i%/*}
		filetimestamp_old=`stat -c %Y $TO_DIR$di/app.json`
		cp $i $TO_DIR$di/app.json -u  # -u 表示只更新
		filetimestamp_new=`stat -c %Y $TO_DIR$di/app.json`
		timecha=$[$filetimestamp_new - $filetimestamp_old]
		if [ $timecha -gt 60 ];then   #如果cp -u 前后两个文件的时间戳大于60s， 则说明app.json 发生了变动
				  echo 'app.json信息发生变动'
					cp $i $TO_DIR$di/app.en.json  #app.json更新则更新app.en.json
		fi
done
echo "从仓库更新完毕"
cd $TO_DIR

#生成 applist.json 和 applist.en.json
cd store
for i in `ls` #for循环遍历store目录下的文件
do
    if [ -d $i ] ; then #如果当前变量的是目录
        cd $i #进入目录
        echo $i
				if [ -f 'applist.json' ];then
            cat `find . -name 'app.json' -type f`|jq -s . > applist.json #查找所有的json文件
            cat `find . -name 'app.en.json' -type f`|jq -s . > applist.en.json
				fi
        cd ..
    fi
done
echo "商店信息写入完毕"
date

cd ..
#合并仓库生成的新json和来自gitee仓库的pr推送到gitee
git add .
git commit -m "auto push"
git push origin

# 同步到下游
rsync -rztP --delete-after /home/ftp/json/  spark@101.132.134.206::json --password-file=/etc/rsyncpasswd