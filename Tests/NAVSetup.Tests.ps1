param(
    # Product Version such NAV2015, NAV2018, NAV2016
    [Parameter(Mandatory = $true)]
    [string]
    $Version,

    [Parameter(Mandatory = $true)]
    [string]
    $Language
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
    Describe "Setup for $ProductVersion" {
        BeforeEach { 
            Uninstall-NAVAll
        }
        
        It "$Language" {
    
            $paramDE = @{
                Version = $Version
                Language = $Language
            }
    
            Install-NAV @paramDE | Should Be 1  
        }

        AfterEach {
            #Uninstall-NAVAll
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