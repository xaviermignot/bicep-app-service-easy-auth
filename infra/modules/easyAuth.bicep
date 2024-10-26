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
      redirectToProvider: 'azureActiveDirectory'
      unauthenticatedClientAction: 'RedirectToLoginPage'
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        registration: {
          clientId: clientId
          openIdIssuer: uri(environment().authentication.loginEndpoint, tenant().tenantId)
          clientSecretSettingName: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
        }
        validation: {
          defaultAuthorizationPolicy: {
            allowedApplications: [
              clientId
            ]
          }
        }
      }
    }
  }
}
