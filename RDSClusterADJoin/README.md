# Create Remote Desktop Sesson Collection deployment

This template deploys the following resources:

<ul><li>storage account;</li><li>RD Gateway/RD Web Access vm;</li><li>RD Connection Broker/RD Licensing Server vm;</li><li>a number of RD Session hosts (number defined by 'numberOfRdshInstances' parameter)</li></ul>

The template will use existing DC, join all vms to the domain and the configure all of the VMs to join the Azure Automation DSC Pull Server. The RDS roles and the RDS deployment are configured by Azure Automation DSC.

Click the button below to deploy

<a href="https://portal.azure.com/#create/microsoft.template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FBrettOJ%2FEEAzureAutomation%2Fmaster%2FRDSClusterADJoin%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/BrettOJ/EEAzureAutomation/master/RDSClusterADJoin/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>
