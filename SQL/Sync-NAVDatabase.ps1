function Sync-NAVDatabase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $NAVServerInstance,

        [Parameter(Mandatory = $false)]
        [string]
        $Mode = "ForceSync"
    )
    process{
        try{
            Write-Log "Force Synchronize the NAV database "
            if ((Get-NAVServerInstance $NAVServerInstance) -eq $null)
            {
                Write-Error "The Microsoft Dynamics NAV Server instance $NAVServerInstance does not exist."
                return
            }

            Sync-NAVTenant -ServerInstance $NAVServerInstance -Mode $Mode -Force
        }
        catch{
            Write-Exception $_.Exception
        }
    }
}

Export-ModuleMember -Function Sync-NAVDatabase

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUYyjU6oJOQptfai2Q07jBVj/o
# 8UGgggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFN5MF2z4
# C6h0P9JfRqepOgpS0vPIMA0GCSqGSIb3DQEBAQUABIGAh0BHNF+B/nCneyWPNE/O
# nHrA+SF5SwT2O0LPY6g1xateGzqyBcPWy1afOJ9tt55XcFvlA60YLcgnp4aRV5zG
# tVE/dvDmXBGX4fzW+TzO8+3PUBVhxXsqZ3RuggEAIJvc/0JISrO7oZOQggeR7iMf
# z6XgHNzAQx+I4m0zcxlDYtY=
# SIG # End signature block
