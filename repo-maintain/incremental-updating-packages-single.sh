#!/bin/bash
###### 这里要写绝对路径
REPO_DIR="$1"
DATA_DIR="$REPO_DIR/package-data"

######阶段1：检查data目录下的.deb.package文件，去仓库验证是否有对应的.deb
######如果有，则对比时间戳，若仓库的新于.deb.package，则更新，否则continue
######如果没有，则删除此文件
mkdir -p $DATA_DIR
cd $DATA_DIR
for DEB_PACKAGE_INFO_PATH in `find . -name '*.deb.package'`;do

DEB_PATH=`echo ".${DEB_PACKAGE_INFO_PATH%%.package}"` 
if [ -e $DEB_PATH ];then
	if [ "$DEB_PACKAGE_INFO_PATH"  -ot "$DEB_PATH" ] ;then
		###时间戳校验
		echo "$DEB_PATH在生成package文件后发生了改变，将重新生成"
		rm $DEB_PACKAGE_INFO_PATH
	fi

else
echo "$DEB_PATH 已下架"
rm $DEB_PACKAGE_INFO_PATH
#####删除已下架的包

fi


done

##### 阶段2：反查deb，如果有.deb.package，则跳过，否则生成
cd $REPO_DIR

for DEB_PATH in `find . -name '*.deb'`;do

if [ -e $DATA_DIR/$DEB_PATH.package ];then
continue

else
mkdir -p $DATA_DIR/`dirname $DEB_PATH`

iszstd=`file "$DEB_PATH" | grep tar.zs`

##################################################
#判断是否为zstd并执行相关操作

if [ "$iszstd" != "" ];then
	echo "这是zstd包！解压并重新打包"
    	echo "This is debian package with zstd! Unpack and repack..."
	mkdir -p "$DATA_DIR/`dirname $DEB_PATH`/unpack-dir"
	cd "$DATA_DIR/`dirname $DEB_PATH`/unpack-dir"
	ar -vx "$REPO_DIR/$DEB_PATH" 
	rm debian-binary
	tar -I zstd -xvf data.tar.zst
	mkdir DEBIAN
	tar -I zstd -xvf control.tar.zst -C ./DEBIAN
	rm data.tar.zst control.tar.zst
	dpkg-deb -Z xz  -b "$DATA_DIR/`dirname $DEB_PATH`/unpack-dir/" "$REPO_DIR/`dirname $DEB_PATH`"
	echo 重打包已完成，删除tmp
    	echo "Repack finished. Remove tmp dir"
	cd $REPO_DIR
	rm -rf "$DATA_DIR/`dirname $DEB_PATH`/unpack-dir"
	
	
fi
apt-ftparchive packages $DEB_PATH > $DATA_DIR/$DEB_PATH.package
echo "新包 $DEB_PATH 已生成package文件"
fi
done

#####删除data目录下所有空文件夹

find $DATA_DIR -type d -empty -exec rm -rf {} \;

##### 合成Packages
rm $REPO_DIR/Packages
cd $DATA_DIR
for DEB_PACKAGE_INFO_PATH in `find . -name '*.deb.package'`;do
cat $DEB_PACKAGE_INFO_PATH >> $REPO_DIR/Packages
done
