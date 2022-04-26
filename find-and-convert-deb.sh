#/bin/bash

#########################帮助文件#################################
help() {
    cat <<EOF
用法：$0 [-h|--help] [--find] 路径
-h|--help     显示这个帮助
-f|--find   用find指令，循环寻找子目录

如果没有设置参数，将只寻找指定路径一层的文件

EOF
}
parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
        -h|--help)
            help
            exit
            ;;
	 -f|--find)
		isfind="1"
		shift
		;;
        *)
             path="$1"
		break
		#没有参数就读完退出
            ;;
    esac
    shift
    done
}

parse_args "$@"

if [ "$path" = "" ];then
path="."
fi


if [ "$isfind" = "1" ];then
files=(`find "$path" -name '*.deb'`)
else
files=(`find "$path" -name '*.deb' -maxdepth "1" `)
fi

until [ "${#files[@]}" = "0" ];do
filepath=${files[0]}
filedir=`echo $filepath | xargs -I {} dirname {}`
files=(${files[@]:1})


./repack-zstd $filepath $filedir
done