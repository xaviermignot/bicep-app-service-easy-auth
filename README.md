# Azure App Services with Easy Auth using Bicep

This repository contains Bicep code to provision an Azure App Service protected by Easy Auth.  
Easy Auth is the built-in authentication feature of App Service. It can be used with several identity providers, in this sample the Microsoft Entra provider is used as the purpose is to show how the `microsoftGraph` provider of Bicep works alongside _classic_ Bicep code.

> [!WARNING]
> The code of this repo is just a sample and is not production-grade.
> First because it uses an experimental feature of Bicep, and also because an output of the `appRegistrationWithPassword` module contains a client secret. 
> Ideally Workload Identity Federation should be used instead of a secret, but it's not available yet for App Service Easy Auth.

## Getting started
To use this sample make sure the following prerequisites are met:
1. You are using a Linux-based environment (everything has been tested using Ubuntu 22.04 with WSL)
2. You have an Azure subscription
3. You are owner of the subscription (or access-level administrator) and have the right to create App Registrations in Entra ID
4. Azure CLI is installed and you are authenticated against your subscription

Once you have that, simply run this command from the rool of the repo: `infra/deploy.sh -l <AZURE-REGION>` (replace `<AZURE-REGION>` with the Azure region of your choice: `francecentral`, `canadaeast`, `eastus`, ...).  
This will create a resource group `rg-app-service-easy-auth` in your Azure subscription with an App Service, App Service Plan and a Key Vault. An App Registration `app-app-service-easy-auth` and linked Enterprise App will also be created in your Entra ID tenant.  

## Browsing the app
From the App Service resource blade you can get its URL (ending with `.azurewebsites.net`). Browse this URL, it will prompt you once for consent and then you will be able to get to the default App Service webpage.  
Remove the `AppServiceAuthSession` cookie, and refresh the page: you should be redirected to `https://login.microsoftonline.com` before going back to the app. You will probably be authenticated through SSO, so go to private mode if you want to authenticate with your credentials.

## Tearing-up
Once you are done you can clean-up the resources with this command: `infra/destroy.sh`
