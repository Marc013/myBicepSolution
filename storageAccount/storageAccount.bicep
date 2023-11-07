@description('Specifies the name of the Azure Storage account.')
param name string

@description('Specifies the location in which the Azure Storage resources should be deployed.')
param location string = resourceGroup().location

@description('Specifies the storage account kind.')
param storageAccountKind string

@description('Specifies the storage account SKU.')
param skuName string

@description('Specifies the storage account access tier.')
param storageAccountAccessTier string

@description('Specifies the tags.')
param tags object

resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: name
  location: location
  tags: tags
  kind: storageAccountKind
  sku: {
    name: skuName
  }
  properties: {
    accessTier: storageAccountAccessTier
  }
}

resource service 'Microsoft.Storage/storageAccounts/fileServices@2021-02-01' = {
  parent: storage
  name: 'default'
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-02-01' = [for i in range(0, 3): {
  parent: service
  name: 'logs${i}'
}]
