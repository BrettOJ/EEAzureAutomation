#First run - Login-AzureRmAccount
#
$ConfigData = @{
	AllNodes = @(
		@{
			NodeName = 'localhost'
			PSDscAllowPlainTextPassword = $true
		}
	)
} 
#$Params = "" # = @{"DomainName" = "Corp.net.au"}

Start-AzureRmAutomationDscCompilationJob  -ResourceGroupName "EssentialAutomation" -AutomationAccountName "ESSENTIAL" -ConfigurationName "EE_InstalliiS" -ConfigurationData $ConfigData #-Parameters $Params

