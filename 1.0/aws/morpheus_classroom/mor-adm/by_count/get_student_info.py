import json
import os

state = morpheus['state']['stateList'][0]['statePath']
instance = json.loads(morpheus['instance'])

class lab(object):
    def __init__(self,hostname,pubilc_ip,access_key,secret_key):
        self.hostname = hostname
        self.public_ip = pubilc_ip
        self.access_key = access_key
        self.secret_key = secret_key
        
with open(state) as file:
    data = json.load(file)
    
resources = data['resources']
print(resources)

for i in instance:
    print(i['externalIp'])
    print(i['hostname'])
    externalIp = str(i['externalIp'])
    name = str(i['hostname'])
    labInstance = lab(pubilc_ip=externalIp,hostname=name,access_key="",secret_key="")

    print(labInstance['hostname'])
    print(labInstance['externalIp'])
    for resource in resources:
        print(json.dumps(resource))      
        if resource['type'] == "aws_iam_access_key":
            access = resource['instances']
            for r in access:
                if hostname == r['attributes']['user']:
                    labInstance.access_key = r['attributes']['id']   
                    labInstance.secret_key = r['attributes']['secret']
        
    # print("----------------------------------------------")
    # print("Hostname: " + labInstance.hostname)
    # print("Instance Public IP: " + labInstance.public_ip)
    # print("Student Access Key: " + labInstance.access_key)
    # print("Student Secret Key: " + labInstance.secret_key)
    # print("")