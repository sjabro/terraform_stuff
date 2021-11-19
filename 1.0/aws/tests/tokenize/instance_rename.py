import json

config = morpheus['spec']

print(config)

# print(config['instance']['name'])
# print(config['instance']['hostName'])

# class morphSpec(object):
#     def __init__(self, json):
#         self.json = json        

config['instance']['name'] = "newName"
config['instance']['hostname'] = "newHostName"

spec = "{ 'spec' : %s }" % (config)
output = json.dumps(spec, indent=4)
print(output)