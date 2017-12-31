param(
    # Product Version such NAV2015, NAV2018, NAV2016
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
    $NAVServerServiceAccount = "NT AUTHORITY\NETWORK SERVICE"
)


<#
.SYNOPSIS
1. Set execution policy 
2. Import NAVRCLAPI module
3. Import Pester module
#>
function Set-UnitTestEnviorment {
    # Run Get-ExecutionPolicy. If it returns Restricted, 
    # then run Set-ExecutionPolicy AllSigned 
    # or Set-ExecutionPolicy Bypass -Scope Process.
    $policy = Get-ExecutionPolicy 
    if ($policy -eq "Restricted")
    {
        Set-ExecutionPolicy Bypass -Scope Process -Force
    }

    $NAVRclApi = "NAVRCLAPI"
    Get-module  -name $NAVRclApi | Remove-Module
    Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) "NAVRCLAPI.psm1") -Verbose -Force
    <# TODO: below implemention will be used in product environment  
    if(-Not(Get-Module -ListAvailable -Name $NAVRclApi))
    {
        Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) "NAVRCLAPI.psm1") -Verbose -Force
    }
    #>
    if(-Not(Get-Module -ListAvailable -Name "Pester"))
    {
        (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression 
        Install-Module Pester 
    }
}

$NAVRclApi = "NAVRCLAPI"
$ShortVersionMap = @{
    NAV2018 = "110"
    NAV2017 = "100"
    NAV2016 = "90"
    NAV2015 = "80"
    NAV2013R2 = "71"
    NAV2013 = "70"
}

$SQLServerInstance = $DatabaseServer;
if (!$DatabaseInstance.Equals("") -or $DatabaseInstance.Equals("NAVDEMO"))
{       
    $SQLServerInstance = "$DatabaseServer`\$DatabaseInstance"
}

#Set-UnitTestEnviorment


InModuleScope -ModuleName $NAVRclApi {
    Describe "Clean NAV test environment" -Tag "CleanEnvironment" {
        It "Prepare test environment for Dynamics$Version with $Language" {
            # Uninstall all NAV components and drop NAV database
            Uninstall-NAVAll
            # TODO: check uninstalled log information to make sure all componest was uninstalled successfully.
            #Remove all NAV related directory
            $NAVWorkingDir  = Join-Path $env:HOMEDRIVE "NAVWorking"
            if(Test-Path $NAVWorkingDir)
            {
                Write-Log "$NAVWorkingDir exists. Deleting..."
                Remove-Item $NAVWorkingDir -Force -Recurse
            }

            $NAVInstalledDir  = Join-Path $env:HOMEDRIVE "Microsoft Dynamics NAV"
            if(Test-Path $NAVInstalledDir)
            {
                Write-Log "$NAVInstalledDir exists. Deleting..."
                Remove-Item $NAVInstalledDir -Force -Recurse
            }
        }
    }

    
    Describe "Install and configure Dynamics$Version" -Tag "NAVSetup" {
        BeforeEach {
            Import-SqlPsModule
        }

        It "$Language" {
    
            # Get the short version for product
            $ShortVersion = $ShortVersionMap.$Version

            # Get NAV Server instance from short version
            $NAVServerInstance = "DynamicsNAV$ShortVersion"

            Write-Log "Step 1: Copy CU build"
            Write-Log "Dynamics NAV Version: $Version Language: $Language."
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
            $RTMDatabaseName = "$RTMDatabaseName$ShortVersion"
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

            Stop-NAVServer -ServiceName $NAVServerInstance
            Write-Log "Setp 8: Convert the database"
            $convertDBParam = @{
                DatabaseServer = $DatabaseServer
                DatabaseInstance = $DatabaseInstance
                DatabaseName = $RTMDatabaseName
            }
            
            Convert-NAVDatabase @convertDBParam
            # TODO: Check convert db log

            if ($Version -like "NAV2013*") {
                Write-Log "Setp 9: Copy required file for NST, RTC, Web Client"
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
                Start-NavServer -ServiceName $NAVServerInstance
                Write-Log "Setp 9: Sync the database"
                Sync-NAVDatabase -NAVServerInstance $NAVServerInstance
                # TODO: Check sync db log
            }
        }
    }

    Describe "Import and export process of FOB file " -Tag "UnitTestCase" {
        It "Import fob file into Dynamcis$Version with $Language" {
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

            # TODO: check import log
        }

        It "Export fob file from Dynamcis$Version with $Language" {
            # TODO: export module and check points
        }
    }

    Describe "Import and export process of TXT file " -Tag "UnitTestCase" {
        It "Import txt file into Dynamcis$Version with $Language" {
            Push-Location $demoDataPath
            $txtPackge = Get-ChildItem * | Where-Object { $_.Name -match ".*$Language.CUObjects\.txt"}
            Pop-Location
            $importTxtParam = @{
                Path = $txtPackge.FullName
                SQLServerInstance = $SQLServerInstance
                DatabaseName = $RTMDatabaseName
            }
            Import-FobOrTxtFile @importTxtParam

            Write-Log "Compile txt file"
            $compileParam = @{
                DatabaseName = $RTMDatabaseName
                SQLServerInstance = $SQLServerInstance
            }
            Invoke-NAVCompile @compileParam

            # TODO: check export and compile log
        }

        It "Export txt file from Dynamcis$Version with $Language" {
            # TODO: export module and check points
        }
    }
}



