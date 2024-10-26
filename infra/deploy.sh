#!/bin/sh

while getopts "l:" opt; do
    case "${opt}" in
    l) location=${OPTARG} ;;
    \?) echo "Invalid option: -$OPTARG" >&2 || exit 1 ;;
    esac
done

if [ -z "$location" ]; then
  location="francecentral"
fi

# If the App Registration already exists, its client secret should not be generated again
app_id=$(az ad app list --filter "uniqueName eq 'app-app-service-easy-auth'" --query '[].id' -o tsv)
generate_app_password="$([ "$app_id" ] && echo 'false' || echo 'true')"

script_dir=$(dirname "$0")
az deployment sub create -n deploy-app-service-easy-auth -f "$script_dir/main.bicep" \
  -p location="$location" -p generateAppRegistrationPassword="$generate_app_password" \
  -l "$location"
