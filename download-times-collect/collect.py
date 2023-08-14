import os
import sys
import logging
from flask import Flask, request

app = Flask(__name__)

@app.route('/handle_post', methods=['POST'])

def handle_post():
    data = request.get_json()
    path = data.get('path')
    
    if path:
        process_http_post(path)
        return 'OK', 200
    else:
        return 'Invalid request', 400

def process_http_post(path):
    download_times_path = os.path.join(REPOPATH, path, "download-times.txt")

    if not os.path.exists(download_times_path):
        spark_store_path = os.path.join(REPOPATH, path)
        if not os.path.exists(spark_store_path):
            app.logger.error(f"{path} 文件夹不存在")
            return
        
        with open(download_times_path, "w") as file:
            file.write("0")

    with open(download_times_path, "r+") as file:
        download_times = int(file.read()) + 1
        file.seek(0)
        file.write(str(download_times))
        file.truncate()
    
    app.logger.info(f"{path}/download-times.txt 当前下载次数：{download_times}")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python script.py REPOPATH")
        sys.exit(1)
    
    REPOPATH = sys.argv[1]
    app.logger.setLevel(logging.INFO)
    app.run(host='0.0.0.0',port=38324)
