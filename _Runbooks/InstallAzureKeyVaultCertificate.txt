
$cert = Get-AzureKeyVaultSecret -VaultName 'bojVault' -Name 'Broker-Cert'

$password = (Get-AzureKeyVaultSecret -VaultName 'bojVault' -Name 'PassWord-Cert').SecretValueText


$certBytes = [System.Convert]::FromBase64String($cert.SecretValueText)
$certCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$certCollection.Import($certBytes,$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

$protectedCertificateBytes = $certCollection.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $password)
$pfxPath = ".\cb-vm-Certificate.pfx"
[System.IO.File]::WriteAllBytes($pfxPath, $protectedCertificateBytes)

$secure = ConvertTo-SecureString -String $password -AsPlainText -Force

Import-PfxCertificate -FilePath $pfxPath Cert:\CurrentUser\My -Password $secure


## This to connect to VM 

Enter-PSSession -ComputerName $VM -Credential $VMCred -UseSSL -SessionOption $so
 