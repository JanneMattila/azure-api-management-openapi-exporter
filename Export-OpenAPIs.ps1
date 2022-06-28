Param (
    [Parameter(Mandatory = $true, HelpMessage = "Resource group of API MAnagement")] 
    [string] $ResourceGroupName,

    [Parameter(Mandatory = $true, HelpMessage = "API Management Name")] 
    [string] $APIMName,

    [Parameter(HelpMessage = "Export folder")] 
    [string] $ExportFolder = "$PSScriptRoot\Export"
)

$ErrorActionPreference = "Stop"

"Exporting Azure API Management APIs to: $ExportFolder"
New-Item -Path $ExportFolder -ItemType Directory -Force | Out-Null

$apiManagementContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $APIMName
$allAPIs = Get-AzApiManagementApi -Context $apiManagementContext

$api = $allAPIs[0]
foreach ($api in $allAPIs) {
    $api.ApiId
    $apiFile = Join-Path -Path $ExportFolder -ChildPath "$($api.ApiId).yaml"
    Export-AzApiManagementApi -Context $apiManagementContext -ApiId $api.ApiId -SpecificationFormat OpenApi -SaveAs $apiFile -Force -ErrorAction Continue
}

"Exported $($allAPIs.Count) APIs"

"Export completed"
