import json
from logging import exception
import requests
import time
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

key=str(morpheus['results']['getMorphLicense'])
instance = morpheus['instance']['containers']
firstname = str("admin")
emailid = str("training@morpheusdata.com")
admin_password = str(morpheus['customOptions']['morphApplianceAdminPass'])

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
        setup_url = str("https://%s/api/setup/init" % (self.app_ip))
        headers={'Content-Type': 'application/json',"Accept":"application/json"}
        body={ "applianceName": self.app_name, "applianceUrl": url, "accountName": self.account_name, "username": self.user_name, "password": self.password, "email": self.email, "firstName": self.first_name }
        b = json.dumps(body)
        response = requests.post(setup_url, headers=headers, data=b, verify=False)
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
        reply = ""
        url = str("https://%s/ping" % (self.app_ip))
        headers={'Content-Type': 'application/json',"Accept":"application/json"}
        try:
            response = requests.get(url, headers=headers, verify=False)
            reply = response.text
        except:
            pass
        return reply
    
    def checkApplianceSetupStatus(self):
        url = str("https://%s/api/ping" % (self.app_ip))
        headers={'Content-Type': 'application/json',"Accept":"application/json"}
        response = requests.get(url, headers=headers, verify=False)
        data = response.json()
        return data["setupNeeded"]

### START SCRIPT ###
for c in instance:
    student_email = str(c['server']['name'].split('-')[0])
    ip = str(c['externalIp'])
    
    appliance = morphAppliance(app_name="Morpheus", app_ip=ip, account_name="Morpheus", user_name="admin", password=admin_password, email=emailid, first_name="admin", license_key=key, access_token="")
    
    
    ### Begin checking appliance status:
    print("Beginning ping check for appliance %s." % (ip))
    pingCheck = appliance.checkAppliancePing()
    pingCount = 1
    
    while pingCheck != "MORPHEUS PING":
        print("Attempt: %s" % (pingCount))
        print("Morpheus appliance %s is not currently reachable. Sleeping for 5 minutes..." % (ip))
        time.sleep(300)
        
        try:
            pingCheck = appliance.checkAppliancePing()
            pingCount = pingCount + 1
        except:
            pingCheck = str("Appliance ping not responding yet. Conintuing loop.")
            print(pingCheck)
        
        if pingCount >= 9:
            print("Appliance is not up after 45 minutes. Please check in on its status at %s" % (ip))
            break
        
    print("Morpheus ping responded.")
    
    ### Begin initial appliance setup
    
    print("Validating setup is needed")
    setupStatus = appliance.checkApplianceSetupStatus()
    print(setupStatus)
    
    # TODO Get the if statement working
    # if setupStatus in [ 'True', 'true' ]:
    print("Begin setup attempt...")
    setup = appliance.applianceSetup()

    ### Get access token
    
    print("Acquiring access token...")
    appliance.access_token = appliance.getApiToken()

    ### Apply License
    
    print("Applying license...")
    license = appliance.applyLicense()
        
    # else:
    #     print("The appliance has already been through the setup process. Moving on.")
    
### END SCRIPT ###