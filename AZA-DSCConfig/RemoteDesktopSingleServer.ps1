Configuration RemoteDesktopSingleServer {
    param(

        [Parameter(Mandatory)]
        [String]$domainName

    )

    Import-DscResource -ModuleName xActiveDirectory, xComputerManagement, xRemoteDesktopSessionHost

    	$adminCreds = Get-AutomationPSCredential -Name 'EEDomainAdmin'


      Node "localhost" {
    
            LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
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
        WindowsFeature FeatureRDCB {
            Name   = 'RDS-Connection-Broker'
            Ensure = 'Present'
        }

        WindowsFeature FeatureRDSH {
            Name   = 'RDS-RD-Server'
            Ensure = 'Present'
        }

        WindowsFeature FeatureRDWA {
            Name   = 'RDS-Web-Access'
            Ensure = 'Present'
        }

        xRDSessionDeployment Deployment {
            ConnectionBroker     = $Node.NodeName
            WebAccessServer      = $Node.NodeName
            SessionHost          = $Node.NodeName
            PsDscRunAsCredential = $adminCreds
            DependsOn            = '[WindowsFeature]FeatureRDCB', '[WindowsFeature]FeatureRDSH', '[WindowsFeature]FeatureRDWA'
        }
   }
 }