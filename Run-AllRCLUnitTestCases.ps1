
# Run Get-ExecutionPolicy. If it returns Restricted, 
# then run Set-ExecutionPolicy AllSigned 
# or Set-ExecutionPolicy Bypass -Scope Process.
$policy = Get-ExecutionPolicy 
if ($policy -eq "Restricted")
{
    Set-ExecutionPolicy Bypass -Scope Process -Force
}

# Import NAV RCL API module
Get-module  -name "NAVRCLAPI" | Remove-Module
Import-Module (Join-Path $PSScriptRoot "NAVRCLAPI.psm1") -Verbose -Force

# Check if Pester is not installed, if no, we need to install it firstly
if(-Not(Get-Module -ListAvailable -Name "Pester"))
{
    (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression 
    Install-Module Pester 
}

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