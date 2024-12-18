targetScope = 'subscription'

param location string
param generateAppRegistrationPassword bool

var project = 'app-service-easy-auth'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-${project}'
  location: location
}

module resources 'resources.bicep' = {
  scope: rg
  name: 'deploy-${project}-${location}'

  params: {
    project: project
    uniqueSuffix: uniqueString(subscription().id, location, project)
    generateAppRegistrationPassword: generateAppRegistrationPassword
  }
}

output appServiceDefaultHostName string = resources.outputs.appServiceDefaultHostName
