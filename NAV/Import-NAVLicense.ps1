function Import-NAVLicense {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ShortVersion,

        [Parameter(Mandatory = $false)]
        [string]
        $LicenseDatabase = "NavDatabase"
    )
    process{
        try
        {
            $NAVServerInstance = "DynamicsNAV$ShortVersion"
            Write-Log "Looking for NAV Server instance $NAVServerInstance"
            if ((Get-NAVServerInstance $NAVServerInstance) -eq $null)
            {
                Write-Error "The Microsoft Dynamics NAV Server instance $NAVServerInstance does not exist."
                return
            }
            [string]$LicenseFile = Join-Path $PSScriptRoot  "Data\NAVDemoLicense.flf"
            Write-Log "Looking  for NAV demo licence file in $LicenseFile"
            if ((Test-Path -PathType Leaf $LicenseFile) -eq $false) 
            {
                $Message = "NAV license file cannot be found in directory!"
                Write-Log $Message
                Throw $Message
            }
            Write-Log "Import the new version license into the application database, and restart the server in order for the license to be loaded"
            $licenseParam = @{
                ServerInstance = $NAVServerInstance
                LicenseFile = $LicenseFile
                Database = $LicenseDatabase
            }
            Start-NavServer -ServiceName $NAVServerInstance
            Import-NAVServerLicense @licenseParam
            Stop-NAVServer -ServiceName $NAVServerInstance
            Start-NavServer -ServiceName $NAVServerInstance
        }
        catch
        {
            Write-Exception $_.Exception
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }     
    }
}

Export-ModuleMember -Function Import-NAVLicense

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU0jCOx0t8WBP0lK8Uc8t+luGU
# CyegggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFKgoafJk
# DCyZKHo5rI4+gQijbaThMA0GCSqGSIb3DQEBAQUABIGAL0K+z/Tb6JwGdzjBdtQl
# bsBfNYloLKll79cBB5/XJ2qcpzpukizVzqEtOTOqMkRQnpEJg3CMTXFAKjasyxv3
# zzM7DsFNwISndZniiGzgdumC244JtMt8S+gunFBD2VHV5LMBDGpFNp8oUD4Pb23L
# DDiOsoA7pUORFS8Z5Tz2Bkc=
# SIG # End signature block
