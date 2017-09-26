configuration SQLFileShareWitnessServer
{
    param
    (
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    )

    Import-DscResource -ModuleName xComputerManagement, xSmbShare, xDisk, xActiveDirectory

	$Admincreds = Get-AutomationPSCredential -Name 'EEDomainAdmin'
    $SharePath = Get-AutomationVariable -Name "EE_SQLWitnessShareName"

    
    Node localhost
    {
        xWaitforDisk Disk2
        {
             DiskNumber = 2
             RetryIntervalSec =$RetryIntervalSec
             RetryCount = $RetryCount
        }

        xDisk DataDisk
        {
            DiskNumber = 2
            DriveLetter = "F"
        }

        WindowsFeature ADPS
        {
            Name = "RSAT-AD-PowerShell"
            Ensure = "Present"
        } 

        xComputer DomainJoin
        {
            Name = $env:COMPUTERNAME
            DomainName = $DomainName
            Credential = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
        }

        File FSWFolder
        {
            DestinationPath = "F:\$($SharePath.ToUpperInvariant())"
            Type = "Directory"
            Ensure = "Present"
            DependsOn = "[xComputer]DomainJoin"
        }

        xSmbShare FSWShare
        {
            Name = $SharePath.ToUpperInvariant()
            Path = "F:\$($SharePath.ToUpperInvariant())"
            FullAccess = "BUILTIN\Administrators"
            Ensure = "Present"
            DependsOn = "[File]FSWFolder"
        }
        LocalConfigurationManager 
        {
            RebootNodeIfNeeded = $True
        }
    }     
}
