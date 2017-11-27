function Import-NAVIdeModule{
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
   ModulePaht C:\Program Files (x86)\Microsoft Dynamics NAV\100\RoleTailored Client\

    .PARAMETER ShortVersion
    90, 110, ...

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ShortVersion
    )

    process{

        $registryKeyPath = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Microsoft Dynamics NAV\$ShortVersion\RoleTailored Client"
        $registryKey = Get-ItemProperty -Path $registryKeyPath -ErrorAction SilentlyContinue
        if($registryKey)
        {
            $ModulePath = $registryKey.Path

            if(-Not(Test-Path (Join-Path $ModulePath "Microsoft.Dynamics.Nav.Ide.psm1") ))
            {
                $Message = ("Could not find Microsoft.Dynamics.Nav.Ide.psm1 in path '{0}'!" -f $ModulePath)
                Write-Log $Message
                Throw $Message
            }
    
            if(-Not(Test-Path (Join-Path $ModulePath "finsql.exe") ))
            {
                $Message = ("Could not find finsql.exe in path '{0}'!" -f $ModulePath)
                Write-Log $Message
                Throw $Message
            }
    
            $ModulePath = [System.Environment]::ExpandEnvironmentVariables($ModulePath)
            $IdePath = Join-Path $ModulePath "Microsoft.Dynamics.Nav.Ide.psm1" -ErrorAction SilentlyContinue
            $FinSQLFile = Join-Path $ModulePath "finsql.exe" -ErrorAction SilentlyContinue
    
            Import-Module $IdePath -Global -Arg $FinSQLFile -ErrorVariable errorVariable -ErrorAction Stop
    
            if (!$errorVariable)
            {
                Write-Verbose "The module was successfully imported from $ModulePath -Arg $FinSQLFile."
            }
        }

        
    }
}

Export-ModuleMember Import-NAVIdeModule