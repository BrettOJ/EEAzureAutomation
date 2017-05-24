# Create Remote Desktop Sesson Collection deployment

This template deploys the following resources:

<ul><li>storage account;</li><li>SQL Witness Server vm;</li><li>x Number of SQL Server vm's;</li></ul>

The template will use existing AD Domain, join all vms to the domain and configure the SQL Always On Cluster Via Azure DSC.

Click the button below to deploy

<a href="https://portal.azure.com/#create/microsoft.template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FBrettOJ%2FEEAzureAutomation%2Fmaster%2FSQLClusterDSCADJoin%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

