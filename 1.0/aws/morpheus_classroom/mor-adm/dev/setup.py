import json
import requests
import time
from morpheuscypher import Cypher
import os
import sys
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

key=str(morpheus['results']['getMorphLicense'])
instance = morpheus['instance']['containers']
firstname = str("admin")
emailid = str("sjabro@morpheusdata.com")

print(key)
print(instance)
class morphAppliance(object):
    def __init__(self, app_name, app_ip, account_name, user_name, password, email, first_name, access_token, license_key):
        # super(morphAppliance, self).__init__(*args))
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
        
for c in instance:
    student_email = str(c['server']['name'].split('-')[0])
    ip = str(c['externalIp'])
    
    appliance = morphAppliance(app_name="Morpheus", app_ip=ip, account_name="Morpheus", user_name="admin", password="69F49!632b13e", email=student_email, first_name="admin", license_key=key)
    
    print(appliance.account_name)
    print(appliance.app_name)
    print(appliance.app_ip)
    print(appliance.account_name)
    print(appliance.email)
    print(appliance.user_name)    


# # Define functions
# def setup():
#     body={ "applianceName": "myenterprise-morpheus", "applianceUrl": url, "accountName": "Morpheus", "username": "admin", "password": "69F49!632b13e", "email": emailid, "firstName": firstname }
#     b = json.dumps(body)
#     response = requests.post(morpheusurl, headers=headers, data=b, verify=False)
#     data = response.json()
#     print(data)
    
# # Begin loop over all containers in the instance
# for c in instance:
#     # Set variables
#     student_email = str(c['server']['name'].split('-')[0])
#     ip = str(c['externalIp'])
#     url=str("https://%s" % (ip))
#     morpheusurl=str("https://%s/api/setup/init" % (ip))
#     licenseurl=str("https://%s/api/license" % (ip))
#     pingurl=str("https://%s/ping" % (ip))
    
#     # Check for Morpheus PING 
#     pingcheck = requests.request("GET", pingurl, headers=headers, verify=False )
#     pingcheck_count = 1
#     while True:
#         if (pingcheck.text != 'MORPHEUS PING'):
#             print("Appliance not yet available. Sleeping for 5 minutes")
#             time.sleep(600)
#             pingcheck = requests.request("GET", pingurl, headers=headers, verify=False )
#             pingcheck_count + 1
#             if (pingcheck_count >= 6):
#                 print("Appliance not available after 30 minutes. Exiting script. Please check appliance availability at IP %s" %(ip))
#                 exit()
    
#     # Run setup        
#     setup()
    
#     print("This Lab https://%s is for %s with email: %s. Login with username: admin and password: 69F49!632b13e") % (ip, firstname,emailid)

#     tokenurl=str("https://%s/oauth/token?grant_type=password&scope=write&client_id=morph-api"%(ip))
#     tokenheader={'Content-Type': 'application/x-www-form-urlencoded'}
    
#     #Get token of the appliance
#     def token():
#         body = {'username': 'admin', 'password': '69F49!632b13e'}
#         response = requests.post(tokenurl, headers=tokenheader, data=body, verify=False)
#         data = response.json()
#         access_token = data['access_token']
#         return access_token


#     print("Get access token........")
#     access_token=token()
#     #print(access_token)


#     print("Get license key......")
#     #print(key)

#     #Add license to the appliance
#     license_headers={'Content-Type': 'application/json',"Authorization": "BEARER " + (access_token)}
#     license_headers={"Authorization": "BEARER " + (access_token)}

#     def license():
#         body={"license": key}
#         b = json.dumps(body)
#         response = requests.post(licenseurl, headers=license_headers, data=b, verify=False)
#         data = response.json()
#         #print(data)

#     print("Applying license key to appliance %s using token: %s and key %s") %(ip,access_token,key)
#     license()
    
    
    
    
    
            