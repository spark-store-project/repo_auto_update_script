REPOPATH="/media/root/其它/self_project/store.shenmo.tech" #设置软件源目录
cd $REPOPATH #进入根目录
pwd #显示路径
#生成文件
apt-ftparchive packages . > Packages
apt-ftparchive release . > Release

cd store #进入store目录
for i in `ls` #for循环遍历store目录下的文件
do
    if [ -d $i ] ; then #如果当前变量的是目录
        cd $i #进入目录
        if [ -f 'applist.json' ];then #如果存在特定文件
            rm applist.json #删除
            echo "[" >> applist.json #写入数组的左边
            isFind="0" #设置标记，用来处理空文件
            for j in `find . -name '*.json' -type f` #查找所有的json文件
            do
                if [ -s $j ] ; then #如果文件存在切不为空
                    result=$(echo $j | grep "applist.json") #判断是否包含applist.json
                    if [ "$result" == "" ] ;then #不包含
                        isFind="1" #不是空文件
                        cat $j >>applist.json #json写入文件
                        echo ",">> applist.json #用逗号分隔
                    fi
                fi
            done
            
            if [ $isFind -eq "1" ];then #判断找到的文件是否是全空的
                sed -i '$d' applist.json #删除最后一行的逗号
            fi
            echo "]">> applist.json #写入右半部分
            echo "商店信息写入完毕"
        fi
        cd ..
    fi
done

