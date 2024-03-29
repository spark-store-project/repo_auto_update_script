import os
import json
import xml.dom.minidom


pacakges_file_path = '/home/ftp/spark-store/store/Packages'
torrent_file_path = '/home/ftp/spark-store/store/torrent.json'
cdn_file_path = '/home/ftp/spark-store/store/server-and-mirror.list'
output_base_dir = '/home/ftp/spark-store/store'

example_file_path = '/root/repo-scripts/repo_auto_update_script/spark-store-metalink/example.metalink'
http_xml_example = ' <url type="http" location="cn" preference="100">example_http</url> '
bt_xml_example = ' <url type="bittorrent" preference="100">example_bt</url> '
torrent_url = 'https://d.store.deepinos.org.cn/'

with open(example_file_path, 'r') as example_file:
    example_data = example_file.readline()

with open(cdn_file_path, 'r', encoding='utf-8') as cdn_file:
    cdn_urls = []
    cdn_file_data = cdn_file.readlines()

    for i in range(5, len(cdn_file_data)):
        if(len(cdn_file_data[i].replace('\n', ''))>0):
            cdn_urls.append(cdn_file_data[i].replace('\n', ''))


with open(torrent_file_path, 'r', encoding='utf-8') as torrent_file:
    torrent_data = json.load(torrent_file)
    for i in range(len(torrent_data)):
        torrent_data[i] = torrent_data[i].replace(
            'http://d.store.deepinos.org.cn/store/', '')

with open(pacakges_file_path, 'r', encoding='utf-8', errors='ignore') as pacakges_file:
    pacakges_file_data = pacakges_file.readlines()

for i in range(len(pacakges_file_data)):

    if pacakges_file_data[i].startswith('Filename: '):
        i_torrent_exits = False
        i_filename = pacakges_file_data[i].replace(
            'Filename: ', '').replace('\n', '')
        i_meta_filename = os.path.join(output_base_dir,i_filename + '.metalink')
        i_torrent = os.path.join(output_base_dir,i_filename + '.torrent')
        i_filesize = pacakges_file_data[i +
                                        1].replace('Size: ', '').replace('\n', '')
        i_md5 = pacakges_file_data[i +
                                   2].replace('MD5sum: ', '').replace('\n', '')
        i_sha1 = pacakges_file_data[i +
                                    3].replace('SHA1: ', '').replace('\n', '')
        i_dir = i_meta_filename[:i_meta_filename.rindex('/')]
        http_xml = ''
        for i_cdn in cdn_urls:
            http_xml += http_xml_example.replace(
                'example_http', 'https://'+i_cdn+'/store/' + i_filename)
        if i_torrent in torrent_data:
            bt_xml = bt_xml_example.replace(
                'example_bt', torrent_url+i_torrent)
            resource_data = http_xml + ' ' + bt_xml
        else:
            resource_data = http_xml

        xml_data = example_data.replace('example.ext', i_filename[i_filename.rindex('/')+1:]).replace(
            'example-md5-hash', i_md5).replace('example-sha1-hash', 
                i_sha1).replace('<example_resources>', resource_data.replace("+","%2B")) # 对+进行转译，避免oss出错

        xml_data = xml.dom.minidom.parseString(xml_data)
        xml_pretty_str = xml_data.toprettyxml()
        # print(xml_pretty_str)
        if not os.path.exists(i_dir):
            print('Dir have been deleted, so we pass it:' + str(i_dir))
        else:
            with open(i_meta_filename,'w', encoding='utf-8') as f:
                f.write(xml_pretty_str)
