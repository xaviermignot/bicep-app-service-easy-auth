param kvName string
param appName string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kvName
}

resource app 'Microsoft.Web/sites@2023-12-01' existing = {
  name: appName
}

var secretUserRoleId = '4633458b-17de-408a-b874-0445c86b69e6'
resource kvSecretUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(app.id, kv.id, secretUserRoleId)
  scope: kv
  properties: {
    principalId: app.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', secretUserRoleId)
    principalType: 'ServicePrincipal'
  }
}
