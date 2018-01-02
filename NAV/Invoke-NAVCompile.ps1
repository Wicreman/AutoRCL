function Invoke-NAVCompile{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName,

        [Parameter(Mandatory = $false)]
        [string]
        $SQLServerInstance = ".",

        [Parameter(Mandatory = $false)]
        [string]
        $LogPath = (Join-Path $env:HOMEDRIVE "NAVWorking\Logs")
    )
    process{
        try
        {
            $LogPath = Join-Path $LogPath "Compile"
            if(-Not(Test-Path $LogPath))
            {
                $null = New-Item -ItemType Directory -Path $LogPath -Force 
            }

            Compile-NAVApplicationObject `
                -DatabaseName $DatabaseName `
                -DatabaseServer $SQLServerInstance `
                -LogPath $LogPath
        }
        catch
        {
            Write-Exception $_.Exception
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
    
}

Export-ModuleMember -Function Invoke-NAVCompile -Cmdlet Invoke-NAVCompile

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnlTvnrmPdwdqn90wlSHEhdA9
# 6fagggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFH2VtK2y
# SIjRgPcGZotlrAKE4i9xMA0GCSqGSIb3DQEBAQUABIGAT3PRREurV17HJUGddcWl
# hnYvcGtdLv9zFQD4HUDzNfTFT1KoSF76BmpXy7E6x/U3yyWGjx4fNxzVNd0yQ3p2
# UX0l0SUki9akM9WYMZDra0w9PwCJFOQatM/DcwoUlZlHiFbw9eWSA4DkwIcRWccQ
# dELHupTef88P4d4nH8EIqqQ=
# SIG # End signature block
