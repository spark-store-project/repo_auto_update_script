#json同步脚本
FROM_DIR=/home/ftp/spark-store/
TO_DIR=/home/ftp/spark-store-png-accelerate/

echo "图片同步"
# 从gitlink上拉去已合并的pr
cd $TO_DIR
git pull origin
echo " 从gitlink拉取完毕"

# 从仓库更新png
cd $FROM_DIR
find store -type d -exec mkdir -p $TO_DIR\{\} \;

for i in `find store -iname 'icon.png' -type f`
do
di=${i%/*}
cp $i $TO_DIR$di/icon.png -u  # -u 表示只有当源文件比目标文件新(或者目标文件不存在)时，才会更新，这避免了冲突（我之前居然没有意识到）
done

echo "从仓库更新完毕"
cd $TO_DIR

#合并仓库生成的新json和来自gitee仓库的pr推送到gitee
git add .
git commit -m "auto push"
git push origin

# 同步到下游
#rsync -rztP --delete-after /home/ftp/json/  spark@101.132.134.206::json --password-file=/etc/rsyncpasswd --exclude ".git*"