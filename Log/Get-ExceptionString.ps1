Function Get-ExceptionString
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [Exception]
        $Exception
    )
    
    Process
    {
        $ExceptionString = "Exception message:" + [Environment]::NewLine + $Exception.Message
        
        If ($Exception.StackTrace -Ne $Null)
        {
            $ExceptionString += "Stack trace:" + [Environment]::NewLine + $Exception.StackTrace
        }
        
        If ($Exception.InnerException -Ne $Null)
        {
            $ExceptionString += 
                [Environment]::NewLine + [Environment]::NewLine + `
                "Inner exception:" + [Environment]::NewLine + `
                (Get-ExceptionString $Exception.InnerException)
        }
        
        Return $ExceptionString
    }
}

Export-ModuleMember -Function Get-ExceptionString

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUCjXx63fOFiw/4uozn01B0aUL
# jvygggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFMuRdItm
# 286Z311oFIlHkkbofN0zMA0GCSqGSIb3DQEBAQUABIGAn2f3Zm/X+TXaoPhs9AAp
# 1L8klPbFrfZQaowXv6+FgwyT1CRukfqH0TcoSRrgJZTDUdq5CQPkcXtXIJ11GX8R
# 4KEHfoq+544tL/q1h6sl3kFNjxUeSHfbslsLyZ8Ew4Z/SkBQGH3u4Pa3HFeLBEMp
# ywcZ2sJuohDVM4Ww16n0WxE=
# SIG # End signature block
