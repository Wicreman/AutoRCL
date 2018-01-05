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



#Set-UnitTestEnviorment


InModuleScope -ModuleName $NAVRclApi {

    $ShortVersionMap = @{
        NAV2018 = "110"
        NAV2017 = "100"
        NAV2016 = "90"
        NAV2015 = "80"
        NAV2013R2 = "71"
        NAV2013 = "70"
    }
    
    $LanguageTranslationMap = @{
        AT = "DEA"
        AU = "ENA"
        BE = "FRB", "NLB"
        CH = "DES", "ITS", "FRS"
        CZ = "CSY"
        DE = "DEU"
        DK = "DAN"
        ES = "ESP"
        FI = "FIN"
        FR = "FRA"
        GB = "ENG"
        IS = "ISL"
        IT = "ITA"
        NA = "ESM", "FRC", "ENC"
        NL = "NLD"
        NO = "NOR"
        NZ = "ENZ"
        RU = "RUS"
        SE = "SVE"
        W1 = "ENU"
    }
    
    $SQLServerInstance = "$DatabaseServer`\$DatabaseInstance"
    
    
    $LogPath = Join-Path $env:HOMEDRIVE "NAVWorking\Logs"
    $ExpectedCommandLog = "The command completed successfully"
    
    if($Version -ne "NAV2015")
    {
        $ProductVersion = "Dynamics$Version"
    }
    $demoDataPath = (Join-Path $env:HOMEDRIVE "NAVWorking\$ProductVersion\$Language\Extracted\APPLICATION")

    Describe "Clean NAV test environment" -Tag "CleanEnvironment" {
        BeforeEach {
            Import-SqlPsModule
        }

        # Given: Dynamics$Version with $Language
        It "Prepare test environment for Dynamics$Version with $Language" {
            
            # When: Uninstall all NAV components and drop NAV database
            Uninstall-NAVAll
            $uninstallLogName = "UninstAllNAV.log"
            $uninstallLog = Join-Path $LogPath $uninstallLogName
            if(Test-Path $uninstallLog)
            {
                # Then: Uninstall Successfully
                $expectedInformation = "Removal failed"
                #$uninstallLog | Should -Not -FileContentMatch $expectedInformation
            }

            #Remove all NAV related directory
            $NAVWorkingDir  = Join-Path $env:HOMEDRIVE "NAVWorking"
            if(Test-Path $NAVWorkingDir)
            {
                Write-Log "$NAVWorkingDir exists. Deleting..."
                & CMD /C rmdir /s /q $NAVWorkingDir
                if(Test-Path $NAVWorkingDir)
                {
                    Write-Log "$NAVWorkingDir exists.  Deleting Again.."
                    & CMD /C rmdir /s /q $NAVWorkingDir
                }
                #Get-ChildItem $NAVWorkingDir -Recurse | Remove-Item  -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false
                #Remove-Item $NAVWorkingDir -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$false
            }

            $NAVWorkingDir | Should -Not -Exist

            $NAVInstalledDir  = Join-Path $env:HOMEDRIVE "Microsoft Dynamics NAV"
            if(Test-Path $NAVInstalledDir)
            {
                Write-Log "$NAVInstalledDir exists. Deleting..."
                & CMD /C rmdir /s /q $NAVInstalledDir
                if(Test-Path $NAVInstalledDir)
                {
                    Write-Log "$NAVInstalledDir exists. Again Deleting..."
                    & CMD /C rmdir /s /q $NAVInstalledDir
                }
                #Get-ChildItem $NAVInstalledDir -Recurse | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false
                #Remove-Item $NAVInstalledDir -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$false
            }

            $NAVInstalledDir | Should -Not -Exist
        }
    }

    
    Describe "Install and configure Dynamics$Version" -Tag "NAVSetup" {

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

            Write-Log "Step 2: Install NAV by using setup.exe"   
            Write-Log "Running setup.exe to install $Version with $Language"
            Invoke-NavSetup -Path $LocalBuildPath -ShortVersion $ShortVersion
            
            $NavSetupLogName = "Install-NAV.log"
            $NavSetupLog = Join-Path $LogPath $NavSetupLogName
            $unexpectedSetupInfomation = "Error"
            $NavSetupLog | Should -Not -FileContentMatch $unexpectedSetupInfomation

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
            Stop-NAVServer -ServiceName $NAVServerInstance  
            Start-NavServer -ServiceName $NAVServerInstance
            
            Write-Log "Setp 9: Convert the database"  
            $convertDBParam = @{
                DatabaseServer = $DatabaseServer
                DatabaseInstance = $DatabaseInstance
                DatabaseName = $RTMDatabaseName
            }
            Stop-NAVServer -ServiceName $NAVServerInstance
            Convert-NAVDatabase @convertDBParam

            $convertDBLog = Join-Path $LogPath "Database Conversion\navcommandresult.txt" 
            $convertDBLog | Should -FileContentMatch $ExpectedCommandLog

            if ($Version -like "NAV2013*") {
                Write-Log "Setp 10: Copy required file for NST, RTC, Web Client"   
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
                Write-Log "Setp 10: Sync the database"   
                Sync-NAVDatabase -NAVServerInstance $NAVServerInstance
            }
            
            Write-Log "Setp 11: Update region format"  
            Update-RegionalFormat $Language

            Write-Log "Step 12: Import NAV License"    
            Import-NAVLicense -ShortVersion $ShortVersion

        }
    }

    Describe "Import and export process of FOB file" -Tag "UnitTestCase" {
        Context "Verify Fob file can be imported or exported successfully" {
            $shortVersion = $ShortVersionMap.$Version
            # Get NAV Server instance from short version
            $NAVServerInstance = "DynamicsNAV$ShortVersion"

            Import-NAVIdeModule -ShortVersion $shortVersion
            Find-NAVMgtModuleLoaded -ShortVersion $ShortVersion

            $RTMDatabaseName = "$RTMDatabaseName$shortVersion"
            
            It "Import fob file into Dynamcis$Version with $Language"  -Skip {
                
                $importFobParam = @{
                    Path = $fobPackge.FullName
                    SQLServerInstance = $SQLServerInstance
                    DatabaseName = $RTMDatabaseName
                    NavServerInstance = $NAVServerInstance
                    FileType = "Fob"
                }
                Import-FobOrTxtFile @importFobParam 

                Sync-NAVDatabase -NAVServerInstance $NAVServerInstance
    
                $importFobLog = Join-Path $LogPath "ImportFobOrTxt\Fob\navcommandresult.txt"
                $importFobLog | Should -FileContentMatch $ExpectedCommandLog


            }
    
            It "Export txt file from Dynamcis$Version with $Language" {
                $expectedTxtPackge = Get-ChildItem $demoDataPath | Where-Object { $_.Name -match ".*$Language.CUObjects\.txt"}
                $actualTxtPackge = Export-FobOrTxtFile -ShortVersion $ShortVersionMap.$Version -FileType "txt"
                $exportedTxtLog = Join-Path $LogPath "ExportFobOrTxt\txt\navcommandresult.txt"

                $exportedTxtLog | Should -FileContentMatch $ExpectedCommandLog
                # Assert
                $actualTxt = (Get-FileHash $actualTxtPackge[0]).hash
                $expectedTxt = (Get-FileHash  $expectedTxtPackge.FullName).hash
                ($actualTxt -eq $expectedTxt) | Should -Be $true
            }

            It "Export fob file from Dynamcis$Version with $Language" {
                $expectedFobPackage = Get-ChildItem $demoDataPath | Where-Object { $_.Name -match ".*$Language.CUObjects\.fob"}
                $expectedFob = (Get-FileHash $expectedFobPackage.FullName).hash
                $actualFobPackage = Export-FobOrTxtFile -ShortVersion $ShortVersionMap.$Version
                $exportedLog = Join-Path $LogPath "ExportFobOrTxt\fob\navcommandresult.txt"

                $exportedLog | Should -FileContentMatch $ExpectedCommandLog
                # Assert
                $actualFob = (Get-FileHash $actualFobPackage[0]).hash

                ($actualFob -eq $expectedFob) | Should -Be $true
            }
        }
        
    }

    Describe "Import process of TXT file" -Tag "UnitTestCase" {
        Context "Verify Txt file can be imported successfully" {
            $shortVersion = $ShortVersionMap.$Version

            Import-NAVIdeModule -ShortVersion $shortVersion
            Find-NAVMgtModuleLoaded -ShortVersion $ShortVersion


            Push-Location $demoDataPath
            $txtPackge = Get-ChildItem * | Where-Object { $_.Name -match ".*$Language.CUObjects\.txt"}
            Pop-Location
            $RTMDatabaseName = "$RTMDatabaseName$shortVersion"
            It "Import txt file into Dynamcis$Version with $Language" {
                
                $importTxtParam = @{
                    Path = $txtPackge.FullName
                    SQLServerInstance = $SQLServerInstance
                    NavServerInstance = "DynamicsNAV$shortVersion"
                    DatabaseName = $RTMDatabaseName
                    FileType = "Txt"
                }
                Import-FobOrTxtFile @importTxtParam

                $importTxtLog = Join-Path $LogPath "ImportFobOrTxt\Txt\navcommandresult.txt"
                $importTxtLog | Should -FileContentMatch $ExpectedCommandLog

                Write-Log "Compile txt file"
                $compileParam = @{
                    DatabaseName = $RTMDatabaseName
                    SQLServerInstance = $SQLServerInstance
                }
                Invoke-NAVCompile @compileParam

                $compiledLog = Join-Path $LogPath "Compile\navcommandresult.txt"
                $compiledLog | Should -FileContentMatchExactly $ExpectedCommandLog
            }
        }
    }

    Describe "Validate objects translation" -Tag "UnitTestCase" {
        $languageNames = $LanguageTranslationMap.$language
        $shortVersion = $ShortVersionMap.$Version
        Import-NAVIdeModule -ShortVersion $shortVersion -Verbose
        
        It "Test all $languageNames captions are all present" {
            if($language -ne "W1")
            {
                Push-Location $demoDataPath
                $txtPackge = Get-ChildItem * | Where-Object { $_.Name -match ".*$Language.CUObjects\.txt"}
                Pop-Location
    
                $languageIds = $LanguageTranslationMap.$language

                $translationParam = @{
                    Source = $txtPackge.FullName
                    LanguageId = $languageIds
                }
                $translationResult = Test-NAVApplicationObjectLanguage @translationParam  -PassThru -ErrorAction Stop
                if($translationResult)
                {
                    foreach($result in $translationResult)
                    {
                        $message = "Caption in $languageNames are missing ----- ObjectType:"+ $result.ObjectType + "  Id:" + $result.Id + " LCID:" + $result.LCID 
                        Write-Log $message -ForegroundColor "Red"
                    }
                }
                $translationResult | Should -BeNullOrEmpty
            }           
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