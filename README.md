# Announcement

We have decided to remove our VM extensions from the Microsoft Azure and Azure Stack Marketplace.  
To use Deep Security Agent, please try to use deployment scripts directly:  
https://help.deepsecurity.trendmicro.com/Add-Computers/ug-add-dep-scripts.html

If you really need to deploy via Azure VM extension, please use the custom script extension instead:  
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/extensions-customscript  
https://github.com/Azure/custom-script-extension-linux

If you encounter any problem, please contact the Trend Micro open source support team at deepsecurityopensource@trendmicro.com

# Deploying the Deep Security VM Extension on Azure Virtual Machines Using PowerShell

To automate the process of installing the Deep Security VM Extension, you can use the PowerShell scripts in this repository, along with a customized JSON format
config file to install the Deep Security VM Extension on an existing virtual machine.

## Support

This is a community project and while you will see contributions from the Deep Security team, there is no official Trend Micro support for this project. The official documentation for the Deep Security APIs is available from the [Trend Micro Online Help Centre](http://docs.trendmicro.com/en-us/enterprise/deep-security.aspx). 

Tutorials, feature-specific help, and other information about Deep Security is available from the [Deep Security Help Center](https://help.deepsecurity.trendmicro.com/Welcome.html). 

For Deep Security specific issues, please use the regular Trend Micro support channels. For issues with the code in this repository, please [open an issue here on GitHub](https://github.com/deep-security/azure-vm-extensions/issues).

## System Requirements 
- [PowerShell 3.0,](https://www.microsoft.com/en-us/download/details.aspx?id=34595)
- [Azure Module 1.3.0](https://github.com/Azure/azure-powershell/releases/tag/v1.3.0-March2016)

## Use PowerShell Script to install the Deep Security VM Extension on an existing virtual machine

### Preparing Deep Security Manager (DSM) information (required for both ASM and ARM)

- Copy the text below to a text file named `public.config`, and customize the content. (Note: replace *DSM_Host* and *DSM_Port* with actual values)
```
{
    "DSMname": "<DSM_Host>",
    "DSMport":"<DSM_Port>",
    "policyID":""
}
```

- Copy the text below to a text file named `private.config` (Note: replace *DSM_tenant_id* and *DSM_tenant_password* with actual values)
```
{
    "tenantID": "<DSM_tenant_id>" ,
    "tenantPassword":"<DSM_tenant_password>"
}
```

### To add the Deep Security VM Extension for Azure Classic Compute (ASM)

- Open Azure Powershell.
- Login in Azure Classic (ASM) by executing these commands in PowerShell:
```
# Pop-up login frame and login into Azure
Add-AzureAccount
  
# List subscriptions under current login account
Get-AzureSubscription
  
# Associate subscription id with storage account
Set-AzureSubscription -SubscriptionId <change-with-subscription-id> -CurrentStorageAccount "<change-with-storage-account>"
 
# Select active subscription to be used for current session
Select-AzureSubscription -SubscriptionId <change-with-subscription-id>
```
- Use the scripts below to add the Deep Security VM Extension according to the VM operating system:

*Windows:*
```
.\DeepSecurityAddExtension_ASM_Windows_sample.ps1 -privateFileName "private.config" -publicFileName "public.config" -cloudServiceName "<cloud-service-name>" -vmName "<vm-name>"
```
*Linux :*
```
.\DeepSecurityAddExtension_ASM_Linux_sample.ps1 -privateFileName "private.config" -publicFileName "public.config" -cloudServiceName "<cloud-service-name>" -vmName "<vm-name>"
```

### To add the Deep Security VM Extension for Azure Compute (ARM)

- Open Azure Powershell.
- Log in to Azure Resource Management by executing these commands in PowerShell:
```
# Pop-up login frame and login into Azure
Login-AzureRmAccount
  
# List subscriptions under current login account
Get-AzureRMSubscription
    
# Select active subscription to be used for current session
Select-AzureRMSubscription -SubscriptionId <change-with-subscription-id>
```
*Windows :*
```
.\DeepSecurityAddExtension_ARM_Windows_sample.ps1 -privateFileName "private.config" -publicFileName "public.config" -location "<location>" -resourceGroupName "<resource-group-name>" -vmName "<vm-name>"
```
*Linux :*
```
.\DeepSecurityAddExtension_ARM_Linux_sample.ps1 -privateFileName "private.config" -publicFileName "public.config" -location "<location>" -resourceGroupName "<resource-group-name>" -vmName "<vm-name>"
```