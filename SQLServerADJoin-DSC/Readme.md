# Create a SQL Server 2014 Always On Availability Group in an existing Azure VNET and an existing Active Directory instance

This template will create a SQL Server 2014 Always On Availability Group using the PowerShell DSC Extension in an existing Azure Virtual Network and Active Directory environment.

This template creates the following resources:

+	One Storage Account
+	One Windows Server 2012 or 2016, 
+   Jouins the Server to Azure Automation DSC as SQL Node
+	DSC will maintain the SQL deployment



## Notes

+	The default settings for storage are to deploy using **premium storage**.  The SQL VM uses two P30 disks each (for data and log).  These sizes can be changed by changing the relevant variables. In addition there is a P10 Disk used for each VM OS Disk.

+ 	The image used to create this deployment is the latest version of the Windows Server 2016 with SQL server 

+ 	Click the button below to deploy from the portal

<a href="https://portal.azure.com/#create/microsoft.template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FBrettOJ%2FEEAzureAutomation%2Fmaster%2FSQLServerDSCADJoin%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


