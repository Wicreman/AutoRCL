<#
.SYNOPSIS
    write log informaiton
.DESCRIPTION
    write log information with timestamp
#>

Function Write-Log
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [String]
        $Message,

        [Parameter(Mandatory = $false)]
        [String]
        $ForegroundColor = "DarkYellow",

        [Parameter(Mandatory = $false)]
        [String]
        $DeployLogPath = "Join-Path $env:HOMEDRIVE "Deploy")"
    )
    
    Process
    {
        $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
        $MessageWithDate = "{0}: {1}" -f $Stamp, $Message
        if (-Not(Test-Path $DeployLogPath)) {
            $null = New-Item -ItemType Directory $DeployLogPath -Force
        }
        $DeployLog = Join-Path $DeployLogPath "DeployLog.log"
        if (-Not(Test-Path $DeployLog))
        {
            $Null = New-Item -ItemType File -Path $DeployLog -Force
        }
        
        Add-Content $DeployLog -Force -Encoding UTF8
        
        #Write-Host $MessageWithDate -ForegroundColor $ForegroundColor
    }
}

Export-ModuleMember -Function Write-Log

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU++yJfMQpvD12H3zWJwyT2myP
# 4iOgggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFKqjoAfx
# jXqyUuJAjSlmRUnUltELMA0GCSqGSIb3DQEBAQUABIGAOMDnkQFHlklbKrWk8crB
# K5Rccz/eZeDZgh0J0Ii+XADiCIy9XEkMPJja04s8W7e4vTfHHORXuSFrwR4S9XWh
# 3RVW/bcMGTSLjKsp7WgORLKfASuG0wi8ergIoOQX832hMRJqByIGFh8CpDOXGf/w
# q4n/Ax0WYjaIpIwRTdppObc=
# SIG # End signature block
