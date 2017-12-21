function Invoke-NavSetup {
    <#
    .SYNOPSIS
    Invoke setup.exe Dynamics NAV installer
    
    .DESCRIPTION
    Invokes the setup.exe Dynamics NAV installer with specified configuration file
    
    .EXAMPLE
    Invoke-NavSetup -Path  -ConfigFilePath -LogPath
    You must be an administrator to run the installation.
    
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ConfigFilePath = (Join-Path $PSScriptRoot "Data"),

        [Parameter(Mandatory = $true)]
        [string]
        $LogPath
    )
    Process 
    {
        if ($PSCmdlet.ShouldProcess("ShouldProcess Invoke-NavSetup") -eq $false)
        {
            return
        }

        [string]$navSetupExe = Join-Path $Path "Setup.exe"
        Write-Log "Looking  for Nav setup.exe in $Path"
        if ((Test-Path -PathType Leaf $navSetupExe) -eq $false) 
        {
            $Message = "Setup.exe cannot be found in directory '$Path'!"
            Write-Log $Message
            Throw $Message
        }
        
        [string]$ConfigFile = Join-Path $ConfigFilePath "Install-NavConfigTemplate.xml"
        Write-Log "Looking  for NAV configuration file in $ConfigFile"
        if ((Test-Path -PathType Leaf $ConfigFile) -eq $false) 
        {
            $Message = "NAV configuration file cannot be found in directory '$Path'!"
            Write-Log $Message
            Throw $Message
        }

        [string]$logFile = (Join-Path $LogPath  "Install-NAV.log")
        [int]$i = 0
        while (Test-Path -PathType Leaf $logFile) {
            [int]$i = $i + 1
            $logFile = (Join-Path $env:Temp  "Install-NAV$i.log")
        }

        [string]$argumentList = "-quiet -config `"$ConfigFile`" -log `"$logFile`""

        Write-Log "Running Setup.exe to install NAV.."
        Invoke-ProcessWithProgress -FilePath $navSetupExe -ArgumentList $argumentList -TimeOutSeconds 6000
        
        Write-Log "Searching the log file for 'Error'"
        [int]$errorCount = @(Select-String -Path $logFile -Pattern "Error:").Count
        if ($errorCount -ne 0) 
        {
            $Message = "The setup program failed: $navSetupExe. More details can be found in the log file located on the target machine: $logFile."
            Write-Log $Message
            Throw $Message
        }
    }
}

Export-ModuleMember -Function Invoke-NavSetup
# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHGPJwsSSc47kqmGNmjIjyV9K
# zregggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFNk+g02M
# LNtHethlHc0wCtU5NGApMA0GCSqGSIb3DQEBAQUABIGAnzw0bcf85V1Mi5q+s/0P
# KfJzwicLj2NP2AeWrS46kT2rfyD8t8jbybqvdjDizwBGHdnfrBo/xVY3DqU6Du40
# X5apepHEk/vn/hYjI9ytO5pNvOtErWKzJ950gvmubteA7M49lfJ7/lr0IrpmLl6R
# zfFKmnrfz0b6XVjgvhOHWpE=
# SIG # End signature block
