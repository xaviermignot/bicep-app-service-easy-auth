param location string
param project string
param uniqueSuffix string

param planId string

resource app 'Microsoft.Web/sites@2023-12-01' = {
  name: 'app-${project}-${uniqueSuffix}'
  location: location

  properties: {
    serverFarmId: planId
    reserved: true

    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
    }
  }
}