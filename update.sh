cd deepin-community-store
while true; do
apt-ftparchive packages . > Packages
apt-ftparchive release . > Release

cd store

cd development
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd image_graphic 
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd network
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd reading
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd tools
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd games
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd music
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd others
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd themes
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..

cd video
rm applist.json
pwd
cat *.json | cat >applist.json && echo 商店信息写入完毕
cd ..


cd ..


date
sleep 7200
done
