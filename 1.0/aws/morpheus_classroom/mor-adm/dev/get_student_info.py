import json
import os

state = morpheus['state']['stateList'][0]['statePath']
student_list = morpheus['customOptions']['studentEmails']

print(path)
# path = "C:\\Repos\\terraform_stuff\\1.0\\For_B"
# student_list = "student1@no.mail,student2@no.mail,student3@no.mail,student4@no.mail,student5@no.mail,student6@no.mail,student7@no.mail,student8@no.mail,student9@no.mail,student10@no.mail,trainer1@no.mail"

splitList = student_list.split(',')

class student(object):
    def __init__(self,student_email,student_instance,pubilc_ip,access_key,secret_key):
        self.student_email = student_email
        self.student_instance = student_instance
        self.public_ip = pubilc_ip
        self.access_key = access_key
        self.secret_key = secret_key
        
with open(state) as file:
    data = json.load(file)
    
resources = data['resources']

for person in splitList:
    user = student(student_email="",student_instance="",pubilc_ip="",access_key="",secret_key="")

    for resource in resources:       
        if resource['type'] == "aws_iam_access_key":
            access = resource['instances']
            for r in access:
                if person == r['attributes']['user']:
                    user.access_key = r['attributes']['id']   
                    user.secret_key = r['attributes']['secret']
                    user.student_email = r['attributes']['user']
                
    for resource in resources:
        if resource['type'] == "aws_instance":
            instances = resource['instances']
            for r in instances:
                if person == r['attributes']['tags']['Name'].split('_')[0]:
                    user.student_instance = r['attributes']['tags']['Name']
                    user.public_ip = r['attributes']['public_ip']
        
    print("----------------------------------------------")
    print("Student Email: " + user.student_email)
    print("Student Instance Name: " + user.student_instance)
    print("Instance Public IP: " + user.public_ip)
    print("Student Access Key: " + user.access_key)
    print("Student Secret Key: " + user.secret_key)
    print("")