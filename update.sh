cd deepin-community-store
for ((i=1;i<=100;i++));
do
for ((j=1;j<=100;j++));
do
#以为是循环有问题，又换成了硬核循环，然并卵还是运行几次之后就不能用了，好奇怪。。。
nice apt-ftparchive packages . > Packages
nice apt-ftparchive release . > Release

cd store

cd development
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..

cd image_graphic 
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..

cd network
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..

cd reading
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..

cd tools
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入
mv applist.txt applist.json
cd ..

cd games
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..

cd music
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..

cd others
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..

cd themes
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..

cd video
rm applist.json
pwd
cat `find ./ -type f -name "*.json"` | cat >applist.txt && echo 商店信息写入完毕
mv applist.txt applist.json
cd ..


cd ..


date
sleep 1800
done
done
