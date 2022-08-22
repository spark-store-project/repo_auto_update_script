


mkdir build-spark
cd build-spark
apt update

echo "安装git devscripts equivs curl zip  ..."
apt install git devscripts equivs curl zip -y >/dev/null 2>&1

mkdir build-dtk && cd build-dtk
git clone https://gitee.com/deepin-community-store/spark-dtk
cd spark-dtk


cd libdtkcommon/dtkcommon-5.5.17 && mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes -y"  && dpkg-buildpackage -b -us -uc
cd ..
apt install ./*.deb -y
cd ..

cd dtkcore/dtkcore-5.4.20 && mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes  -y" && dpkg-buildpackage -b -us -uc
cd ..
apt install ./*.deb -y
cd .. 


cd dtkgui/dtkgui-5.4.15 && mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes  -y" && dpkg-buildpackage -b -us -uc
cd ..
apt install ./*.deb -y
cd .. 

cd dtkwidget/dtkwidget-5.4.20 && mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes -y" && dpkg-buildpackage -b -us -uc
cd ..
apt install ./*.deb -y
cd .. 


cd ../..
mkdir dtk-core
for f in $(find . -type f -name "*.deb")
do
    mv $f dtk-core
done



zip -r -9 dtk-core.zip dtk-core

curl bashupload.com -T dtk-core.zip