#First run - Login-AzureRmAccount
#
Login-AzureRmAccount
$ConfigData = @{
	AllNodes = @(
		@{
			NodeName = 'localhost'
			PSDscAllowPlainTextPassword = $true
		}
	)
} 
$Params = @{"DomainName" = "Corp"}

Start-AzureRmAutomationDscCompilationJob  -ResourceGroupName "Admin-EENONPROD01-rg" -AutomationAccountName "Admin-EENONPROD01-aa" -ConfigurationName "RemoteDesktopServicesSessionHost" -ConfigurationData $ConfigData -Parameters $Params

