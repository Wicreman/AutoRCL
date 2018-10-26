
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
        Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
        choco install pester -Force
    }  
}

# Update the version, build date, language
$buildDate = "2018-4"
$version = "365" #"NAV2018", "NAV2016", "NAV2015", "NAV2013R2", "NAV2013", "NAV2018"
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

$reportPath = Join-Path $env:HOMEDRIVE "NAVReports"
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

    #Send email
    $reportParm = @{
        ReportPath = $reportFile
        Version = $version
        Language= $language
        BuildDate = $buildDate
    }
    Send-UnitTestResult @reportParm
}

#Generate HTML report by using tool ReportUnit
$reportUnitPath = Join-Path $PSScriptRoot "External"
Push-Location $reportUnitPath
& .\ReportUnit1-5.exe $reportPath
Pop-Location

# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpRSwv977Q4011TDURLRiOtAt
# aMugggINMIICCTCCAXagAwIBAgIQqWHUCc2qlYRIhWgVfe9FeDAJBgUrDgMCHQUA
# MBYxFDASBgNVBAMTC05BVlRvb2wyMDE4MB4XDTE4MDkyNzA1MTU1MloXDTM5MTIz
# MTIzNTk1OVowFjEUMBIGA1UEAxMLTkFWVG9vbDIwMTgwgZ8wDQYJKoZIhvcNAQEB
# BQADgY0AMIGJAoGBAJZ2F7ujZeaqFKfQFcGJV5TrkkaIkVUOzXB5s8M8nn+S/lFq
# 9UqOb5wN8LGDLvXh4N09tTEuH0QWRzyObGjVTmhj9GoMVOGvA1GqEo8AINaEVDJM
# 8HTbc/bGIsU7fyQGWQC6xsn/fdPAjBRN8EtL01zAFazHDRNK8di9punI0xN1AgMB
# AAGjYDBeMBMGA1UdJQQMMAoGCCsGAQUFBwMDMEcGA1UdAQRAMD6AEFKLZpIxPZgC
# 01AIS3DKkUKhGDAWMRQwEgYDVQQDEwtOQVZUb29sMjAxOIIQqWHUCc2qlYRIhWgV
# fe9FeDAJBgUrDgMCHQUAA4GBAISM3Wm5pn7XxkEYOW5a3qFOh51xh75/nREYeVgu
# jQpRzYzEW6aFcyDHwYtrrUlrv2wW1isaRR8S02Q44hmgn8jCG3a7NAsE04CNO93k
# k7RvTqI7hqRcmNoCHn+C1G2KiC4knMrvADOkKKAHdGI92XkXoovXQHVya1UffIoL
# at7mMYIBSjCCAUYCAQEwKjAWMRQwEgYDVQQDEwtOQVZUb29sMjAxOAIQqWHUCc2q
# lYRIhWgVfe9FeDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKA
# ADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYK
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU2TK+MRviIt878zB/MFdI6ph2Ge0w
# DQYJKoZIhvcNAQEBBQAEgYBHGIXb6q9BXguAdKLfeQSNLvaASlDeXkenR4+9XxGo
# cXT8O3B4C7k5BPcIfrv69DsiQmzEavblmr+vjq6YZAa14X28ah3iIauRw6NMJPkF
# MKmjkOuuuP4nKYEDP1lyQb53UtUJbWUyBqC1XoR/XUFvpQ2eqN1HLEeH3tVhLYPs
# xw==
# SIG # End signature block