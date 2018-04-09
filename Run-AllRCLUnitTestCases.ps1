
# Run Get-ExecutionPolicy. If it returns Restricted, 
# then run Set-ExecutionPolicy AllSigned 
# or Set-ExecutionPolicy Bypass -Scope Process.
$policy = Get-ExecutionPolicy 
if ($policy -eq "Restricted" -or $policy -eq "RemoteSigned")
{
    Set-ExecutionPolicy Bypass -Scope Process -Force
}

# Import NAV RCL API module
Get-module  -name "NAVRCLAPI" | Remove-Module
Import-Module (Join-Path $PSScriptRoot "NAVRCLAPI.psm1") -Verbose -Force

# Check if Pester is not installed, if no, we need to install it firstly
$PesterVersion = Get-Module -ListAvailable -Name "Pester" | Where-Object { $_.Version.Major -ge 4 }
if (-Not($PesterVersion))
{
    if ([System.Environment]::OSVersion.Version.Major -ge 10)
    {
        Install-Module Pester -Force -SkipPublisherCheck
    }
    else {
        (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression 
        Install-Module Pester
    }  
}

$reportPath = Join-Path $env:HOMEDRIVE "NAVReports"
if (-Not(Test-Path $reportPath)) {
    $null = New-Item -ItemType Directory $reportPath -Force
}
$reportFile = Join-Path $reportPath "RCLReport.xml"
$buildDate = "2018-4"
$versions = "NAV2018" 
$languages = "ES", "FI", "FR", "GB", "IS", "IT", "NA", "NL", "NO", "NZ", "RU", "SE", "W1"
 #, "ES", "FI", "FR", "GB","CH", "CZ", "DE", "DK", "ES", "FI", "FR", "GB", "IS", "IT", "NA", "NL", "NO", "NZ", "RU", "SE", "W1", "AT","AU", "BE"
# Please update your database intance name like NAVDEMO22, NAVDEMO33
$DatabaseInstance = "NAVDEMO"
$RTMDatabaseName = "NAVRTMDB"
$NAVServerServiceAccount = "NT AUTHORITY\NETWORK SERVICE"
$Tags = @{Clean = "CleanEnvironment";  Setup = "NAVSetup"; UTC = "UnitTestCase"}
$DatabaseServer = "localhost"

# Call invoke-pester to run all Unit Test cases
Set-Location $PSScriptRoot
$setupTestsPath = Join-Path $PSScriptRoot "Tests\RCL.Tests.ps1"

Write-Log "Start to batch run all unit test cases"
foreach($version in $versions)
{
    foreach($language in $languages)
    {
        # update the region format
        Update-RegionalFormat $language
        
        #run setup test cases
        Write-Log "Run NAV Setup test cases"
        $scriptParam = @{ 
            Path = $setupTestsPath
            Parameters = @{
                Version = $version 
                Language= $language
                DatabaseServer = $DatabaseServer
                DatabaseInstance = $DatabaseInstance
                RTMDatabaseName = $RTMDatabaseName
                NAVServerServiceAccount = $NAVServerServiceAccount
            } 
        }

        Write-Log  "Starting to clean NAV test environment"
        $cleanUTs = Invoke-Pester -Script $scriptParam -Tag $Tags.Clean -PassThru 
        Write-Log  "Successfully clean NAV test environment"

        if($cleanUTs.FailedCount -eq 0)
        {
            Write-Log  "Starting Install and configure Dynamics$Version"
            $reportFileSetup = Join-Path $reportPath "RCLReport-$Version-$language-Setup.xml"
            $failedUTs =  Invoke-Pester -PassThru -Script $scriptParam -Tag $Tags.Setup -OutputFile $reportFileSetup -OutputFormat NUnitXml

            if($failedUTs.FailedCount -gt 0){
                Write-Error "Fail to setup NAV for Dynamics$version with $language " -ErrorAction Stop
            }
            else {
                Write-Log  "Successfully Install and configure Dynamics$Version"
                Write-Log  "Starting to run case for Dynamics$version with $language"
                $reportFile = Join-Path $reportPath "RCLReport-$Version-$language.xml"
            
                Invoke-Pester -Script $scriptParam -Tag $Tags.UTC -OutputFile $reportFile -OutputFormat NUnitXml

                Write-Log "Completed to run case for Dynamics$version with $language "

                #Send email
                $reportParm = @{
                    ReportPath = $reportFile
                    Version = $version
                    Language= $language
                    BuildDate = $buildDate
                }
                Send-UnitTestResult @reportParm
            }
        }
        else
        {
            Write-Log "Clean NAV test environment for Dynamics$version with $language"
        }
        

    }
}
Write-Log "Completed to batch run all unit test cases"

# Generate HTML report by using tool ReportUnit
$reportUnitPath = Join-Path $PSScriptRoot "External"
Push-Location $reportUnitPath
& .\ReportUnit1-5.exe $reportPath
Pop-Location

# SIG # Begin signature block
# MIID2QYJKoZIhvcNAQcCoIIDyjCCA8YCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2n3e+432S45h7xKxa7Zlwssz
# +/mgggH+MIIB+jCCAWegAwIBAgIQQOxXfO4MQJNA8TDp2dgD4TAJBgUrDgMCHQUA
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
# AQkEMRYEFC2vKIChJv+nSgrJQ4h6m8++VkMjMA0GCSqGSIb3DQEBAQUABIGAZzLt
# g2t+s+8cHFqGsvIwxfCWLDMIaN73ZZaJIO3dBz2HLigM+CDGbH8l3N2zyFl2AxFB
# BJYpEE+ji/pAE/rW1xNbzHCb3hPTfc/oF5vzAp4pQJZdl7DUOtfXyoi+3eR4HN1r
# hR6r/ZMwK3oSOB6u+D735159WQnXwCT9tO5C8IE=
# SIG # End signature block