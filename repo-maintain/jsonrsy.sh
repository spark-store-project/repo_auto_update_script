#json同步脚本
FROM_DIR=/home/ftp/spark-store/
TO_DIR=/home/ftp/json/

# 从gitee上拉去已合并的pr
cd $TO_DIR
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jerrygithub
git pull origin
echo " 从gitee拉取完毕"

# 从仓库更新json, 从中文json生成英文
cd $FROM_DIR
find store -type d -exec mkdir -p $TO_DIR\{\} \;

for i in `find store -iname 'app.json' -type f`
do
di=${i%/*}
cp $i $TO_DIR$di/app.json -u  # -u 表示只有当源文件比目标文件新(或者目标文件不存在)时，才会更新，这避免了冲突（我之前居然没有意识到）
cp $i $TO_DIR$di/en.app.json -u
done

for i in `find store -iname 'applist.json' -type f`
do
di=${i%/*}
cp $i $TO_DIR$di/applist.json -u  # -u 表示只有当源文件比目标文件新(或者目标文件不存在)时，才会更新，这避免了冲突（我之前居然没有意识到）
done

echo "从仓库更新完毕"


#合并仓库生成的新json和来自gitee仓库的pr推送到gitee
git add .
git commit -m "auto push"
git push origin

# 同步到下游
#rsync -rztP --delete-after /home/ftp/json/  spark@101.132.134.206::json --password-file=/etc/rsyncpasswd --exclude ".git*"