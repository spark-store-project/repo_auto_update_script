# 递归查找指定目录及其子目录下的所有png文件
REPOPATH=$1
find $REPOPATH -type f -name "*.png" | while read PNG_FILE; do
  # 获取png文件所在目录
  PNG_DIR=$(dirname "$PNG_FILE")
  # 获取png文件名（不含扩展名）
  PNG_NAME=$(basename "$PNG_FILE" .png)
  # 构造对应webp文件的路径
  WEBP_FILE="$PNG_DIR/$PNG_NAME.webp"
  
  # 检查webp文件是否存在
  if [ -e "$WEBP_FILE" ]; then
    # 检查png文件是否比webp文件更新
    if [ "$PNG_FILE" -nt "$WEBP_FILE" ]; then
      # 将png文件转换为webp并覆盖现有的webp文件
      cwebp -quiet "$PNG_FILE" -o "$WEBP_FILE"
    fi
  else
    # 如果没有对应的png文件，则删除webp文件
    rm "$WEBP_FILE" 2>/dev/null
  fi
done
