<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ServerInstance
Parameter description

.PARAMETER KeyName
Parameter description

.PARAMETER KeyValue
Parameter description

.EXAMPLE
$params = @{
ServerInstance = "DynamicsNAV";
KeyName = "DatabaseName" ;
KeyValue = "RTM100B"
}
Set-NAVServerConfiguration @params

.NOTES
General notes
#>
function Set-NewNAVServerConfiguration  {
   param(

    [Parameter(Mandatory = $false)]
    [string]
    $ServerInstance = "DynamicsNAV",

    [Parameter(Mandatory = $false)]
    [string]
    $KeyName = "DatabaseName",

    [Parameter(Mandatory = $false)]
    [string]
    $KeyValue = "NAVRTMDB"

   ) 

   process{
        try { 
            Write-Log "Update NAV Server configuration for $KeyName = $KeyValue in $ServerInstance "
            $params = @{
                ServerInstance = "$ServerInstance";
                KeyName = "$KeyName" ;
                KeyValue = "$KeyValue"        
            }

            Set-NAVServerConfiguration @params
        }
        catch  {
            Write-Error "Fail to udpate NAV Server configuration!"
            Write-Exception $_.Exception
        }
   }
}

Export-ModuleMember -Function Set-NewNAVServerConfiguration