import json

config = morpheus['spec']    

### Your logic here ###

namePattern = "overwrite-global-${sequence.toString().padLeft(2, '0')}"

### ^^^^^^^^^^^^^^^ ###

config['instance']['name'] = namePattern
config['instance']['hostname'] = namePattern
config['instance']['policyArray'][0]['config']['namingPattern'] = namePattern

configJson = json.dumps(config)
spec = '{ "spec" : %s }' % (configJson)

print(spec)