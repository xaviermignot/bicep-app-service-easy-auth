param location string
param project string

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'asp-${project}'
  location: location

  kind: 'linux'

  properties: {
    reserved: true
  }

  sku: {
    name: 'B1'
  }
}

output id string = plan.id
