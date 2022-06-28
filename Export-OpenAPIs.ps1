Param (
    [Parameter(Mandatory = $true, HelpMessage = "Resource group of API MAnagement")] 
    [string] $ResourceGroupName,

    [Parameter(Mandatory = $true, HelpMessage = "API Management Name")] 
    [string] $APIMName,

    [Parameter(HelpMessage = "Export folder")] 
    [string] $ExportFolder = "Export",

    [Parameter(HelpMessage = "Export file")] 
    [string] $OutputFilename = "Output.yaml",

    [Parameter(HelpMessage = "Merge configuration file")] 
    [string] $ConfigurationFilename = "configuration.json"
)

$ErrorActionPreference = "Stop"

"Exporting Azure API Management APIs to: $ExportFolder"
"Output OpenAPI file: $OutputFilename"

New-Item -Path $ExportFolder -ItemType Directory -Force | Out-Null

$apiManagementContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $APIMName
$allAPIs = Get-AzApiManagementApi -Context $apiManagementContext

$configuration = @{
    inputs = @()
    output = $OutputFilename
}

$exportedSuccessfully = 0
$exportFailures = 0
foreach ($api in $allAPIs) {
    $api.ApiId
    $apiFile = Join-Path -Path $ExportFolder -ChildPath "$($api.ApiId).yaml"

    try {
        Export-AzApiManagementApi -Context $apiManagementContext -ApiId $api.ApiId -SpecificationFormat OpenApi -SaveAs $apiFile -Force
        $exportedSuccessfully += 1
        $configuration.inputs += @{ 
            inputFile        = $apiFile
            pathModification = @{
                prepend = $api.Path
            }
        }
    }
    catch {
        Write-Warning -Message "Could not export API '$($api.ApiId)' from API Management"
        $exportFailures += 1
    }
}

"Exported successfully $exportedSuccessfully APIs and failed to export $exportFailures APIs"

$configuration | ConvertTo-Json -Depth 3 > $ConfigurationFilename

"Export completed"
