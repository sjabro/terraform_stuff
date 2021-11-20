import json

config = morpheus['spec']    

config['instance']['name'] = "newName"
config['instance']['hostname'] = "newHostName"

configJson = json.dumps(config)
spec = '{ "spec" : %s }' % (configJson)

print(spec)