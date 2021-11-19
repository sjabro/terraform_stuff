import json

config = morpheus['spec']

print(config)
print(config['instance']['name'])
print(config['instance']['hostName'])

config['instance']['name'] = "newName"
config['instance']['hostname'] = "newHostName"

spec = json.dumps(config, indent=4)

print(spec)