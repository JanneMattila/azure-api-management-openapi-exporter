Param (
    [Parameter(HelpMessage = "Export file")] 
    [string] $OutputFilename = "Output.json",

    [Parameter(HelpMessage = "Merge configuration file")] 
    [string] $ConfigurationFilename = "$PSScriptRoot\configuration.json",
        
    [Parameter(HelpMessage = "Configuration format")]
    [ValidateSet("v2", "v3")]
    [string] $ConfigurationFormat = "v3"
)

$ErrorActionPreference = "Stop"

"Merge configuration file: $ConfigurationFilename"

if ($ConfigurationFormat -eq "v3") {
    npx openapi-merge-cli --config $ConfigurationFilename
}
else {
    npx swagger-combine $ConfigurationFilename -o $OutputFilename
}

"Merge completed"
