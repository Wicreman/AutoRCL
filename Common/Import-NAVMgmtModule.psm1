function Import-NAVMgmtModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ShortVersion
    )
    
    process {
        $registryKeyPath = "HKLM:\SOFTWARE\Microsoft\Microsoft Dynamics NAV\$ShortVersion\Service"
        $mgmtModuleName = "Microsoft.Dynamics.Nav.Management.dll"

        $registryKey = Get-ItemProperty -Path $registryKeyPath -ErrorAction SilentlyContinue

        if($registryKey)
        {
            $modulePath = $registryKey.Path
            $modulePath = [System.Environment]::ExpandEnvironmentVariables($modulePath)
            $mgmtModuleFilePath = Join-Path $modulePath $mgmtModuleName -ErrorAction SilentlyContinue
            Import-Module $mgmtModuleFilePath -Global -ErrorVariable errorVariable -ErrorAction SilentlyContinue
            if (!$errorVariable)
            {
                Write-Verbose "Module successfully imported from $mgmtModuleFilePath."
            }
        }
    }
}

Export-ModuleMember Import-NAVManagementModule