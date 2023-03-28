import smtplib
from email.message import EmailMessage

import time


sent = False
while not sent:




    # set your email and password
    # please use App Password
    email_address = "mail.manager.rit@gmail.com"
    email_password = "gsnflhangzqckikh"

    # create email
    msg = EmailMessage()
    msg['Subject'] = "Email subject"
    msg['From'] = email_address
    msg['To'] = "hooong.yang@gmail.com"
    msg.set_content("This is eamil message")

    # send email
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
        smtp.login(email_address, email_password)
        smtp.send_message(msg)

