#/usr/bin/env python3
import os
import poplib
import email
import re
import sys
# 获取邮件
def get_email():
    # 邮箱配置
    email_host = 'pop.163.com'
    email_user, email_password = sys.argv[1].split(':')

    # 连接邮箱
    server = poplib.POP3_SSL(email_host)
    server.user(email_user)
    server.pass_(email_password)

    # 获取邮件数量
    email_count = len(server.list()[1])
    if email_count == 0:
        print('无邮件需要处理，完成')
        exit(0)
    else:
        print(f'有{email_count}封邮件等待处理！')

    # 处理邮件
    i = 1
    while i <= email_count:
        # 获取邮件内容
        email_content = server.retr(i)[1]
        email_content = [line.decode() for line in email_content]
        email_content = email.message_from_string('\n'.join(email_content))

        # 获取邮件正文
        email_body = email_content.get_payload(decode=True).decode()
        email_body = email_body.replace('\r\n', '\n')

        # 检查邮件内容
        if 'check=i love amber forever' not in email_body:
            server.dele(i)
            print('邮件无验证信息，可能为垃圾邮件，丢弃')
        else:
            print('开始检验指令')
            command = re.search(r'command:(.*)', email_body).group(1)
            app_location = re.search(r'APP_LOCATION=(.*)', email_body).group(1)

            # 执行指令
            if command == 'download_count':
                download_times_file = os.path.join('/home/ftp/spark-store', app_location, 'download-times.txt')
                with open(download_times_file, 'r') as f:
                    already_downloaded_num = int(f.read())
                already_downloaded_num += 1
                with open(download_times_file, 'w') as f:
                    f.write(str(already_downloaded_num))
                    print(f'{app_location} 现在的下载量为 {already_downloaded_num}')
            else:
                print('未定义的行为，抛弃')

            # 删除邮件
            server.dele(i)
            email_count -= 1
        i += 1

    # 关闭连接
    server.quit()

    # 继续处理邮件
    get_email()

if __name__ == '__main__':
    get_email()
