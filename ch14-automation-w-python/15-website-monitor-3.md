# Website Monitoring 3: Restart Application and Reboot Server

As a next step, we want to restart the application Docker container using Python
when the application is returning a non-`200` status code.

## Install Package Dependencies

**Paramiko for SSH**:

- `pip install paramiko`

**Linode API 4**:

- `pip install linode_api4`

## Create Python Script

`monitor-website.py`

```python
import requests
import smtplib
import os
import paramiko
import time

EMAIL_ADDR = os.environ.get('SMTP_ADDR')
EMAIL_PASS = os.environ.get('SMTP_PASS')
LINODE_TOKEN = os.environ.get('LINODE_TOKEN')

def send_notification(msg):
    with smtplib.SMTP('smtp.gmail.com', 587) as smtp:
        smtp.starttls()
        smtp.login(EMAIL_ADDR, EMAIL_PASS)
        smtp.sendmail(EMAIL_ADDR, EMAIL_ADDR, msg)

def restart_container():
    print('Restarting the application...')
    # restart the Docker container
    # connect to app server via SSH
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramikoAutoAddPolicy()) # auto-confirm host keyto avoid interactive message pause
    ssh.connect(hostname='000.000.000.000',port=22, username='root',key_filename='path/to/private-key')
    stdin, stdout, stderr = ssh.exec_comman('docker start {container-id}')
    # read contents of stdout
    print(stdout.readLines())
    # close ssh connection
    ssh.close()


def restart_server_and_container():
    # restart linode sever
    print('Rebooting the server...')
    linode_api4.LinodeClient(LINODE_TOKEN) # requires Linode API Token; create a Personal Access Token in Linode if necessary
    nginx_server = client.load(linode_api4.Instance, {linode-instance-id-here})
    nginx_server.reboot()

    # wait until server is in 'running' state, then restart application in Docker container
    while True:
        # get status of linode server
        nginx_server = client.load(linode_api4.Instance, {linode-instance-id-here})
        if nginx_server.status == 'running':
            time.sleep(5) # arbitrary wait to ensure server is ready
            restart_container()
            break

try:
    response = requests.get('http://{server-ip}:8080')

    print(response)
    if response.status_code == 200:
        print('Application is running successfully')
    else:
        print('Application down. Fix it')
        # send email to me
        send_notification("Subject: SITE DOWN\n Fix the issue")

        restart_container()

except Exception as ex:
    print(f"Connection error happened: {ex}")
    send_notification("Subject: SITE DOWN\n Application not accessible")
    restart_server_and_container()

```

### Running the Program Regularly

We want this program to run **automatically** and check the status of the
appplication periodically:

`monitor-website.py`

```python
import requests
import smtplib
import os
import paramiko
import time
import schedule

EMAIL_ADDR = os.environ.get('SMTP_ADDR')
EMAIL_PASS = os.environ.get('SMTP_PASS')
LINODE_TOKEN = os.environ.get('LINODE_TOKEN')

# ...

def monitor_application():
    try:
        response = requests.get('http://{server-ip} :8080')

        print(response)
        if response.status_code == 200:
            print('Application is running   successfully')
        else:
            print('Application down. Fix it')
            # send email to me
            send_notification("Subject: SITE DOWN\n     Fix the issue")

            restart_container()

    except Exception as ex:
        print(f"Connection error happened: {ex}")
        send_notification("Subject: SITE DOWN\n     Application not accessible")
        restart_server_and_container()

schedule.every(5).minutes.do(monitor_application)

while True:
    schedule.run_pending()
```
