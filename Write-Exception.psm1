<#
.SYNOPSIS
   Record excption information
.DESCRIPTION
   Record excption information
#>

Function Write-Exception
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [Exception]
        $Exception
    )
    
    Process
    {
        $ExceptionMessage = Get-ExceptionString $Exception
        Write-Log $ExceptionMessage
    }
}

Export-ModuleMember Write-Exception

# Optional commands to create a public alias for the function
New-Alias -Name LogException -Value Write-Exception
Export-ModuleMember -Alias LogException