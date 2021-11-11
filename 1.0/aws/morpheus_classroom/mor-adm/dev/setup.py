import json
import requests
import time
from morpheuscypher import Cypher
import os
import sys
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

headers={'Content-Type': 'application/json',"Accept":"application/json"}
key=str(morpheus['results']['getKey'])
instance = morpheus['instance']['containers']
firstname = str("admin")
emailid = str("sjabro@morpheusdata.com")

# Begin loop over all containers in the instance
for c in instance:
    # Set variables
    student_email = str(c['server']['name'].split('-')[0])
    ip = str(c['externalIp'])
    url=str("https://%s" % (ip))
    morpheusurl=str("https://%s/api/setup/init" % (ip))
    licenseurl=str("https://%s/api/license" % (ip))
    pingurl=str("https://%s/ping" % (ip))
    
    # Define functions
    def setup():
        body={ "applianceName": "myenterprise-morpheus", "applianceUrl": url, "accountName": "Morpheus", "username": "admin", "password": "69F49!632b13e", "email": emailid, "firstName": firstname }
        b = json.dumps(body)
        response = requests.post(morpheusurl, headers=headers, data=b, verify=False)
        data = response.json()
        print(data)
    
    # Check for Morpheus PING 
    pingcheck = requests.request("GET", pingurl, headers=headers, verify=False )
    pingcheck_count = 1
    while True:
        if (pingcheck.text != 'MORPHEUS PING'):
            print("Appliance not yet available. Sleeping for 5 minutes")
            time.sleep(600)
            pingcheck = requests.request("GET", pingurl, headers=headers, verify=False )
            pingcheck_count + 1
            if (pingcheck_count >= 6):
                print("Appliance not available after 30 minutes. Exiting script. Please check appliance availability at IP %s" %(ip))
                exit()
    
    # Run setup        
    setup()
    
    print("This Lab https://%s is for %s with email: %s. Login with username: admin and password: 69F49!632b13e") % (ip, firstname,emailid)

    tokenurl=str("https://%s/oauth/token?grant_type=password&scope=write&client_id=morph-api"%(ip))
    tokenheader={'Content-Type': 'application/x-www-form-urlencoded'}
    #Get token of the appliance
    def token():
        body = {'username': 'admin', 'password': '69F49!632b13e'}
        response = requests.post(tokenurl, headers=tokenheader, data=body, verify=False)
        data = response.json()
        access_token = data['access_token']
        return access_token


    print("Get access token........")
    access_token=token()
    #print(access_token)


    print("Get license key......")
    #print(key)

    #Add license to the appliance
    license_headers={'Content-Type': 'application/json',"Authorization": "BEARER " + (access_token)}
    license_headers={"Authorization": "BEARER " + (access_token)}

    def license():
        body={"license": key}
        b = json.dumps(body)
        response = requests.post(licenseurl, headers=license_headers, data=b, verify=False)
        data = response.json()
        #print(data)

    print("Applying license key to appliance %s using token: %s and key %s") %(ip,access_token,key)
    license()
    
    
    
    
    
            