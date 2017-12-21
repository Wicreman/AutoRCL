function Uninstall-NAVAll {
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

Export-ModuleMember -Function Uninstall-NAVAll

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUiaHy6SLaGrjvMz0iUlh+4oJd
# fgugggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
# MA4xDDAKBgNVBAMTA05BVjAeFw0xNzExMjgwNDAwMzlaFw0zOTEyMzEyMzU5NTla
# MA4xDDAKBgNVBAMTA05BVjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAp5GZ
# c6U30Wj/1Y5mmZpi4BU7Cy1Pbo7gDOVnxvIHCi1Bfivb7WQB3cpp1b2vYeBgH3y0
# Cl9th4bgTy9fPe/zdin57thq/OwJS3qB8rxKazh+Xa3BpHxvAumX7THqZ8ocvirB
# JGIl3K9fDUyeRkPDKq+CC0eqnKDaS6ANuHdvCg8CAwEAAaNYMFYwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwPwYDVR0BBDgwNoAQEgOra+cR2aH3BOGG7Qzr1qEQMA4xDDAK
# BgNVBAMTA05BVoIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUAA4GBABelU7ZT
# +OXIZH2HfiD4Ngv7lef7RGEaLtBCiXyxkcmTInxY8s6FImkD0Hywf1jcDcU3LeEt
# QnxDsQvfkUFBRHhzFIUvhCxmTHgKfDvisV07bOIrraHuCUAQ+72yrQ7HSRQ5p9z4
# B98bWycdUXSY7mg5l6VilFT2A2Bs03U0WZ82MYIBQjCCAT4CAQEwIjAOMQwwCgYD
# VQQDEwNOQVYCEHq2r9TiRoyURK9oQzHhKh8wCQYFKw4DAhoFAKB4MBgGCisGAQQB
# gjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFLSH08gY
# BHNhTAIEBwXPKqzTBCalMA0GCSqGSIb3DQEBAQUABIGAo+cWsg5rzexoJSVheePY
# qanESM8R124tn8S707k9n3QdNeIrtWenwqT7Dh08MYPONo626+cAX1t9jtQ2mGrh
# ZmZYzCAtgzQ7ymE9aJoDWVTZgOd2rMFSmDiKh58IMJUz+YhyYalHb5S8j7SH0uMD
# Zt4ZgG0myZOW7+1kzysmiOA=
# SIG # End signature block
