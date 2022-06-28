Param (
    [Parameter(Mandatory = $true, HelpMessage = "Resource group of API MAnagement")] 
    [string] $ResourceGroupName,

    [Parameter(Mandatory = $true, HelpMessage = "API Management Name")] 
    [string] $APIMName,

    [Parameter(HelpMessage = "Export folder")] 
    [string] $ExportFolder = "Export",

    [Parameter(HelpMessage = "Export file")] 
    [string] $OutputFilename = "Output.json",

    [Parameter(HelpMessage = "Merge configuration file")] 
    [string] $ConfigurationFilename = "configuration.json",
    
    [Parameter(HelpMessage = "Configuration format")]
    [ValidateSet("v2", "v3")]
    [string] $ConfigurationFormat = "v3"
)

$ErrorActionPreference = "Stop"

"Exporting Azure API Management APIs to: $ExportFolder"
"Output OpenAPI file: $OutputFilename"

New-Item -Path $ExportFolder -ItemType Directory -Force | Out-Null

$apiManagementContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $APIMName
$allAPIs = Get-AzApiManagementApi -Context $apiManagementContext

if ($ConfigurationFormat -eq "v3") {
    $exportFormat = "OpenApiJson"
    $configuration = @{
        inputs = @()
        output = $OutputFilename
    }
}
else {
    $exportFormat = "Swagger"
    $configuration = @{
        swagger = "2.0"
        info    = @{
            title   = "Azure API Management APIs"
            version = "1.0.0"
        }
        apis    = @()
    }
}

$exportedSuccessfully = 0
$exportFailures = 0
foreach ($api in $allAPIs) {
    $api.ApiId
    $apiFile = Join-Path -Path $ExportFolder -ChildPath "$($api.ApiId).json"

    try {
        Export-AzApiManagementApi -Context $apiManagementContext -ApiId $api.ApiId -SpecificationFormat $exportFormat -SaveAs $apiFile -Force
        $exportedSuccessfully += 1

        if ($ConfigurationFormat -eq "v3") {
            $configuration.inputs += @{ 
                inputFile        = $apiFile
                pathModification = @{
                    prepend = $api.Path
                }
            }
        }
        else {
            $configuration.apis += @{ 
                url   = $apiFile
                paths = @{
                    base = $api.Path
                }
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
