#/bin/bash
DEPEND=`dpkg -l | grep  dos2unix`
if [ "$DEPEND" = "" ] ; then 
echo "未安装依赖：dos2unix 本脚本退出"
exit 0
fi


REPOPATH="/home/ftp/spark-store/" #设置软件源目录
if [  "`curl pop3s://pop.sina.com/ --user example@example.com:114514 -s | grep 1`" = "" ];then
echo "无邮件需要处理，完成"
exit
fi


DOWNLOAD_NUMBERS=`curl pop3s://pop.sina.com/ --user example@example.com:114514 -s | wc -l`
echo "有$DOWNLOAD_NUMBERS封邮件等待处理！"

i=1
until [ "$i" -gt "$DOWNLOAD_NUMBERS" ];do

curl pop3s://pop.sina.com/1 --user example@example.com:114514 -s > ./tmp.log
dos2unix ./tmp.log
if [ "`cat ./tmp.log | grep check="这里可以放自己喜欢的内容" `" = "" ];then
curl --request DELE pop3s://pop.sina.com/1 --user example@example.com:114514 --list-only
echo "邮件无验证信息，可能为垃圾邮件，丢弃"

    else
        echo "开始检验指令"
            COMMAND="`sed -n '/command:/p' ./tmp.log`"
            case "$COMMAND" in
                command:download_count)
                    APP_LOCATION="`cat ./tmp.log | grep APP_LOCATION=`"
                    APP_LOCATION="`echo ${APP_LOCATION} | sed {s/APP_LOCATION=//}`"
                    ALREADY_DOWNLOADED_NUM=`cat $REPOPATH/$APP_LOCATION/download-times.txt`
                    let ALREADY_DOWNLOADED_NUM=$ALREADY_DOWNLOADED_NUM+1
                    echo ${ALREADY_DOWNLOADED_NUM} > $REPOPATH/$APP_LOCATION/download-times.txt

                ;;
                *)
                echo "未定义的行为，抛弃"
                ;;
                
            esac
            curl --request DELE pop3s://pop.sina.com/1 --user example@example.com:114514 --list-only
rm ./tmp.log

fi



let i=$i+1
done


if [ "`curl pop3s://pop.sina.com/ --user example@example.com:114514 -s | grep 1`" != "" ];then
$0
echo "处理结束，退出"
exit
fi