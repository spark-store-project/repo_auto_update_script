
sudo sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

mkdir build-spark
cd build-spark
apt update

echo "安装git devscripts equivs ..."
apt install git devscripts equivs curl -y >/dev/null 2>&1

git clone https://gitee.com/deepin-community-store/spark-store 
cd spark-store

mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" 
dpkg-buildpackage -b -us -uc

curl -s --url "smtp://smtp.163.com" --mail-from "sparkstorefeedback@163.com" --mail-rcpt "shenmo@spark-app.store" --upload-file ./*.deb --user "sparkstorefeedback@163.com:YWYGLQNOPLWNNJJY"