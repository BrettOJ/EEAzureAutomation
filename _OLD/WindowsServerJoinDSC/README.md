# Create Remote Desktop Sesson Collection deployment

This template deploys the following resources:

<ul><li>storage account;</li><li>Single Server VM;</li><li>Gateway and Load Balancer;</li><li>DSC Pull Server configured </li></ul>

The template will use existing Active Directory Domain Controller, join the VM to the domain and configure the DSC Pull Server in Azure Automation - The Azure Automation will configure the server bases on the *NodeConfigurationName* argument.

The Variables - *RegistrationKey* & *RegistrationURL* should be altered to suite the Azure Automation Deployment 


Click the button below to deploy

<a href="https://portal.azure.com/#create/microsoft.template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FBrettOJ%2FEEAzureAutomation%2Fmaster%2FWindowsServerJoinDSC%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

