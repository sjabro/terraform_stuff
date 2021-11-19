import json

specString = "<%=spec.encodeAsJson().toString()%>"

print(specString)


# config = json.loads(specString)

# config['instance']['name'] = "newName"
# config['instance']['hostname'] = "newHostName"

# spec = json.dumps(config, indent=4)
# print(spec)