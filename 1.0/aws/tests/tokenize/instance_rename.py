import json

specString = "<%=spec.encodeAsJson().toString()%>"
configJson = json.loads(specString)

# print(configJson['instance']['name'])
# print(configJson['instance']['hostname'])

configJson['instance']['name'] = "newName"
configJson['instance']['name'] = "newHostName"

print(configJson)