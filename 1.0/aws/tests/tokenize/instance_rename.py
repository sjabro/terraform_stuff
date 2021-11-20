import json

config = morpheus['spec']    

### Your logic here ###

newName = "newName"

### ^^^^^^^^^^^^^^^ ###

config['instance']['name'] = newName
config['instance']['hostname'] = newName

configJson = json.dumps(config)
spec = '{ "spec" : %s }' % (configJson)

print(spec)