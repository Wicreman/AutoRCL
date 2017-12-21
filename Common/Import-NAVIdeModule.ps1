function Import-NAVIdeModule{
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
   ModulePaht C:\Program Files (x86)\Microsoft Dynamics NAV\100\RoleTailored Client\

    .PARAMETER ShortVersion
    90, 110, ...

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ShortVersion
    )

    process{

        $registryKeyPath = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Microsoft Dynamics NAV\$ShortVersion\RoleTailored Client"
        $registryKey = Get-ItemProperty -Path $registryKeyPath -ErrorAction SilentlyContinue
        if($registryKey)
        {
            $ModulePath = $registryKey.Path

            if(-Not(Test-Path (Join-Path $ModulePath "Microsoft.Dynamics.Nav.Ide.psm1") ))
            {
                $Message = ("Could not find Microsoft.Dynamics.Nav.Ide.psm1 in path '{0}'!" -f $ModulePath)
                Write-Log $Message
                Throw $Message
            }
    
            if(-Not(Test-Path (Join-Path $ModulePath "finsql.exe") ))
            {
                $Message = ("Could not find finsql.exe in path '{0}'!" -f $ModulePath)
                Write-Log $Message
                Throw $Message
            }
    
            $ModulePath = [System.Environment]::ExpandEnvironmentVariables($ModulePath)
            $IdePath = Join-Path $ModulePath "Microsoft.Dynamics.Nav.Ide.psm1" -ErrorAction SilentlyContinue
            $FinSQLFile = Join-Path $ModulePath "finsql.exe" -ErrorAction SilentlyContinue
    
            Import-Module $IdePath -Global -Arg $FinSQLFile -ErrorVariable errorVariable -ErrorAction Stop
    
            if (!$errorVariable)
            {
                Write-Verbose "The module was successfully imported from $ModulePath -Arg $FinSQLFile."
            }
        }

        
    }
}

Export-ModuleMember -Function  Import-NAVIdeModule

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXPFC7bLcR0FIoWY3OUMPX8ep
# fmegggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFA75YlA9
# yDuhYl+7deZn1VGBlkbcMA0GCSqGSIb3DQEBAQUABIGAEjcSt0jy9EmuPaEmnfct
# RfUBhS6fL/uB0ebZJ6m8wGcGR4LuSGcCUa6NYkuHnK7Zr+5ZRbismN+OBTKv0cm7
# b3NBbXbSi6W6DJJRJU9/ajpsh5SrkP/kLm3DmuwMVnIxoi1cuKIEc8nsTsbIKZwA
# RwhuW2i4cRePChiEXjZaTts=
# SIG # End signature block
