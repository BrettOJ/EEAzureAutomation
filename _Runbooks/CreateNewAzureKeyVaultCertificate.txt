workflow CreateNewAzureKeyVaultCertificate {
    param
    (
        [parameter(Mandatory=$true)]
        [String]
        $KeyVaultName,

		[parameter(Mandatory=$true)]
        [PSCredential]
        $VMName
    )

	$CertName = $VMName + "-Cert"
	$SubjectName = "CN=" + $VMName

	$certificatepolicy = New-AzureKeyVaultCertificatePolicy   -SubjectName $SubjectName -IssuerName Self   -ValidityInMonths 12
	Add-AzureKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -CertificatePolicy $certificatepolicy
}