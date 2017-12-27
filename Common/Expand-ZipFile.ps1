<#
.SYNOPSIS
    Unzip zip files
.DESCRIPTION
    Unzip zip files
#>

Function Expand-ZipFile
{
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $zipfile,

        [Parameter(Mandatory=$true)]
        [string]
        $outpath
    )
    
    process{
        
        Add-Type -AssemblyName System.IO.Compression.FileSystem 

        if (Test-Path $outpath)
        {
            Get-ChildItem -Path $outpath -Recurse | Remove-Item -Force -Recurse
        }
    
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    }
}

Export-ModuleMember -Function Expand-ZipFile

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpS8SDYrKecMEfNPi/Q7JjEyo
# KVCgggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFGLx5jMz
# +sdWh67qUPxEipGufW+2MA0GCSqGSIb3DQEBAQUABIGAAncNQG8GRKZkQ9SbayoG
# Nk7z5+3JcRE92JkDwaLnsIbXhxkEd1tyb/Xj71Zbf75+NAgZhGHZbd+6DqshgX6r
# OyDUjo9wp/wIYHDrx/Q0W31Bi2DSthCOhln8hnXQxqtLuwhGYpcVsZV/MvGXZPNL
# EO7L6IjouHCRjyQX5Whe8Zc=
# SIG # End signature block
