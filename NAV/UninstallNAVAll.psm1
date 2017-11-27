function UninstallNAVAll {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $LogPath,

        [Parameter(Mandatory = $false)]
        [string]
        $CustomQueryFilter = "%NAV%",

        [Parameter(Mandatory = $false)]
        [string]
        $DatabaseServer = ".",

        [Parameter(Mandatory = $false)]
        [string]
        $DatabaseInstance = "NAVDEMO"
    )
    process {
        Write-Log "Looking for all NAV Component..."
        $allInstalledComponents = gwmi win32_product -Filter "Name Like '%NAV%'"
        Write-Log "How many components are found: $allInstalledComponents.length"
        if($allInstalledComponents -ne $null)
        {
            foreach($component in $allInstalledComponents)
            {
                $componentName = $component.Name
                $IdentifyingNumber = $component.IdentifyingNumber
                #MsiExec.exe /X {896C3CF7-9CD5-4F23-B238-01769413A1D0} REBOOT=ReallySuppress /qb-! /l*v "%AxSetupLogDir%\AxSetupHelpServerContentEnusPatchUninstall.log" 
                $LogFile = Join-Path $LogPath ($componentName+"Uninstall.log")
                $args = "/X $IdentifyingNumber REBOOT=ReallySuppress /qb-! /l*v $LogFile"
                Write-Log "Uninstalling NAV Component: $componentName : $IdentifyingNumber"
                $ExitCode = (Start-Process -FilePath "msiexec.exe" -ArgumentList $args -Wait -Passthru).ExitCode
                if($ExitCode -eq 0)
                {
                    Write-Log "Finsihed Uninstalling NAV Component: $componentName : $IdentifyingNumber"
                }
                else
                {
                    Write-Log "Fail to Uninstalling NAV Component: $componentName : $IdentifyingNumber with exit code: $ExitCode"
                }
            } 
        }

        # Uninstall NAV Database.
        Write-Log "Looking for all NAV Database ..."
        $queryStr = "select name from sys.databases where name like $CustomQueryFilter"
        $serverInstance = "$DatabaseServer`\$DatabaseInstance"

        try
        {
            $allNAVDatabases = Invoke-SQLcmd `
            -ServerInstance $serverInstance `
            -Database master  `
            -Query $queryStr
        
            if ($allNAVDatabases -ne $null)
            {
                foreach($navDB in $allNAVDatabases)
                {
                    $dbName = $navDB.Name
                    Write-Log "Droping NAV Database $dbName  ..."
                    Remove-SqlConnectionsToDatabase -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $dbName
                    $dropQueryStr = "Drop DATABASE `"$dbName`""
                    Invoke-SQLcmd $dropQueryStr -ServerInstance $serverInstance
                }
            }
        }
        catch
        {
            Write-Exception $_.Exception
        }
        
    }
}