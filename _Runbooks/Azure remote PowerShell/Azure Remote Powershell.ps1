workflow Invoke-AzureVMCommand
{
    # Get the Azure Management Credentials
    $creds = Get-AutomationPSCredential -Name 'eeRunBook'
               
    #Connect to your Azure Account
    $Account = Add-AzureAccount -Credential $creds
    if(!$Account) {
        Throw "Could not authenticate to Azure using the credential asset '${CredentialAssetName}'. Make sure the user name and password are correct."
    }
             
    InlineScript 
    {  
        # Get the Azure certificate for remoting into this VM 

		$winRMCert = (Get-AzureRMVM -ResourceGroupName 'RDSCLUSTERRG' -Name 'cb-vm' | Select -ExpandProperty vm).DefaultWinRMCertificateThumbprint

        $winRMCert = (Get-AzureVM -ServiceName 'trial-brisebois' -Name 'cb-vm' | select -ExpandProperty vm).DefaultWinRMCertificateThumbprint    
        $AzureX509cert = Get-AzureCertificate -ServiceName 'trial-brisebois' `
                                              -Thumbprint $winRMCert `
                                              -ThumbprintAlgorithm sha1 
               
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
    }             
     
    # Build the connection URI with the WinRM port configured on the VM          
    $uri = 'https://trial-brisebois.cloudapp.net:5986/'
     
    # Get the VM Admin Credentials                         
    $admin = Get-AutomationPSCredential -Name 'Brisebois'            
                              
    # Run a command on the Azure VM 
    InlineScript {         
        Invoke-command -ConnectionUri $Using:uri -credential $Using:admin -ScriptBlock { 
            
            # This script executes on the remote VM
            New-Item c:\trial-brisebois.txt -type file
         
        } 
    }         
}