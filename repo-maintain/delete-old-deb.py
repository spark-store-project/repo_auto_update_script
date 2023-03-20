#!/usr/bin/env python3

import os
import subprocess
import sys

# 定义要搜索deb包的目录
DEB_DIR=sys.argv[1]
print(DEB_DIR)
# 定义一个字典来存储包名和版本号
packages = {}

# 循环遍历目录中的所有deb包
for root, dirs, files in os.walk(DEB_DIR):
    for file in files:
        if file.endswith(".deb"):
            deb_package = os.path.join(root, file)
            # 获取包名和版本号
            package_name = subprocess.check_output(["dpkg-deb", "-f", deb_package, "Package"]).decode().strip()
            package_version = subprocess.check_output(["dpkg-deb", "-f", deb_package, "Version"]).decode().strip()
            # 检查包名是否已经存在于列表中
            if package_name in packages:
                # 如果包版本更高，则更新版本号
                if subprocess.call(["dpkg", "--compare-versions", package_version, "gt", packages[package_name]]) == 0:
                    packages[package_name] = package_version
            else:
                # 如果包名不存在，则将其添加到列表中
                packages[package_name] = package_version

# 循环遍历包列表并删除任何旧版本
for package_name in packages:
    for root, dirs, files in os.walk(DEB_DIR):
        for file in files:
            if file.endswith(".deb"):
                if file.startswith(package_name) and file[len(package_name)] == "_" and file.endswith(".deb"):
                    deb_package = os.path.join(root, file)
                    package_version = subprocess.check_output(["dpkg-deb", "-f", deb_package, "Version"]).decode().strip()
                    if package_version != packages[package_name]:
                        print(f"{package_name} {package_version} {deb_package} 已删除")
                        os.remove(deb_package)
