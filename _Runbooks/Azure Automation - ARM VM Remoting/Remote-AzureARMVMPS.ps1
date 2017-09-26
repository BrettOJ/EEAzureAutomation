<#
.SYNOPSIS 
    Sets up the connection to an Azure ARM VM using Connect-AzureARMVMPS and remotes into it.

.DESCRIPTION
    This runbook sets up a connection to an Azure ARM virtual machine. It requires the Azure virtual machine to
    have the Windows Remote Management service enabled. It enables WinRM and configures it on your VM after which it sets up a connection to the Azure
	subscription, gets the public IP Address of the virtual machine and remotes into it. 

.PARAMETER RemoteVMCredName
    Azure Automation Credential Asset Name for the Credentials with which you wish to remote into the VM
    
.PARAMETER AzureSubscriptionId
    SubscriptionId of the Azure subscription to connect to
    
.PARAMETER AzureOrgIdCredentialName
    A credential containing an Org Id username / password with access to this Azure subscription. It requires the Azure Automation Credential Asset Name.

.PARAMETER ResourceGroupName
    Name of the resource group where the VM is located.

.PARAMETER VMName    
    Name of the virtual machine that you want to connect to  

.EXAMPLE
    Remote-AzureARMVMPS -AzureSubscriptionId "1019**********************" -ResourceGroupName "RG1" -VMName "VM01" -AzureOrgIdCredentialName $cred -RemoteVMCredName "VMCred"


.\Remote-AzureARMVMPS.ps1 -AzureSubscriptionId "e81fd02b-f607-406c-83d2-670ce0497fee" -ResourceGroupName "eecorpdomain" -VMName "advm" -AzureOrgIdCredentialName $cred -RemoteVMCredName $VMCred
.NOTES
    AUTHOR: Rohit Minni
    LASTEDIT: May 25, 2016 
#>

param(
	[Parameter(Mandatory=$true)] 
	[String]$VMCred,
	
	[Parameter(Mandatory=$true)] 
	[String]$AzureSubscriptionId,
	
	[Parameter(Mandatory=$true)] 
	[String]$AzureOrgIdCredentialName,
	
	[Parameter(Mandatory=$true)] 
	[String]$ResourceGroupName,
	
	[Parameter(Mandatory=$true)] 
	[String]$VMName
	
)

$VMCredential = $VMCred

try
{    
    $IpAddress = .\Connect-AzureARMVMPS.ps1 -AzureSubscriptionId $AzureSubscriptionId -AzureOrgIdCredentialName $AzureOrgIdCredentialName -ResourceGroupName $ResourceGroupName -VMName $VMName  
    Write-Output "The IP Address is $IpAddress. Attempting to remote into the VM.."
    if($IpAddress -ne $null)
    {
          
            $sessionOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck                
            Invoke-Command -ComputerName $IpAddress -Credential $VMCredential -UseSSL -SessionOption $sessionOptions -ScriptBlock { 
		    #Code to be executed in the remote session goes here
            $hostname = hostname
            Write-Output "Hostname : $hostname"
            }

    }
}
catch
{
    Write-Output "Could not remote into the VM"
    Write-Output "Ensure that the VM is running and that the correct VM credentials are used to remote"
    Write-Output "Error in getting the VM Details.: $($_.Exception.Message) "
}