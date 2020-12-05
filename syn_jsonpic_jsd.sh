FROM_DIR=/home/ftp/deepin-community-store/
TO_DIR=/home/ftp/jsonpic/

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jerrygithub


cd $FROM_DIR

find store -type d -exec mkdir -p $TO_DIR\{\} \;


for i in `find store -iname "*.json" -type f` 
do
di=${i%/*}
cp $i $TO_DIR$di -u
done

for i in `find store -iname "*.png" -type f` 
do
di=${i%/*}
cp $i $TO_DIR$di -u
done

cd $TO_DIR
#git init
#git remote add origin git@github.com:Jerrywang959/jsonpng.git
#git pull origin
git add .
git config user.email "767729940@qq.com"
git config user.name "jerry"
git commit -m "auto push"
git push origin 
echo "同步完成"