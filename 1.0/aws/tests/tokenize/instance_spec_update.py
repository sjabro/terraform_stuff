import json

config = morpheus['spec']    

config['instance']['evars']['unmaskdpw'] = morpheus['customOptions']['unmaskedinput']

configJson = json.dumps(config)
spec = '{ "spec" : %s }' % (configJson)

print(spec)