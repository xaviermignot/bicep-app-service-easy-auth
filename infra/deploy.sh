#!/bin/sh

app_id=$(az ad app list --filter "uniqueName eq 'app-app-service-easy-auth'" --query '[].id' -o tsv)
generate_app_password="$([ "$app_id" ] && echo 'false' || echo 'true')"

script_dir=$(dirname $0)
az deployment sub create -n deploy-app-service-easy-auth -f "$script_dir/main.bicep" -p location=francecentral -p generateAppRegistrationPassword="$generate_app_password" -l francecentral
