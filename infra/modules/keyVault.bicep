param location string = resourceGroup().location
param project string
param uniqueSuffix string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: take('kv-${project}-${uniqueSuffix}', 24)
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
    enableRbacAuthorization: true
  }
}

output id string = kv.id
output name string = kv.name
