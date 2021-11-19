import json

config = morpheus['spec']    

config['instance']['name'] = "newName"
config['instance']['hostname'] = "newHostName"

spec = "{ 'spec' : %s }" % (config)
output = json.dumps(spec, indent=4)
print(spec)