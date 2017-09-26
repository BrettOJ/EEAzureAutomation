$resourceGroupName = "EssentialAutomation"
$automationAccountName = "ESSENTIAL"
$DscNode = Get-AzureRmAutomationDscNode -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName

foreach ($node in $DSCNode){

$dscid = $node.id

Unregister-AzureRmAutomationDscNode -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -Id $DscId

}

