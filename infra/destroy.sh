#!/bin/sh

app_id=$(az ad app list --filter "uniqueName eq 'app-app-service-easy-auth'" --query '[].id' -o tsv)
if [ "$app_id" ]; then
  echo "Deleting App Registration $app_id..."
  az ad app delete --id "$app_id"
  echo "Permanently delete App Registration $app_id..."
  az rest -m delete -u "https://graph.microsoft.com/v1.0/directory/deletedItems/$app_id"
fi

rg_name="rg-app-service-easy-auth"
kv_name=$(az keyvault list -g "$rg_name" --query '[].name' -o tsv)
echo "Deleting resource group $rg_name..."
az group delete -n "$rg_name" -y
echo "Purging key vault $kv_name..."
az keyvault purge -n "$kv_name"
