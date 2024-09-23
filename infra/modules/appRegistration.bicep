extension microsoftGraph

param project string
param defaultHostName string

param generatePassword bool

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

  passwordCredentials: generatePassword ? [{}] : []
}
