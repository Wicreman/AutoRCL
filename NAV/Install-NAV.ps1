function Install-NAV {
    <#
    .SYNOPSIS
    Install NAV 
    
    .DESCRIPTION
    1.
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>

    [cmdletbinding(SupportsShouldProcess=$true)]

    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $BuildDropPath,

        [Parameter(Mandatory = $true)]
        [string]
        $BuildDate,

        [Parameter(Mandatory = $true)]
        [string]
        $Language,

        [Parameter(Mandatory = $False)]
        [string]
        $BuildFlavor = "Cumulative_Updates"
    )

    Process {
        Write-Log "Copying setup files locally..."
        Try
        {
            $LocalBuildPath = Copy-NAVSetup`
                -BuildDropPath $BuildDropPath `
                -BuildDate $BuildDate `
                -Language $Language `
                -BuildFlavor $BuildFlavor
        }
        Catch
        {
            Write-Log "The Copy-NAVSetup function failed! See exception for more information."
            Throw $_
        }
        

        Write-Log "Running setup.exe to install NAV..."
        Try
        {
            Invoke-NavSetup `
                -Path $LocalBuildPath `
                -LogPath (Join-Path $env:HOMEDRIVE "NAVWorking")
        }
        Catch
        {
            Write-Log "The Run setup.exe failed! See exception for more information."
            Throw $_
        }

        Write-Log "Copy RTM Database to SQL backukp"
        # TODO: Copy-RTM-DB
        try {
            
        }
        catch {
            
        }
        Write-Log "Restore RTM Database"
        # TODO: Restore-RTM-DB

        Write-Log "Convert the Database"
        # TODO: Convert-DB

        Write-Log "Convert the Database"
        # TODO: Import-Fob

        Write-Log "Convert the Database"
        # TODO: Import-Txt
    }
}

Export-ModuleMember -Function Install-NAV

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGypyKtXrR9szb2nDka2Ef549
# 2tWgggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFM3Bah1F
# wkxHGak8PClJE73XQxRQMA0GCSqGSIb3DQEBAQUABIGAPkmDP/SoVvYB6A+PvHf2
# TNizRYh2ZakR9MF4er2tvVarPEbUA65ehx4z3lPtVbyGJsMDPCfXtMRtQLLyZOtL
# ekv5Dsgxmk2zFVe2I29puhLVLhCJ5eaTM6jtpLckpYRz6MOUgZKJBOFbirhEz+do
# pcg7Q6Tt3KCZfv3LlOQ47AA=
# SIG # End signature block