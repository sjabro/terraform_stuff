import json

specString = morpheus['spec']

print(specString)
print(specString['hostName'])
print(specString['instance'])

# config = json.loads(specString)

# config['instance']['name'] = "newName"
# config['instance']['hostname'] = "newHostName"

# spec = json.dumps(config, indent=4)
# print(spec)