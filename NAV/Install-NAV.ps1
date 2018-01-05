function Install-NAV {
    [cmdletbinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $Version,

        [Parameter(Mandatory = $true)]
        [string]
        $Language,

        [Parameter(Mandatory = $false)]
        [string]
        $DatabaseServer = "localhost", 

        # Specifies the instance of the Dynamics NAV database
        [Parameter(Mandatory = $false)]
        [string]
        $DatabaseInstance = "NAVDEMO", 

        [Parameter(Mandatory = $false)]
        [string]
        $RTMDatabaseName = "NAVRTMDB",

        [Parameter(Mandatory = $false)]
        [string]
        $NAVServerServiceAccount = "NT AUTHORITY\NETWORK SERVICE",

        [Parameter(Mandatory = $false)]
        [string]
        $ShortVersion
    )
    
    begin {
        Import-SqlPsModule
    }
    Process {

        $SQLServerInstance = $DatabaseServer;
        if (!$DatabaseInstance.Equals("") -or $DatabaseInstance.Equals("NAVDEMO"))
        {       
            $SQLServerInstance = "$DatabaseServer`\$DatabaseInstance"
        }

        if($ShortVersion.Equals(""))
        {
            switch ($Version) {
                "NAV2018" { 
                    $ShortVersion = "110" 
                    break
                }
                "NAV2017" { 
                    $ShortVersion = "100" 
                    break
                }
                "NAV2016" { 
                    $ShortVersion = "90" 
                    break
                }
                "NAV2015" { 
                    $ShortVersion = "80" 
                    break
                }
                "NAV2013R2" { 
                    $ShortVersion = "71" 
                    break
                }
                "NAV2013" { 
                    $ShortVersion = "70" 
                    break
                }
            }
        }

        $NAVServerInstance = "DynamicsNAV$ShortVersion"
        
        Try
        {
            Write-Log "Step 1: Copy CU build"
            Write-Log "Dynamics NAV Version: $Version Build Date: $BuildDate Language: $Language."
            $copyCUParam = @{
                Version = $Version
                Language = $Language
            }
            $LocalBuildPath = Copy-NAVCU @copyCUParam

            Write-Log "Step 2.1: Install NAV by using setup.exe"
            Write-Log "Running setup.exe to install $Version with $Language"
            Invoke-NavSetup -Path $LocalBuildPath -ShortVersion $ShortVersion

            Write-Log "Step 2.2: Import NAV License"
            Import-NAVLicense -ShortVersion $ShortVersion

            Write-Log "Setp 3: Get the RTM Database backup file"
            $RTMDataBaseBackupFile = Get-NAVRTMDemoData -Version $Version -Language $Language

            Write-Log "Setp 4: Restore RTM Database backup file as new database"
            $rtmParam = @{
                SQLServerInstance = $SQLServerInstance
                DatabaseName = $RTMDatabaseName
                BackupFile = $RTMDataBaseBackupFile
            }
            Stop-NAVServer -ServiceName $NAVServerInstance
            Restore-RTMDatabase @rtmParam

            Write-Log "Setp 5: Set the Service Account  $NAVServerServiceAccount user as db_owner for the  $RTMDatabaseName database "
            $setServiceAccountParam = @{
                NAVServerServiceAccount = $NAVServerServiceAccount
                SqlServerInstance = $SQLServerInstance
                DatabaseName = $RTMDatabaseName
            }
            Set-NAVServerServiceAccount @setServiceAccountParam

            Write-Log "Setp 6.1: Import NAV admin and development module"
            Import-NAVIdeModule -ShortVersion $ShortVersion
            Find-NAVMgtModuleLoaded -ShortVersion $ShortVersion

            Write-Log "Setp 6.2: Update NAV Server configuration to connect RTM Database"
            $serverConfigParam = @{
                ServerInstance = $NAVServerInstance  
                KeyValue = $RTMDatabaseName
            }

            Set-NewNAVServerConfiguration  @serverConfigParam

            Write-Log "Setp 7: Restart NAV AOS"
            Start-NavServer -ServiceName $NAVServerInstance

            Write-Log "Setp 8: Convert the database"
            Stop-NAVServer -ServiceName $NAVServerInstance
            $convertDBParam = @{
                DatabaseServer = $DatabaseServer
                DatabaseInstance = $DatabaseInstance
                DatabaseName = $RTMDatabaseName
            }
            
            Convert-NAVDatabase @convertDBParam
            Start-NavServer -ServiceName $NAVServerInstance
            if ($Version -like "NAV2013*") {
                #Below steps are only for NAV2013 and NAV2013R2
                $NSTPath =  (Join-Path $env:HOMEDRIVE "NAVWorking\$Version\$Language\Extracted\NST\*")
                $WebClientPath = (Join-Path $env:HOMEDRIVE "NAVWorking\$Version\$Language\Extracted\WEB CLIENT\*")
                $RoleTailoredClienPath  = (Join-Path $env:HOMEDRIVE "NAVWorking\$Version\$Language\Extracted\RTC\*")

                $NAVInstalledNSTPath = (Join-Path $env:HOMEDRIVE  "Microsoft Dynamics NAV\Service")
                $NAVInstalledWebClientPath = (Join-Path $env:HOMEDRIVE  "Microsoft Dynamics NAV\Web Client")
                $NAVInstalledRTCPath = (Join-Path $env:HOMEDRIVE  "Microsoft Dynamics NAV\RoleTailored Client")

                Copy-Item -Path $NSTPath -Destination $NAVInstalledNSTPath -Recurse -Force

                Copy-Item -Path $WebClientPath -Destination $NAVInstalledWebClientPath -Recurse -Force

                Copy-Item -Path $RoleTailoredClienPath -Destination $NAVInstalledRTCPath -Recurse -Force

            }
            else {
                Write-Log "Setp 9: Sync the database"
                Sync-NAVDatabase -NAVServerInstance $NAVServerInstance
            }

            Write-Log "Setp 10: Import FOB file"
            if($Version -ne "NAV2015")
            {
                $Version = "Dynamics$Version"
            }
            $demoDataPath = (Join-Path $env:HOMEDRIVE "NAVWorking\$Version\$Language\Extracted\APPLICATION")
            Push-Location $demoDataPath
            $fobPackge = Get-ChildItem * | Where-Object { $_.Name -match ".*$Language.CUObjects\.fob"}
            Pop-Location
            $importFobParam = @{
                Path = $fobPackge.FullName
                SQLServerInstance = $SQLServerInstance
                DatabaseName = $RTMDatabaseName
            }
            Import-FobOrTxtFile @importFobParam

            Write-Log "Setp 11: Import txt file"
            Push-Location $demoDataPath
            $txtPackge = Get-ChildItem * | Where-Object { $_.Name -match ".*$Language.CUObjects\.txt"}
            Pop-Location
            $importTxtParam = @{
                Path = $txtPackge.FullName
                SQLServerInstance = $SQLServerInstance
                DatabaseName = $RTMDatabaseName
            }
            Import-FobOrTxtFile @importTxtParam

            Write-Log "Setp 11: Compile txt file"
            $compileParam = @{
                DatabaseName = $RTMDatabaseName
                SQLServerInstance = $SQLServerInstance
            }
            Invoke-NAVCompile @compileParam

            return 1
        }
        Catch
        { 
            Write-Log "Fail to install or configure NAV function failed! See exception for more information."
            Write-Exception $_.Exception
            Throw $_

            return 0
        }
        
    }
}

Export-ModuleMember -Function Install-NAV

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGypyKtXrR9szb2nDka2Ef549
# 2tWgggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFM3Bah1F
# wkxHGak8PClJE73XQxRQMA0GCSqGSIb3DQEBAQUABIGAPkmDP/SoVvYB6A+PvHf2
# TNizRYh2ZakR9MF4er2tvVarPEbUA65ehx4z3lPtVbyGJsMDPCfXtMRtQLLyZOtL
# ekv5Dsgxmk2zFVe2I29puhLVLhCJ5eaTM6jtpLckpYRz6MOUgZKJBOFbirhEz+do
# pcg7Q6Tt3KCZfv3LlOQ47AA=
# SIG # End signature block