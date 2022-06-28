# Azure API Management OpenAPI exporter

Export and merge Open API specs of Azure API Management APIs

## Pre-reqs 

For OpenAPI 3.0 definitions:

```cmd
npm install openapi-merge-cli
```

For OpenAPI 2.0 definitions (a.k.a. Swagger):

```cmd
npm install swagger-combine
```

## Export and merge

For OpenAPI 3.0 definitions:

```powershell
.\Export-OpenAPIs.ps1 -ResourceGroupName "rg-apim" -APIMName "contosoapim"
.\Merge-OpenAPIs.ps1
```

For OpenAPI 2.0 definitions (a.k.a. Swagger):

```powershell
.\Export-OpenAPIs.ps1 -ResourceGroupName "rg-apim" -APIMName "contosoapim" -ConfigurationFormat v2
.\Merge-OpenAPIs.ps1 -ConfigurationFormat v2
```
# Additinal tools

[openapi-merge](https://www.npmjs.com/package/openapi-merge)
[openapi-merge-cli](https://www.npmjs.com/package/openapi-merge-cli)

[Swagger Combine](https://github.com/maxdome/swagger-combine)
