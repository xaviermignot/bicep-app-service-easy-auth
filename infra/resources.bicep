param location string = resourceGroup().location
param project string
param uniqueSuffix string
param generateAppRegistrationPassword bool

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
    location: location
    planId: appServicePlan.outputs.id
    project: project
    uniqueSuffix: uniqueSuffix
  }
}

module appRegistration 'modules/appRegistration.bicep' = {
  name: 'deploy-appRegistration'
  params: {
    defaultHostName: appService.outputs.defaultHostName
    project: project
    generatePassword: generateAppRegistrationPassword
  }
}

module easyAuth 'modules/easyAuth.bicep' = {
  name: 'deploy-easyAuth'
  params: {
    appServiceName: appService.outputs.name
    clientId: appRegistration.outputs.clientId
  }
}
