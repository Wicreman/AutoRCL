Function Get-ExceptionString
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [Exception]
        $Exception
    )
    
    Process
    {
        $ExceptionString = "Exception message:" + [Environment]::NewLine + $Exception.Message
        
        If ($Exception.StackTrace -Ne $Null)
        {
            $ExceptionString += "Stack trace:" + [Environment]::NewLine + $Exception.StackTrace
        }
        
        If ($Exception.InnerException -Ne $Null)
        {
            $ExceptionString += 
                [Environment]::NewLine + [Environment]::NewLine + `
                "Inner exception:" + [Environment]::NewLine + `
                (Get-ExceptionString $Exception.InnerException)
        }
        
        Return $ExceptionString
    }
}

Export-ModuleMember Get-ExceptionString
