param location string = resourceGroup().location
param storageAccountName string = 'stdevops${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: { keyType: 'Account', enabled: true }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

output storageName string = storageAccount.name