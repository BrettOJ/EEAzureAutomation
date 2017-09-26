workflow ConnectVM_CheckServices
{
	[OutputType([System.Uri])]

    Param
    (            
        [parameter(Mandatory=$true)]
        [String]
        $ResourceGroupName,
    
        [parameter(Mandatory=$true)]
        [String]
        $ServiceName,
        
        [parameter(Mandatory=$true)]
        [String]
        $VMName      
    )
   
	#Setup the VM Variables
	#$ResourceGroupName = Get-AutomationVariable -name "ResourceGroupName"
	#$VMName = Get-AutomationVariable -name 'EEVMName' 

	
	#Setup the Azure Session 
	$AzureOrgIdCredential = Get-AutomationPSCredential -name 'EEAzureCredential' 
	$AzureSubscriptionName = Get-AutomationVariable -name 'EESubscription' 
	
	# Select the Azure subscription we will be working against and set the Azure Context for the session
    Get-AzureRmSubscript -SubscriptionName $AzureSubscriptionName | Set-AzureRmContext


    InlineScript { 
        # Get the Azure certificate for remoting into this VM
        #### This needs to be replaced with the thumb Print from KeyVault
		$winRMCert = (Get-AzureRMVM -ResourceGroupName $Using:ResourceGroupName -Name $Using:VMName |select -ExpandProperty OSProfile).secrets.vaultCertificates
		
        ### This needs to be replaced 
		$AzureX509cert = Get-AzureKeyVaultCertificate -vaultname $using:KeyVaultName -Name $winRMCert 

		# Add the VM certificate into the LocalMachine
        if ((Test-Path Cert:\LocalMachine\Root\$winRMCert) -eq $false)
        {
            Write-Progress "VM certificate is not in local machine certificate store - adding it"
            $certByteArray = [System.Convert]::fromBase64String($AzureX509cert.Data)
            $CertToImport = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList (,$certByteArray)
            $store = New-Object System.Security.Cryptography.X509Certificates.X509Store "Root", "LocalMachine"
            $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
            $store.Add($CertToImport)
            $store.Close()
        }
		
	
		# Return the WinRM URI for ARM VM's
		#### This should work 
		$vm = Get-AzureRmVM -ResourceGroupName TESTVM01 -Name TESTVM01
		$vm.OSProfile.WindowsConfiguration.WinRM.listeners

		
		$Cred = Get-Credential 
		$Uri = "http://cbdrdsclusterrg.australiasoutheast.cloudapp.azure.com:5986"
		$session=New-PSSession -ConnectionUri $Uri -Credential $Cred -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck)
		$Result = Invoke-Command -ConnectionUri $Using:Uri -Credential $Using:Creds -ScriptBlock {Get-WMIObject win32_service -Filter "startmode = 'auto' AND state != 'running'"}
		Write-Output "$result"
    }
}