Configuration RemoteDesktopServicesSessionHost
{
	Param
(
	[Parameter(Mandatory)]
	[String]$domainName,

	[String]$ConnectionBroker,

	[String]$webAccessServer,

	[String]$SessionHostName,

	[string]$collectionName = "RDSCollection",

	[String]$collectionDescription = "RDS Deployment in Azure"

)
	Import-DscResource -ModuleName PSDesiredStateConfiguration
	Import-DscResource -ModuleName xActiveDirectory, xComputerManagement, xRemoteDesktopSessionHost

	$adminCreds = Get-AutomationPSCredential -Name 'EEDomainAdmin'

	Node localhost {

		LocalConfigurationManager
		{
			RebootNodeIfNeeded = $true
		}
		WindowsFeature Remote-Desktop-Services
		{
			Name = "Remote-Desktop-Services"
			Ensure = "Present"
		}
		WindowsFeature RDS-RD-Server
		{
			Name = "RDS-RD-Server"
			Ensure = "Present"
		}
		WindowsFeature Desktop-Experience
		{
			Name = "Desktop-Experience"
			Ensure = "Present"
		}
		WindowsFeature RSAT-RDS-Tools
		{
			Name = "RSAT-RDS-Tools"
			Ensure = "Present"
			IncludeAllSubFeature = $true
			}
		WindowsFeature ADPowershell
		{
			Name = "RSAT-AD-PowerShell"
			Ensure = "Present"
		}
		xComputer DomainJoin
		{
			Name = $env:COMPUTERNAME
			DomainName = $domainName
			Credential = $adminCreds
			DependsOn = "[WindowsFeature]ADPowershell"
		}
		xRDSessionDeployment Deployment
		{
			SessionHost = $SessionHostName
			ConnectionBroker = $ConnectionBroker
			WebAccessServer = $webAccessServer
			DependsOn = "[WindowsFeature]Remote-Desktop-Services", "[WindowsFeature]RDS-RD-Server"
		}
		xRDSessionCollection Collection
		{
			CollectionName = $collectionName
			CollectionDescription = $collectionDescription
			SessionHost = $SessionHostName
			ConnectionBroker = $ConnectionBroker
			DependsOn = "[xRDSessionDeployment]Deployment"
		}
		xRDSessionCollectionConfiguration CollectionConfiguration
		{
			CollectionName = $collectionName
			CollectionDescription = $collectionDescription
			ConnectionBroker = $ConnectionBroker
			TemporaryFoldersDeletedOnExit = $false
			SecurityLayer = "ssl"
			DependsOn = "[xRDSessionCollection]Collection"
		}
		xRDRemoteApp Calc
		{
			CollectionName = $collectionName
			DisplayName = "Calculator"
			FilePath = "C:\Windows\System32\calc.exe"
			Alias = "Calc"
			DependsOn = "[xRDSessionCollection]Collection"
		}
		xRDRemoteApp Mstsc 
		{
			CollectionName = $collectionName
			DisplayName = "Remote Desktop"
			FilePath = "C:\Windows\System32\mstsc.exe"
			Alias = "Mstsc"
			DependsOn = "[xRDSessionCollection]Collection"
		}
	}
}