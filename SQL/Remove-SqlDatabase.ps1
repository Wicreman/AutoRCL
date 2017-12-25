function Remove-SqlDatabase  {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseServer = "localhost",

        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseInstance,

        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName
    )

    process{
        Try
        {
            Write-Log "Remove '$DatabaseName'" 
            # FIXME: incorrect database instance name

            $databaseLocation = "SQLSERVER:\SQL\$DatabaseServer\$DatabaseInstance\Databases\$DatabaseName"

            if(Get-Item $databaseLocation -ErrorAction SilentlyContinue)
            {
                Remove-SqlConnectionsToDatabase -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $DatabaseName
                Remove-Item $databaseLocation
            }
            else
            {
                Write-Error "Database '$DatabaseName' does not exist on SQL Server instance '$DatabaseServer\$SQLInstanceName'"
            }
        }
        Catch
        {
            Write-Error "Fail to remove $DatabaseName"
        }

    }
}

Export-ModuleMember -Function Remove-SqlDatabase

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUccD97PvXQIFO3VCitjrbMUcd
# VIGgggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFCafpTkO
# OToWc1TxEuOvPXBiu5emMA0GCSqGSIb3DQEBAQUABIGAi3VnaznsGd33H5MQDSmH
# O7qofU0wvjBZfJvU7nhOeaIiPk86Hr+SFzO1yCz7CrwkpBjVshQbs7ViFq/H4+0r
# Wu7cPkOfl1f3JL3rmu0phvOroPi+IIVvsiYWbkv9697RJT9KEx6DLZXT0n+ktD+h
# 9cPBDWhR5P1YrD1jvRLEVog=
# SIG # End signature block
