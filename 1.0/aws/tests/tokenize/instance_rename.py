import json

specString = "<%=spec.encodeAsJson().toString()%>"
config = json.loads(specString)

# print(configJson['instance']['name'])
# print(configJson['instance']['hostname'])

config['instance']['name'] = "newName"
config['instance']['hostname'] = "newHostName"

spec = json.dumps(config, indent=4)
print(spec)