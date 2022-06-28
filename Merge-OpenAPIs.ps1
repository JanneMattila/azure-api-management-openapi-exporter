Param (
    [Parameter(HelpMessage = "OpenAPI spec folder")] 
    [string] $Folder = "$PSScriptRoot\Export",

    [Parameter(HelpMessage = "Export file")] 
    [string] $OutputFilename = "$PSScriptRoot\Output.yaml"
)

$ErrorActionPreference = "Stop"

"Merging OpenAPIs from folder: $Folder"
"Output OpenAPI file: $outputFile"

$files = Get-ChildItem -Path $Folder -Filter *.yaml

$configuration = @{
    inputs = @()
    output = $OutputFilename
}

foreach ($file in $files) {
    $file
    $configuration.inputs += @{ 
        inputFile        = $file.FullName
        pathModification = @{
            prepend = $file.BaseName
        }
    }
}

"Merging $($files.Count) APIs"

$configuration | ConvertTo-Json -Depth 3 > configuration.json

npx openapi-merge-cli --config configuration.json

"Merge completed"
