Configuration RemoteDesktopServicesBroker
{
	Param
(
	[Parameter(Mandatory)]
	[String]$domainName

)
	Import-DscResource -ModuleName xPSDesiredStateConfiguration
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
		WindowsFeature RDS-Connection-Broker
		{
			Name = "RDS-Connection-Broker"
			Ensure = "Present"
		}
		WindowsFeature RDS-Licensing
		{
			Name = "RDS-Licensing"
			Ensure = "Present"
		}
	}

}