# SIG # Begin signature block
# MIID2QYJKoZIhvcNAQcCoIIDyjCCA8YCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpRSwv977Q4011TDURLRiOtAt
# aMugggH+MIIB+jCCAWegAwIBAgIQQOxXfO4MQJNA8TDp2dgD4TAJBgUrDgMCHQUA
# MBExDzANBgNVBAMTBk5BVlJDTDAeFw0xNzEyMjcxMTUxMDlaFw0zOTEyMzEyMzU5
# NTlaMBExDzANBgNVBAMTBk5BVlJDTDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkC
# gYEA3m9qUEauUeJ/ssE6Y7ArtMkGvc7ihxfhjLKMuOHDpKfupos436Dh632IHVrD
# PxfbbkDZ4taLvVjDPXjaClBTlxsTeUI4bIlymFnlx8OYhd1lVyKYMa6ffE9yXpE2
# /xHaDp819LyfkBMl1b/oV1ZTSjM6uPBCPmyDuzWXve2aXRECAwEAAaNbMFkwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwQgYDVR0BBDswOYAQXxZRqoiFJtrDIudJq6L9+KET
# MBExDzANBgNVBAMTBk5BVlJDTIIQQOxXfO4MQJNA8TDp2dgD4TAJBgUrDgMCHQUA
# A4GBAFeNJDlB48Kf7Yhndhnre5wFLT/D8XB/YKJ+RBQqoY1UBjJX4KsHADhVyd8A
# kI2j9X83VBXmuU5Sf0GoS9TbAlBfjyNG5AtoTC3/4Ann/eyqBSlZDUyu+hcV+Jqu
# uoa9lvMUzuFszC5n3zvpyfNbXHW0RPXRq7Hbb/B92d3paJU7MYIBRTCCAUECAQEw
# JTARMQ8wDQYDVQQDEwZOQVZSQ0wCEEDsV3zuDECTQPEw6dnYA+EwCQYFKw4DAhoF
# AKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcN
# AQkEMRYEFNkyvjEb4iLfO/MwfzBXSOqYdhntMA0GCSqGSIb3DQEBAQUABIGAY+ur
# 9tSxu3ig4p/xxgcEV1tFrhw0KDOYYMslLoQwssYIvGJRVSGOmMorKUU0iafT26RC
# 0vaAT6Cui/0jLOrracgP2Eg+iYQfOjlOOyUVeRxTWGic5IYLwFX5a99AMDnALkXC
# 4NkiksI8Zj3F/CeDsMZeaMU9opwlvmJWvi0Kyc8=
# SIG # End signature block