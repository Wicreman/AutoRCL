
$NAVRclApi = "NAVRCLAPI"
Get-module  -name $NAVRclApi | Remove-Module
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) "NAVRCLAPI.psm1") -Verbose -Force

if(-Not(Get-Module -ListAvailable -Name "Pester"))
{
    (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression 
    Install-Module Pester 
}

InModuleScope -ModuleName $NAVRclApi {
    Describe "TestCasesFor146968 NAV2017" {

        $Version = "NAV2017"
        $BuildDate = "2018-01"
        BeforeEach { 
            Uninstall-NAVAll
        }
        
        It "DE" -test {
            #Update Regional Formart
            $language = "DE"
            Update-RegionalFormat -Language "de-DE"
    
            $paramDE = @{
                Version = $Version
                BuildDate = $buildDate
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
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfIWjTbAXd2zR7TVrIheDIWFO
# 6OygggH1MIIB8TCCAV6gAwIBAgIQXzmgd4HWBJtM+inKVx0UhDAJBgUrDgMCHQUA
# MA4xDDAKBgNVBAMTA25hdjAeFw0xNzEyMjIwNTI5MzBaFw0zOTEyMzEyMzU5NTla
# MA4xDDAKBgNVBAMTA25hdjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAqLuf
# pYPvuzFdbyl6pQhjk8/zCoF1ygEw6+hRkseKHXfWI7m6UbilXIpVXLx5Wwob+nw8
# XuEFPfoDEXbt2vqiK66euLxQhaQCI2Q3S2O3/cDwLrNglIztikB3kVSALIjOE4iS
# XFhVNp5O+YQglok26p+CaI3dUPt7Z968DSBtVUkCAwEAAaNYMFYwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwPwYDVR0BBDgwNoAQLppon05tRx+xRJW7RvDlzqEQMA4xDDAK
# BgNVBAMTA25hdoIQXzmgd4HWBJtM+inKVx0UhDAJBgUrDgMCHQUAA4GBACWy/Vv0
# Xsa5bZAiG2uRWKCyNcmq78zLx22xum+2BMczI/5G7+QzZfO7fNumxVzUNVIVGR0q
# uK+Z+nq+CO12Wm8sTBhjFnLfh3mVzgGqPKfw1GjCDsEragQg77vla7jWtAcir64Y
# iizE714eNtaO6tRAg7/sqrXC+anCUJjQK9ocMYIBQjCCAT4CAQEwIjAOMQwwCgYD
# VQQDEwNuYXYCEF85oHeB1gSbTPopylcdFIQwCQYFKw4DAhoFAKB4MBgGCisGAQQB
# gjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFEtUTyPQ
# nwWgltiBc/+qymIUgQqEMA0GCSqGSIb3DQEBAQUABIGAlzhh7ftgg9RfdEoZR1tH
# w8AAdp2TahLWvDDR0XQvsPY5FpXgWxdYVA59Rz2zVwb7+B+/gVkqdiBuBwY1/GG/
# uv+sON7fcFymbrSstnJA3dxX4rblJTJZlfbuANFbB8wzpq9ZlJRsC/QP8XMd70vQ
# Tcens6uCdak1dYRLGd6eZpY=
# SIG # End signature block