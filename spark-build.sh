sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
# 换源
apt update
export DEBIAN_FRONTEND=noninteractive
echo "安装git devscripts equivs curl..."
apt install git devscripts equivs curl -y 
git clone https://gitlink.org.cn/shenmo7192/dtk-old-bundle.git
cd dtk-old-bundle
apt install ./*.deb -y
cd ..
rm -rf dtk-old-bundle
mkdir build-spark
cd build-spark


cd spark-store
# sed -i 's/-j$(JOBS)/-j1/g' debian/rules

mk-build-deps --install --tool "apt-get -o Debug::pkgProblemResolver=yes  -y" 

dpkg-buildpackage -b -us -uc
cd ..
ls -all
pwd

mkdir target 
for f in $(find . -type f -name "*.deb")
do
    mv $f target
done
