import json
import os

state = morpheus['state']['stateList'][0]['statePath']

class student(object):
    def __init__(self,pubilc_ip,access_key,secret_key):
        self.public_ip = pubilc_ip
        self.access_key = access_key
        self.secret_key = secret_key
        
with open(state) as file:
    data = json.load(file)
    
resources = data['resources']

for person in splitList:
    user = student(student_email="",pubilc_ip="",access_key="",secret_key="")

    for resource in resources:       
        if resource['type'] == "aws_iam_access_key":
            access = resource['instances']
            for r in access:
                if person == r['attributes']['user']:
                    user.access_key = r['attributes']['id']   
                    user.secret_key = r['attributes']['secret']
                    user.student_email = r['attributes']['user']
                
    for resource in resources:
        if resource['type'] == "aws_eip":
            instances = resource['instances']
            for r in instances:
                if person == r['attributes']['tags']['Name']:
                    user.public_ip = r['attributes']['public_ip']
        
    print("----------------------------------------------")
    print("Student Email: " + user.student_email)
    print("Instance Public IP: " + user.public_ip)
    print("Student Access Key: " + user.access_key)
    print("Student Secret Key: " + user.secret_key)
    print("")