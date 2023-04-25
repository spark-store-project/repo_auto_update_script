#json同步脚本
FROM_DIR=/home/ftp/spark-store/
TO_DIR=/home/ftp/json/

cd $TO_DIR
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jerrygithub
git pull origin

rsync -av --delete --include='*.json' --exclude='*' $FROM_DIR $TO_DIR


cd $TO_DIR

git add .
git config user.name spark-bot
git config user.email jifengshenmo@outlook.com
git commit -m "Update Appinfo From Spark Repo..."
git push origin

