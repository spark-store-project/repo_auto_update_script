


mkdir build-spark
cd build-spark
apt update

echo "安装git devscripts equivs ..."
apt install git devscripts equivs curl -y >/dev/null 2>&1

mkdir build-dtk && cd build-dtk
git clone https://gitee.com/deepin-community-store/spark-dtk
cd spark-dtk


cd libdtkcommon/dtkcommon-5.5.17 && mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y"  && dpkg-buildpackage -b -us -uc
cd ..
apt install ./*.deb -y
cd ..

cd dtkcore/dtkcore-5.4.20 && mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" && dpkg-buildpackage -b -us -uc
cd ..
apt install ./*.deb -y
cd .. 

cd dtkwidget/dtkwidget-5.4.20 && mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes --no-install-recomme
ds -y" && dpkg-buildpackage -b -us -uc
cd ..
apt install ./*.deb -y
cd .. 

cd dtkgui/dtkgui-5.4.15 && mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" && dpkg-buildpackage -b -us -uc
cd ..
apt install ./*.deb -y
cd .. 

cd ../..

rm -rf build-dtk

git clone https://gitee.com/deepin-community-store/spark-store 
cd spark-store



mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" 
dpkg-buildpackage -b -us -uc

curl -s --url "smtp://smtp.163.com" --mail-from "sparkstorefeedback@163.com" --mail-rcpt "shenmo@spark-app.store" --upload-file ./*.deb --user "sparkstorefeedback@163.com:YWYGLQNOPLWNNJJY"