<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ServiceName
Parameter description

.PARAMETER RetryCount
Parameter description

.PARAMETER WaitTimeout
Parameter description

.PARAMETER LogPath
Parameter description

.EXAMPLE
Start-NavServer -ServiceName "DynamicsNAV" -LogPath "C:\NAVWorking"

.NOTES
General notes
#>
function Start-NavServer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [String]
		$ServiceName = "*DynamicsNAV*",

        [Parameter(Mandatory = $false)]
        [String]
        $LogPath = (Join-Path $env:HOMEDRIVE "NAVWorking")
    )
    process {

        $LogPath = Join-Path $LogPath "Logs"
        if(-Not(Test-Path $LogPath))
        {
            $null = New-Item -ItemType Directory -Path $LogPath -Force
        }

        Write-Log "Sart NAV Server"
        Get-Service "MicrosoftDynamicsNavServer*" | Where-Object { $.Status -eq "Stopped"} | Restart-Service -ErrorAction SilentlyContinue
    }
}

Export-ModuleMember -Function Start-NavServer

# Optional commands to create a public alias for the function
New-Alias -Name StartServer -Value Start-NavServer
Export-ModuleMember -Alias StartServer
# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUhXzVBPGaRIz07nSdbGIuJZir
# A8agggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFACCXH7P
# fSiPTxhd7lzC42eAXGu/MA0GCSqGSIb3DQEBAQUABIGAoAKz6gXK9IL6FZOPg2mF
# eLYJzoziis5QYjgMuoDgKs9obSXGMMh9nx8NyeStMtNP69kK5t/KcYpn+DjxDGwx
# /E29daSnX5WL79+qPbHDxbzJd6JO/EFExlg9NgzsRduLo/gl7AfQc9IbBrzyeubD
# gh2OvSOLoCjr6Mz4sF3JPlU=
# SIG # End signature block
