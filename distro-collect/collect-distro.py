#!/bin/python3

import json
from flask import Flask, request
import csv

app = Flask(__name__)

@app.route('/', methods=['POST'])
def receive_info():
    try:
        # 获取POST请求中的JSON数据
        data = request.get_json()

        # 提取Distributor ID和Release信息
        distributor_id = data.get('Distributor ID', '')
        release = data.get('Release', '')
        architecture = data.get('Architecture', '')

        # 将信息追加到/root/result.csv文件中
        with open('/root/result.csv', mode='a', newline='') as csv_file:
            fieldnames = ['Distributor ID', 'Release', 'Architecture']
            writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

            # 如果文件不存在，写入表头
            if csv_file.tell() == 0:
                writer.writeheader()

            writer.writerow({'Distributor ID': distributor_id, 'Release': release, 'Architecture': architecture})

        return 'Data received and written to /root/result.csv successfully', 200
    except Exception as e:
        return f'Error: {str(e)}', 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=12345)
