configuration DSCCreateADPDC 
{ 
   param 
   ( 
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    ) 
    
    Import-DscResource -ModuleName xActiveDirectory, xNetworking, PSDesiredStateConfiguration, xDNSServer
	
	$domainCreds = Get-AutomationPSCredential -Name 'EEDoaminAdminCred'
	$safemodeAdministratorCred = Get-AutomationPSCredential -Name 'EEsafemodeAdminCred'
	$DNSForwarder = Get-AutomationVariable -Name 'DNSForwarder'
	$Interface=Get-NetAdapter|Where Name -Like "Ethernet*"|Select-Object -First 1
    $InterfaceAlias=$($Interface.Name)

    Node localhost
    {
        LocalConfigurationManager 
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
			ActionAfterReboot = 'ContinueConfiguration'
        }

	    WindowsFeature DNS 
        { 
            Ensure = "Present" 
            Name = "DNS"		
        }

	    WindowsFeature DnsTools
	    {
	        Ensure = "Present"
            Name = "RSAT-DNS-Server"
	    }

        xDnsServerAddress DnsServerAddress 
        { 
            Address        = '127.0.0.1' 
            InterfaceAlias = $InterfaceAlias
            AddressFamily  = 'IPv4'
	        DependsOn = "[WindowsFeature]DNS"
        }
		xWaitForADDomain DscForestWait
        {
            DomainName = $Node.DomainName
            DomainUserCredential = $domainCred
            RetryCount = $Node.RetryCount
            RetryIntervalSec = $Node.RetryIntervalSec
            DependsOn = "[xADDomain]FirstDS"
        }

        WindowsFeature ADDSInstall 
        { 
            Ensure = "Present" 
            Name = "AD-Domain-Services"
        } 
        xADDomain FirstDS
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $safemodeAdministratorCred
            DnsDelegationCredential = $domainCred
            DependsOn = "[WindowsFeature]ADDSInstall"
        }   
        xADUser FirstUser
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $domainCred
            UserName = "JoinDomain"
            Password = $domainCred
            Ensure = "Present"
            DependsOn = "[xWaitForADDomain]DscForestWait"
        }
		xDnsServerForwarder addForwarder
		{
			IsSingleInstance = "yes"
			IPAddresses = $DNSForwarder
			DependsOn = "[xADDomain]FirstDS"
		}
   }
} 

