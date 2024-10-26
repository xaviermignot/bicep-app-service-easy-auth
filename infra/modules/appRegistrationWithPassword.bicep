extension microsoftGraph

param project string
param defaultHostName string

resource app 'Microsoft.Graph/applications@v1.0' = {
  displayName: 'app-${project}'
  uniqueName: 'app-${project}'

  api: {
    requestedAccessTokenVersion: 2
  }

  web: {
    redirectUris: [
      uri('https://${defaultHostName}', '.auth/login/aad/callback')
    ]

    implicitGrantSettings: {
      enableAccessTokenIssuance: true
      enableIdTokenIssuance: true
    }
  }

  requiredResourceAccess: [
    {
      resourceAppId: '00000003-0000-0000-c000-000000000000'
      resourceAccess: [
        {
          id: '37f7f235-527c-4136-accd-4a02d197296e'
          type: 'Scope'
        }
      ]
    }
  ]

  passwordCredentials: [{}]
}

output clientId string = app.appId
// As outputs cannot be secured in Bicep, the client secret will appear in clear text in the Azure portal.
// This is ok for a sample like this but ideally other options should be used:
//    - Put the secret in a Key Vault secret from this module (instead of another module)
//    - Use Workload Identity Federation once it's available for this scenario
output clientSecret string = app.passwordCredentials[0].secretText
