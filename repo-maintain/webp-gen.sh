# 递归查找指定目录及其子目录下的所有png文件
REPOPATH=$1

# 查找所有png文件
find "$REPOPATH" -type f -name "*.png" | while read png_file; do
  # 获取png文件所在目录
  png_dir=$(dirname "$png_file")
  # 获取png文件名（不包含扩展名）
  png_name=$(basename "$png_file" .png)
  # 检查是否存在同名webp文件
  if [ ! -f "$png_dir/$png_name.webp" ]; then
    # 若不存在，则生成webp文件
    cwebp -quiet "$png_file" -o "$png_dir/$png_name.webp"
  else
    # 若存在，则比较创建时间
    png_mtime=$(stat -c %Y "$png_file")
    webp_mtime=$(stat -c %Y "$png_dir/$png_name.webp")
    if [ "$png_mtime" -gt "$webp_mtime" ]; then
      # 若png文件更新，则生成webp文件覆盖
      cwebp -quiet "$png_file" -o "$png_dir/$png_name.webp"
    fi
  fi
done

# 查找所有webp文件
find "$REPOPATH" -type f -name "*.webp" | while read webp_file; do
  # 获取webp文件所在目录
  webp_dir=$(dirname "$webp_file")
  # 获取webp文件名（不包含扩展名）
  webp_name=$(basename "$webp_file" .webp)
  # 检查是否存在同名png文件
  if [ ! -f "$webp_dir/$webp_name.png" ]; then
    # 若不存在，则删除此webp文件
    rm "$webp_file"
  fi
done
