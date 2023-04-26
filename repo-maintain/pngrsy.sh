#json同步脚本
FROM_DIR=/home/ftp/spark-store/
TO_DIR=/home/ftp/spark-store-png-accelerate/

echo "图片同步"
# 从gitlink上拉去已合并的pr
cd $TO_DIR
git pull origin
echo " 从gitlink拉取完毕"


mkdir -p store/home/links
mkdir -p aarch64-store/home/links

rsync -av --delete --include='*.png' --exclude='*' $FROM_DIR $TO_DIR

cd $FROM_DIR
cp store/home/links/*.png $TO_DIR/store/home/links/ -u
cp aarch64-store/home/links/*.png $TO_DIR/aarch64-store/home/links/ -u

cd $TO_DIR

#合并仓库生成的新json和来自gitee仓库的pr推送到gitee
git add .
git config user.name spark-bot
git config user.email jifengshenmo@outlook.com
git commit -m "auto push"
git push origin

# 同步到下游
#rsync -rztP --delete-after /home/ftp/json/  spark@101.132.134.206::json --password-file=/etc/rsyncpasswd --exclude ".git*"
