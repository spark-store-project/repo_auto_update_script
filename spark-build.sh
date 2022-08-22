sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
# 换源
apt update
export DEBIAN_FRONTEND=noninteractive
echo "安装git devscripts equivs ..."
apt install git devscripts equivs curl -y 
git clone https://gitlink.org.cn/shenmo7192/dtk-old-bundle.git
cd dtk-old-bundle
apt install ./*.deb -y
cd ..
rm -rf dtk-old-bundle
mkdir build-spark
cd build-spark

git clone https://gitee.com/deepin-community-store/spark-store
cd spark-store
mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes  -y" 

dpkg-buildpackage -b -us -uc
cd ..
ls -all
pwd

