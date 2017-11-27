<#
.SYNOPSIS
    write log informaiton
.DESCRIPTION
    write log information with timestamp
#>

Function Write-Log
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [String]
        $Message
    )
    
    Process
    {
        $MessageWithDate = "{0}: {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), $Message
        Write-Host $MessageWithDate
    }
}

Export-ModuleMember Write-Log
