param appServiceName string
param clientId string

resource app 'Microsoft.Web/sites@2023-12-01' existing = {
  name: appServiceName
}

resource easyAuth 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: app
  name: 'authsettingsV2'
  properties: {
    globalValidation: {
      requireAuthentication: true
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        registration: {
          clientId: clientId
          openIdIssuer: uri(environment().authentication.loginEndpoint, tenant().tenantId)
        }
      }
    }
  }
}
