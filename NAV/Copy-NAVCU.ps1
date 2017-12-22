Function Copy-NAVCU  {
    <#
    .SYNOPSIS
    Copy setup file from release build drop
    
    .DESCRIPTION
    \\vedfssrv01\DynNavFS\Releases\NAV\DynamicsNAV2016\Cumulative_Updates\2017-02\DE
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    Param(
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $BuildDropPath,

        [Parameter(Mandatory = $true)]
        [string]
        $BuildDate,

        [Parameter(Mandatory = $False)]
        [string]
        $BuildFlavor = "Cumulative_Updates",

        [Parameter(Mandatory = $true)]
        [string]
        $Language,

        [Parameter(Mandatory = $False)]
        [String]
        $Destination = (Join-Path $env:HOMEDRIVE "NAVWorking")
    )

    Process{

        Write-Log "Preparing $Destination directory..."
        if (-Not(Test-Path $Destination)) {
            if (-Not(Test-Path $Destination -IsValid)) {
                $Message = ("Destination path '{0}' is not valid!" -f $Destination)
                Write-Log $Message
                Throw $Message
            }

            Write-Log ("Destination path '{0}' does not exist - creating..." -f $Destination)
            $null = New-Item -ItemType Directory $Destination -Force
        }

        Write-Log "Preparing directory to extract files to..."
        $ExtractToPath  = Join-Path $Destination "Extracted"
        if(Test-Path $ExtractToPath)
        {
            Write-Log "$ExtractToPath exists. Deleting..."
            Remove-Item $ExtractToPath -Force -Recurse
        }

        $Null = New-Item -ItemType Directory -Path $ExtractToPath -Force

        Write-Log "Looking for $BuildDropPath..."
        If (-Not (Test-Path -PathType Container $BuildDropPath))
        {
            $Message = ("Build drop path '{0}' cannot be found!" -f $BuildDropPath)
            Write-Log $Message
            Throw $Message
        }

        $BuildFlavorPath = Join-Path $BuildDropPath $BuildFlavor

        if (-Not ([String]::IsNullOrEmpty($BuildDate)))
        {
            $BuildDatePath = Join-Path $BuildFlavorPath $BuildDate
            Write-Log "Looking for $BuildDatePath..."
            if(Test-Path -PathType Container $BuildDatePath)
            {
                $BuildDropPath = $BuildDatePath
            }
            else 
            {

                Write-Log ("Build Date '{0}' in build drop path '{1}' cannot be found! Assuming that it is already included..." -f $BuildDate, $BuildDropPath)
            }
        }

        if (-Not ([String]::IsNullOrEmpty($Language)))
        {
            $BuildDropPath = Join-Path $BuildDropPath $Language
            Write-Log "Looking for $BuildDropPath..."
            if(-Not(Test-Path -PathType Container $BuildDropPath))
            {
                $Message = ("Build Language '{0}' cannot be found for the build in path '{1}'!" -f $Language, $BuildDropPath)
                Write-Log $Message
                Throw $Message
            }
        }

        Push-Location $BuildDropPath
        $BuilPackge = Get-ChildItem * | where { $_.Name -match ".*NAV.*\.zip"}
        Pop-Location

        if($BuilPackge -eq $null)
        {
            $Message = ("Could not find any build package in path '{0}'!" -f $BuildDropPath)
            Write-Log $Message
            Throw $Message
        }
        
        Write-Log ("Found build package {0}." -f $BuilPackge.FullName)

        $FileSize = $BuilPackge.Length / 1024 / 1024
        Write-Log ("Copying file {0} ({1:F2} MB) to {2}..." -f $BuilPackge.Name, $FileSize, $Destination)
        Try
        {
            $BuilPackge = Copy-Item -Path $BuilPackge.FullName -Destination $Destination -Force -PassThru
        }
        Catch
        {
            $Message = ("Copy failed! Error message: {0}" -f $_.Message)
            Write-Log $Message
            Throw $Message
        }

        Push-Location $Destination
        Expand-ZipFile -zipfile $BuilPackge.FullName -outpath $ExtractToPath
        Pop-Location

        $ExtractToDVDPath = Join-Path $ExtractToPath "DVD"

        Push-Location $ExtractToPath
        $BuilDVDPackge = Get-ChildItem * | where { $_.Name -match ".*DVD.*\.zip"}
        if($BuilDVDPackge -eq $null)
        {
            $Message = ("Could not find any DVD package in path '{0}'!" -f $ExtractToPath)
            Write-Log $Message
            Throw $Message
        }
        else 
        {
            $null = New-Item -ItemType Directory -Path $ExtractToDVDPath -Force
        }
        
        Expand-ZipFile -zipfile $BuilDVDPackge.FullName -outpath $ExtractToDVDPath
        Pop-Location

        Push-Location $ExtractToDVDPath

        If(-Not (Test-Path (Join-Path $ExtractToDVDPath "Setup.exe")))
        {
            $Message = ("Could not find Setup.exe in path '{0}'!" -f $ExtractToDVDPath)
            Write-Log $Message
            Throw $Message
        }
        Pop-Location

        Return $ExtractToDVDPath
    }
}

Export-ModuleMember -Function Copy-NAVCU

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUi9XBwtW1d7Mug3hhdVs+wF2m
# HpygggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFFtA2zXr
# jvMbNiD8QLipjs6rtN2UMA0GCSqGSIb3DQEBAQUABIGAP1t4uC7gcg63Mv+G7b8U
# Rd+5x9bPHK0GcEv0Topy3u1s2NpddJQ6ckjVR2txhw8LeogpvjsaKcPQVHjC+Ey3
# 25IlVIpdsPFTWp2vm0iN2sLh31Gr1EoqCMUMt/QeAP1bJ/unSNv3S92ZZuy82MR9
# 7OnpiNEB1TJ8VbVjcO7fzO0=
# SIG # End signature block
