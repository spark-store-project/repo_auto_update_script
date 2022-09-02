#/bin/bash
REPOPATH="/home/ftp/spark-store" #设置软件源目录
cd $REPOPATH #进入根目录

cd store

echo "--------排查download-times.txt是否存在阶段开始"
for i in `ls` #for循环遍历store目录下的文件
do
   if [ -d $i ] ; then #如果当前变量的是目录
		if [ "$i" = "depends" ] || [ "$i" = "ossutil_output" ] ;then	# 判断是否是不参与排名的
			echo "$i 目录不参与下载量排名，被排除在外"
			continue
		fi
		
        cd $i #进入目录
		for j in `ls` #for循环遍历目录下的文件
		do
		if [ -d $j ] ; then #如果当前变量的是目录
			cd $j #进入目录
			if [ ! -f 'app.json' ];then 
			echo "警告：`pwd`处的应用无app.json！跳过..."
			continue
			fi

			
        		if [ ! -f 'download-times.txt' ];then #如果不存在下载量文件，则退出
            		echo  0 > download-times.txt
            		echo "`pwd` 处无download-times.txt文件，已创建"
			fi
			cd ..
		fi
		done
        cd ..
		
   fi

done

 echo "--------排查download-times.txt是否存在阶段结束"
echo "--------开始生成排名"

for i in `ls` #for循环遍历store目录下的文件
do
    if [ -d $i ] ; then #如果当前变量的是目录
	         if [ "$i" = "depends" ] || [ "$i" = "ossutil_output" ] ;then    # 判断是否是不参与排名的
                         echo "$i 目录不参与下载量排名，被排除在外"
                         continue
                 fi

        cd $i #进入目录


rm -f ./temp-list.txt

lines=`find . -name download-times.txt | wc -l  `
echo "所在分类为 `pwd | xargs basename` ，此分类下的总应用数为：$lines"
file_list=`find . -name download-times.txt`
i=1

until [ $i -gt $lines ];do
file_path=`echo "${file_list}" | sed -n '1p'`
file_list=`echo "${file_list}" | sed '1d'` 
echo "$file_path#`cat $file_path`" >> ./temp-list.txt

let i=$i+1

done

sort -n -r -k 2 -t '#' ./temp-list.txt -o ./temp-list.txt
sed -i "{s/#.*//}" ./temp-list.txt



lines=`cat ./temp-list.txt | wc -l  `
i=1

echo "[" > applist.json 
until [ $i -gt $lines ];do
file_path=`cat "./temp-list.txt" | sed -n '1p'`
sed -i '1d' ./temp-list.txt
file_path=$(echo ${file_path%/*})
file_path=$(echo "$file_path"/app.json"")

cat $file_path  >> applist.json 
echo >> applist.json  
echo ",">> applist.json  #用逗号分隔

let i=$i+1

done

rm -f ./temp-list.txt
sed -i '$d' applist.json #删除最后一行的逗号
echo "]">> applist.json #写入右半部分



cd ..

fi
done

echo "按下载量顺序生成applist.json过程结束"
