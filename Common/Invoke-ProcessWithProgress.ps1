function Invoke-ProcessWithProgress
{
    [CmdletBinding()]
    param 
        (
            [parameter(Mandatory=$true)]
            [string] 
            $FilePath,
            [parameter(Mandatory=$true)]
            [string] 
            $ArgumentList,
            [parameter(Mandatory=$true)]
            [int] 
            $TimeOutSeconds
        )
    PROCESS 
    {
        try {

        $process = Start-Process `
            -FilePath $FilePath `
            -PassThru `
            -ErrorAction SilentlyContinue `
            -ArgumentList $ArgumentList

        $milliSecBetweenPolls = $TimeOutSeconds * 10
        $percent = 0;

        while (!$process.WaitForExit($milliSecBetweenPolls)) {
            $percent = $percent + 1;

            if ($percent -eq 100) {
                Stop-Process $process.Id -Force
                Write-Error "The setup program did not complete within the expected time, the setup was aborted."
                break
            }

            Write-Progress `
                -Activity "Installing..." `
                -PercentComplete $percent `
                -CurrentOperation "$percent% complete" `
                -Status "Please wait."
        }

        Write-Progress -Activity "Sucessfully installed NAV " -PercentComplete 100 -Status "Done."
        }
        catch {
            Write-Exception $_
        }
        
    }
}

Export-ModuleMember -Function  Invoke-ProcessWithProgress

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUg1gHvHeYEsGL+h0WSi1d/dCH
# b5mgggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFBRnsHjB
# pykXSbUm9V9PCoeyqNZEMA0GCSqGSIb3DQEBAQUABIGAjrl1wWTdGjFzyVUx+AO4
# xg8d6jXgLaxNsQPvCU8lrg48Lu7s4o7SFG9Jk7iKsS4OC6MWEI9iyes72AUSHfy4
# TKkCGvDBdt0djof5G/dJFXpwqSclojeuDdzqo00G21cY+S3/KaglSt6OXQOzk+Iq
# q3ILDEsho6niKNyi2rFXTRI=
# SIG # End signature block
