$Message = "Update JSON" 

 Import-Module posh-git
    git add .
   git commit -m $message
   git push