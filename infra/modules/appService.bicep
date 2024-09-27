param location string
param project string
param uniqueSuffix string

param planId string
param kvName string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kvName
}

resource app 'Microsoft.Web/sites@2023-12-01' = {
  name: 'app-${project}-${uniqueSuffix}'
  location: location

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    serverFarmId: planId
    reserved: true

    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        {
          name: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
          value: '@Microsoft.KeyVault(SecretUri=${uri(kv.properties.vaultUri, 'secrets/clientSecret')})'
        }
      ]
    }
  }
}

output id string = app.id
output name string = app.name
output defaultHostName string = app.properties.defaultHostName
