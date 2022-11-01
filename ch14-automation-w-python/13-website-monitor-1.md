# Website Monitoring 1: Schedule Task to Monitor Application Health

In this exercise, we will create Python scripts to monitor the health of a
simple website.

## Preparation Steps

1. Create a server on LKE (or your desired cloud provider)

2. Install Docker on server

3. Run `nginx` container

## Write Automation Program

1. Write Python program that checks application by making an HTTP request to the
   app

2. Program will send email if response indicates website is down

3. Automate fixing the problem:
   - Re-start Docker container
   - Re-start server if unavailable, _then_ re-start Docker container

## Create LKE Server and Run `nginx` container

1. Create a server on LKE (or your favorite cloud provider) as we've done
   previously. Create/Add SSH key (if necessary), configure firewalls etc.

2. Install Docker on your server instance/for your OS distro. See the Docker
   installation documentation for your OS.

3. Start `nginx` container:

   - `docker run -d -p 8080:80 nginx`

4. Access your server in browser using IP address and port `8080`.

## Write Automation Script

1. Install `requests` package in your Python project:

- `pip install requests`

2. Create file:

`monitor-website.py`

```python
import requests

# try to send request to website from python
response = requests.get('http://{server-ip}:8080')

print(response) # <Response [200]>
# print(response.text)
# print(response.status_code) # 200
if response.status_code == 200:
    print('Application is running successfully')
else:
    print('Application down. Fix it')
```
