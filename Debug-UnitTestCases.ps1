
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
Import-Module (Join-Path $PSScriptRoot "NAVRCLAPI.psm1") -Force

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

# Update the version, build date, language
$buildDate = "2018-4"
$version = "NAV2018"#, "NAV2016", "NAV2015", "NAV2013R2", "NAV2013", "NAV2018"
$language = "DK"#, "AT", "BE", "CH", "CZ", "DE", "DK", "ES", "FI", "FR", "GB", "IS", "IT", "NA", "NL", "NO", "NZ", "RU", "SE", "W1"

# Please update your database intance name like NAVDEMO22, NAVDEMO33
$DatabaseInstance = "NAVDEMO"

# debug parameter
$debugClean = $false
$debugSetup = $false
$debugFob = $false
$debugTxt = $false
$debugTranslation = $false
$debugAll = $false

$reportPath = Join-Path $env:HOMEDRIVE "NAVDebugReports"
if (-Not(Test-Path $reportPath)) {
    $null = New-Item -ItemType Directory $reportPath -Force
}
$reportFile = Join-Path $reportPath "RCLReport.xml"

$RTMDatabaseName = "NAVRTMDB"
$NAVServerServiceAccount = "NT AUTHORITY\NETWORK SERVICE"
$Tags = @{Clean = "CleanEnvironment";  Setup = "NAVSetup"; UTC = "UnitTestCase"}
$DatabaseServer = "localhost"

# Call invoke-pester to run all Unit Test cases
Set-Location $PSScriptRoot
$setupTestsPath = Join-Path $PSScriptRoot "Tests\RCL.Tests.ps1"

Write-Log "Debug UTC"
#run setup test cases
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

# update the region format
Update-RegionalFormat $language
# Starting to clean NAV test environment
if ($debugClean) {
    Invoke-Pester -Script $scriptParam -Tag $Tags.Clean -PassThru
}

# Starting Install and configure
if ($debugSetup) {
    Invoke-Pester -PassThru -Script $scriptParam -Tag $Tags.Setup
}

$reportFile = Join-Path $reportPath "RCLReport-$Version-$language.xml"

# UTC: Import and export process of FOB file
if ($debugFob) {
    $reportFileFob = Join-Path $reportPath "RCLReport-$Version-$language-Fob-debug.xml"
    Invoke-Pester -Script $scriptParam -Tag $Tags.UTC -TestName "FOB" -OutputFile $reportFileFob -OutputFormat NUnitXml
}

#Import process of TXT file
if ($debugTxt) {
    $reportFileTxt = Join-Path $reportPath "RCLReport-$Version-$language-Txt-debug.xml"
    Invoke-Pester -Script $scriptParam -Tag $Tags.UTC -TestName "TXT" -OutputFile $reportFileTxt -OutputFormat NUnitXml
}

# Validate objects translation
if ($debugTranslation) {
    $reportFileTranslation = Join-Path $reportPath "RCLReport-$Version-$language-Translation-debug.xml"
    Invoke-Pester -Script $scriptParam -Tag $Tags.UTC -TestName "Translation" -OutputFile $reportFileTranslation -OutputFormat NUnitXml
}

# All
if ($debugAll) {
    Invoke-Pester -Script $scriptParam -Tag $Tags.UTC -OutputFile $reportFile -OutputFormat NUnitXml
}

#Send email
$reportParm = @{
    ReportPath = $reportFile
    Version = $version
    Language= $language
    BuildDate = $buildDate
}
Send-UnitTestResult @reportParm

#Generate HTML report by using tool ReportUnit
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