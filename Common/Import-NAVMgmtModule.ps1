function Import-NAVMgmtModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ShortVersion
    )
    
    process {
        $registryKeyPath = "HKLM:\SOFTWARE\Microsoft\Microsoft Dynamics NAV\$ShortVersion\Service"
        $mgmtModuleName = "Microsoft.Dynamics.Nav.Management.dll"

        $registryKey = Get-ItemProperty -Path $registryKeyPath -ErrorAction SilentlyContinue

        if($registryKey)
        {
            $modulePath = $registryKey.Path
            $modulePath = [System.Environment]::ExpandEnvironmentVariables($modulePath)
            $mgmtModuleFilePath = Join-Path $modulePath $mgmtModuleName -ErrorAction SilentlyContinue
            Import-Module $mgmtModuleFilePath -Global -ErrorVariable errorVariable -ErrorAction SilentlyContinue
            if (!$errorVariable)
            {
                Write-Verbose "Module successfully imported from $mgmtModuleFilePath."
            }
        }
    }
}

Export-ModuleMember -Function Import-NAVManagementModule
# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfk4HEY60EBzhq3Jws6FOfryt
# 8segggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFBcFOG7w
# /0Q07SjSkLdDPc7T2vjwMA0GCSqGSIb3DQEBAQUABIGARkTpnohtPzNTA4gSOZOj
# C/gSs/IrucAEHjXnGXpD67h7/mDrLkZTU0VDu2YSYMFEQRgdjmQXFPQXMCBNerVO
# S3sx4/uc+aIBh2WN9nkuc5ZpXDU3ei/ZYWpuFNBQCIJKce7Ewz8HkYIsnxGrkUDw
# PglQESJdeulZTMfITaRvIcg=
# SIG # End signature block
