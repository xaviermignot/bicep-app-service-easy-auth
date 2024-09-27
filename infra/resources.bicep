param location string = resourceGroup().location
param project string
param uniqueSuffix string
param generateAppRegistrationPassword bool

module keyVault 'modules/keyVault.bicep' = {
  name: 'deploy-keyVault'
  params: {
    location: location
    project: 'aps-easy-auth'
    uniqueSuffix: uniqueSuffix
  }
}

module appServicePlan 'modules/appServicePlan.bicep' = {
  name: 'deploy-appServicePlan'
  params: {
    location: location
    project: project
  }
}

module appService 'modules/appService.bicep' = {
  name: 'deploy-appService'
  params: {
    kvName: keyVault.outputs.name
    location: location
    planId: appServicePlan.outputs.id
    project: project
    uniqueSuffix: uniqueSuffix
  }
}

module rbac 'modules/rbac.bicep' = {
  name: 'deploy-rbac'
  params: {
    appName: appService.outputs.name
    kvName: keyVault.outputs.name
  }
}

module appRegistrationWithPassword 'modules/appRegistrationWithPassword.bicep' = if (generateAppRegistrationPassword) {
  name: 'deploy-appRegistrationWithPassword'
  params: {
    defaultHostName: appService.outputs.defaultHostName
    project: project
  }
}

module appRegistrationSecret 'modules/keyVaultSecret.bicep' = if (generateAppRegistrationPassword) {
  name: 'deployAppRegistrationSecret'
  params: {
    secretName: 'clientSecret'
    secretValue: appRegistrationWithPassword.outputs.clientSecret
    kvName: keyVault.outputs.name
  }
}

module appRegistration 'modules/appRegistration.bicep' = if (!generateAppRegistrationPassword) {
  name: 'deploy-appRegistration'
  params: {
    defaultHostName: appService.outputs.defaultHostName
    project: project
  }
}

module easyAuth 'modules/easyAuth.bicep' = {
  name: 'deploy-easyAuth'
  params: {
    appServiceName: appService.outputs.name
    clientId: generateAppRegistrationPassword
      ? appRegistrationWithPassword.outputs.clientId
      : appRegistration.outputs.clientId
  }
}
