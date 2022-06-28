Param (
    [Parameter(HelpMessage = "Merge configuration file")] 
    [string] $ConfigurationFilename = "$PSScriptRoot\configuration.json"
)

$ErrorActionPreference = "Stop"

"Merge configuration file: $ConfigurationFilename"

npx openapi-merge-cli --config $ConfigurationFilename

"Merge completed"
