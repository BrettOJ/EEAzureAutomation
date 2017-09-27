configuration EE_JoinProdDomain 
{ 
   param 
    ( 
        [Parameter(Mandatory)]
        [String]$domainName
    ) 
    
    Import-DscResource -ModuleName xActiveDirectory, xComputerManagement

    $adminCreds = Get-AutomationPSCredential -Name 'EEDomainAdmin'
    
   
    Node localhost
    {
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
   }
}
