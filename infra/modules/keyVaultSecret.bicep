param kvName string
param secretName string
@secure()
param secretValue string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kvName
}

resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: secretName
  parent: kv
  properties: {
    value: secretValue
  }
}

output uri string = kvSecret.properties.secretUri
