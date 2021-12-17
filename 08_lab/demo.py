from pprint import pprint
from requests.structures import CaseInsensitiveDict
import openid_connect
import requests

target_url = "https://g749hn3u5k.execute-api.eu-central-1.amazonaws.com/prod"
redirect_uri = "http://localhost:8080"

c = openid_connect.connect(
    server="https://gitlab.lrz.de",
    client_id=open("appid.txt").read().strip(),
    client_secret=open("appsecret.txt").read().strip()
)

print(c.authorize(redirect_uri=redirect_uri))

code = input("Enter Code from redirect URL: ")

x = c.request_token(
    redirect_uri=redirect_uri,
    code=code
)

headers = CaseInsensitiveDict()
headers["Accept"] = "application/json"
headers["Content-Type"] = "application/json"
headers["Authorization"] = x.id_token

resp = requests.post(
    url=target_url,
    headers=headers,
    json={
        "blob": "RmFuY3kgQ29udGVudCE=",
        "email": "michael.fuchs@hm.edu"
    }
)

print("status of response: " + str(resp.status_code))
print("message of response: " + resp.text)
