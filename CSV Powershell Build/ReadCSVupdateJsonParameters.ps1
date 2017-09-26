
#Environment
$path     = Split-Path -parent $MyInvocation.MyCommand.Definition  

# Constants.
$DELIM = ','
$CSV_F = $path + '\test.csv'
$TemplateParametersFileName = $path + '\azuredeploy.parameters.json'
$outputfile = 'c:\tmp\output.json'

#Function to clean up JSON output
function Format-Json([Parameter(Mandatory, ValueFromPipeline)][String] $json) {
  $indent = 0;
  ($json -Split '\n' |
    % {
      if ($_ -match '[\}\]]') {
        # This line contains  ] or }, decrement the indentation level
        $indent--
      }
      $line = (' ' * $indent * 2) + $_.TrimStart().Replace(':  ', ': ')
      if ($_ -match '[\{\[]') {
        # This line contains [ or {, increment the indentation level
        $indent++
      }
      $line
  }) -Join "`n"
}
# Parse files
$keys = (Get-Content "${CSV_F}" -TotalCount 1).Split($DELIM)
$csv = Import-CSV "${CSV_F}"

#Not required - referrence only
$JsonContent = Get-Content $TemplateParametersFileName -Raw | ConvertFrom-Json 
    #Get input PSObject Properties
    $JsonSchema = $JsonContent.'$schema'
    $JsonContentVer = $JsonContent.contentVersion
  
$JsonSubObject = [pscustomobject]@{}

   $JsonObject = [pscustomobject]@{}
        Add-Member -InputObject $JsonObject -MemberType NoteProperty -Name '$schema' -Value $JsonSchema
        Add-Member -InputObject $JsonObject -MemberType NoteProperty -Name 'contentVersion' -Value $JsonContentVer

# Iterate through CSV to build hashtable
ForEach ($r in $csv) {
    $tmp_h = @{}

    # Create hash of key-value pairs.
    ForEach($k in $keys) {
        $tmp_h[$k] = $r.($k)     
    }

   #Loop through Hash table to create variables
   foreach ($kvp in $tmp_h.GetEnumerator()) {
    [string]$key = $kvp.name
    [string]$val = $kvp.value

    #Create Sub PSObjects from Key Value Pairs
    If ($val) {
      $psobjname = $val
      $psobjname = [pscustomobject]@{}
     
        Add-Member -InputObject $psobjname -MemberType NoteProperty -Name 'value' -Value $val
        #Create the mid tier PSObject
        Add-Member -InputObject $JsonSubObject -MemberType NoteProperty -Name $key -Value $psobjname           
            }
        }
    }
    #Create the final top level PSObject
    Add-Member -InputObject $JsonObject -MemberType NoteProperty -Name 'parameters' -Value $JsonSubObject

    #Write the JSON Output file
    $JsonObject | ConvertTo-Json | Format-Json | Out-File -Encoding Ascii $TemplateParametersFileName
  
