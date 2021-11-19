import json

specString = morpheus['spec']

print(specString)
print(specString['instance']['name'])
print(specString['instance']['hostName'])

config = json.loads(specString)

# config['instance']['name'] = "newName"
# config['instance']['hostname'] = "newHostName"

# spec = json.dumps(config, indent=4)
# print(spec)