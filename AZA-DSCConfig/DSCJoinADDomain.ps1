configuration DSCJoinADDomain 
{ 
   param 
    ( 
        [Parameter(Mandatory)]
        [String]$domainName
    ) 
    
    Import-DscResource -ModuleName xActiveDirectory, xComputerManagement
    $DomainCreds = Get-AutomationPSCredential -Name 'EEDomainAdmin'
   
    Node localhost
    {
        LocalConfigurationManager 
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
			ActionAfterReboot = 'ContinueConfiguration'
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
            Credential = $domainCreds
            DependsOn = "[WindowsFeature]ADPowershell" 
        }
   }
}
