import json
import requests
### import time
### from morpheuscypher import Cypher
### import os
### import sys
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

key=str(morpheus['results']['getMorphLicense'])
instance = morpheus['instance']['containers']
firstname = str("admin")
emailid = str("sjabro@morpheusdata.com")

class morphAppliance(object):
    def __init__(self, app_name, app_ip, account_name, user_name, password, email, first_name, access_token, license_key):
        self.app_name = app_name
        self.app_ip = app_ip
        self.account_name = account_name
        self.user_name = user_name
        self.password = password
        self.email = email
        self.first_name = first_name
        self.access_token = access_token
        self.licence_key = license_key
    
    def applianceSetup(self):
        url = str("https://%s" % (self.app_ip))
        headers={'Content-Type': 'application/json',"Accept":"application/json"}
        body={ "applianceName": self.app_name, "applianceUrl": url, "accountName": self.account_name, "username": self.user_name, "password": self.password, "email": self.email, "firstName": self.first_name }
        b = json.dumps(body)
        response = requests.post(self.app_url, headers=headers, data=b, verify=False)
        data = response.json()
        print(data)   
    
    def getApiToken(self):
        url = str("https://%s/oauth/token?grant_type=password&scope=write&client_id=morph-api" % (self.app_ip))
        headers = {'Content-Type': 'application/x-www-form-urlencoded'}
        body = {"username": self.user_name, "password": self.password}
        response = requests.post(url, headers=headers, data=body, verify=False)
        data = response.json()
        return data['access_token']
        
    def applyLicense(self):
        url = str("https://%s/api/license" % (self.app_ip))
        headers={'Content-Type': 'application/json',"Authorization": "BEARER " + (self.access_token)}
        body = {"license": self.licence_key}
        b = json.dumps(body)
        response = requests.post(url, headers=headers, data=b, verify=False)
        data = response.json()
        
    def checkAppliancePing(self):
        url = str("https://%s/ping" % (self.app_ip))
        headers={'Content-Type': 'application/json',"Accept":"application/json"}
        response = requests.get(url, headers=headers, verify=False)
        return response.text
        
for c in instance:
    student_email = str(c['server']['name'].split('-')[0])
    ip = str(c['externalIp'])
    
    print(student_email)
    print(ip)
    
    appliance = morphAppliance(app_name="Morpheus", app_ip=ip, account_name="Morpheus", user_name="admin", password="69F49!632b13e", email=student_email, first_name="admin", license_key=key, access_token="")
    
    pingCheck = appliance.checkAppliancePing()
    print(pingCheck)