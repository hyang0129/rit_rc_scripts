import smtplib
from email.message import EmailMessage

import time
import glob


sent = False
while not sent:

    time.sleep(10)

    files = glob.glob('*.err')

    with open(files[0], 'r') as errlog:

        lines = errlog.read()

        for line in lines:
            if 'rc.rit' in line:

                splits = line.split('/')

                for split in splits:
                    if 'rc.rit' in split:
                        break

                port = split.split(':')[-1]
                host = split.split('.')[0]


                base_command = f'ssh -i .ssh/rit_rc_key hy3134@sporcsubmit.rc.rit.edu -L {port}:{host}:{port}'


                url = line.split(' ')[-1].replace('{host}.rc.rit.edu', '127.0.0.1')


                # set your email and password
                # please use App Password
                email_address = "mail.manager.rit@gmail.com"
                email_password = "gsnflhangzqckikh"

                # create email
                msg = EmailMessage()
                msg['Subject'] = "Email subject"
                msg['From'] = email_address
                msg['To'] = "hooong.yang@gmail.com"
                msg.set_content(f"""
                {base_command}
                {url}              
                """)

                # send email
                with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
                    smtp.login(email_address, email_password)
                    smtp.send_message(msg)


                sent = True

                break
