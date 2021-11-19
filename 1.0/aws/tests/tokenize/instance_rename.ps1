$ProgressPreference = 'SilentlyContinue'

### VARIABLES

$available = $false
$configJson = '<%=spec.encodeAsJson().toString()%>'
$configJson = $configJson | ConvertFrom-Json

### SCRIPT

$newInstanceName = "NewInstanceName"
$newHostName = "NewHostName"

$configJson.instance.name = $newInstanceName
$configJson.instance.hostname = $newHostName

#################################################################################
### Export

$configJson = $configJson | ConvertTo-Json -Depth 10

$spec = @"
{
    "spec": $configJson
}
"@

$spec