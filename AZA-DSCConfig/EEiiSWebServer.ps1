﻿Configuration EE_InstalliiS
{
	Node ("localhost")
	{
	WindowsFeature IIS {
        Ensure = "Present"
        Name = "Web-Server"
    }
    WindowsFeature IISManagementTools
    {
        Ensure = "Present"
        Name = "Web-Mgmt-Tools"
        DependsOn='[WindowsFeature]IIS'
    }
  }
} 