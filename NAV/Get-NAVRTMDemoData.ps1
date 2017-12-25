Function Get-NAVRTMDemoData  {
    <#
    .SYNOPSIS
    Copy NAV RTM file from release build drop
    
    .DESCRIPTION
    
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
        $Version,

        [Parameter(Mandatory = $true)]
        [string]
        $Language,

        [Parameter(Mandatory = $False)]
        [String]
        $Destination = (Join-Path $env:HOMEDRIVE "NAVWorking"),

        [Parameter(Mandatory = $False)]
        [String]
        $BuildDropPath = "\\vedfssrv01\DynNavFS\Releases\NAV\"
    )

    Process{

        if($Version -ne "NAV2015")
        {
            $Version = "Dynamics$Version"
        }
        
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

        $DestinationVersionLanguage = Join-Path $Destination "$Version\$Language"
        if (-Not(Test-Path $DestinationVersionLanguage)) {
            Write-Log ("Destination path '{0}' does not exist - creating..." -f $DestinationVersionLanguage)
            $null = New-Item -ItemType Directory $DestinationVersionLanguage -Force
        }

        Write-Log "Preparing directory for NAV RTM"
        $rtmPath  = Join-Path $DestinationVersionLanguage "RTM"
        if(Test-Path $ExtractToPath)
        {
            Write-Log "$ExtractToPath exists. Deleting..."
            Remove-Item $ExtractToPath -Force -Recurse
        }
        else {
            $Null = New-Item -ItemType Directory -Path $rtmPath -Force
        }

        Write-Log "Preparing directory  Extracted to..."
        $ExtractToPath  = Join-Path $rtmPath "Extracted"
        if(Test-Path $ExtractToPath)
        {
            Write-Log "$ExtractToPath exists. Deleting..."
            Remove-Item $ExtractToPath -Force -Recurse
        }
        else {
            $Null = New-Item -ItemType Directory -Path $ExtractToPath -Force
        }

        Write-Log "Looking for $BuildDropPath..."
        If (-Not (Test-Path -PathType Container $BuildDropPath))
        {
            $Message = ("Build drop path '{0}' cannot be found!" -f $BuildDropPath)
            Write-Log $Message
            Throw $Message
        }

        $BuildVersionPath = Join-Path $BuildDropPath $Version
        If (-Not (Test-Path -PathType Container $BuildVersionPath))
        {
            $Message = ("Build Version path '{0}' cannot be found!" -f $Version)
            Write-Log $Message
            Throw $Message
        }

        if (-Not ([String]::IsNullOrEmpty($Language)))
        {
            $languagePath = Join-Path $BuildVersionPath $Language

            if(Test-Path -PathType Container $languagePath)
            {
                $BuildVersionPath = $languagePath
            }
        }
        
        Push-Location $BuildVersionPath
        $BuilPackge = Get-ChildItem * | where { $_.Name -match ".*$Language.*\.zip"}
        Pop-Location

        if($BuilPackge -eq $null)
        {
            $Message = ("Could not find any build package in path '{0}'!" -f $BuildVersionPath)
            Write-Log $Message
            Throw $Message
        }
        
        Write-Log ("Found build package {0}." -f $BuilPackge.FullName)

        $FileSize = $BuilPackge.Length / 1024 / 1024
        Write-Log ("Copying file {0} ({1:F2} MB) to {2}..." -f $BuilPackge.Name, $FileSize, $rtmPath)
        Try
        {
            $BuilPackge = Copy-Item -Path $BuilPackge.FullName -Destination $rtmPath -Force -PassThru
        }
        Catch
        {
            $Message = ("Copy failed! Error message: {0}" -f $_.Message)
            Write-Log $Message
            Throw $Message
        }

        Push-Location $rtmPath
        Expand-ZipFile -zipfile $BuilPackge.FullName -outpath $ExtractToPath
        Pop-Location

        $demoDataPath = Join-Path $ExtractToPath "SQLDemoDatabase"

        Push-Location $demoDataPath
        $demoDataPackge = Get-ChildItem * -Recurse | where { $_.Name -match ".*NAV.*\.bak"}
        if($demoDataPackge -eq $null)
        {
            $Message = ("Could not find any RTM Demo data package in path '{0}'!" -f $demoDataPath)
            Write-Log $Message
            Throw $Message
        }
       
        Write-Log ("Found RTM demodata package {0}." -f $demoDataPackge.FullName)

        $FileSize = $demoDataPackge.Length / 1024 / 1024
        Write-Log ("Return {0} Demo data file  : {1}..." -f "Dynamics$Version", $demoDataPackge.Name)
        Return $demoDataPackge.FullName
    }
}

Export-ModuleMember -Function Get-NAVRTMDemoData

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfIWjTbAXd2zR7TVrIheDIWFO
# 6OygggH1MIIB8TCCAV6gAwIBAgIQXzmgd4HWBJtM+inKVx0UhDAJBgUrDgMCHQUA
# MA4xDDAKBgNVBAMTA25hdjAeFw0xNzEyMjIwNTI5MzBaFw0zOTEyMzEyMzU5NTla
# MA4xDDAKBgNVBAMTA25hdjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAqLuf
# pYPvuzFdbyl6pQhjk8/zCoF1ygEw6+hRkseKHXfWI7m6UbilXIpVXLx5Wwob+nw8
# XuEFPfoDEXbt2vqiK66euLxQhaQCI2Q3S2O3/cDwLrNglIztikB3kVSALIjOE4iS
# XFhVNp5O+YQglok26p+CaI3dUPt7Z968DSBtVUkCAwEAAaNYMFYwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwPwYDVR0BBDgwNoAQLppon05tRx+xRJW7RvDlzqEQMA4xDDAK
# BgNVBAMTA25hdoIQXzmgd4HWBJtM+inKVx0UhDAJBgUrDgMCHQUAA4GBACWy/Vv0
# Xsa5bZAiG2uRWKCyNcmq78zLx22xum+2BMczI/5G7+QzZfO7fNumxVzUNVIVGR0q
# uK+Z+nq+CO12Wm8sTBhjFnLfh3mVzgGqPKfw1GjCDsEragQg77vla7jWtAcir64Y
# iizE714eNtaO6tRAg7/sqrXC+anCUJjQK9ocMYIBQjCCAT4CAQEwIjAOMQwwCgYD
# VQQDEwNuYXYCEF85oHeB1gSbTPopylcdFIQwCQYFKw4DAhoFAKB4MBgGCisGAQQB
# gjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFEtUTyPQ
# nwWgltiBc/+qymIUgQqEMA0GCSqGSIb3DQEBAQUABIGAlzhh7ftgg9RfdEoZR1tH
# w8AAdp2TahLWvDDR0XQvsPY5FpXgWxdYVA59Rz2zVwb7+B+/gVkqdiBuBwY1/GG/
# uv+sON7fcFymbrSstnJA3dxX4rblJTJZlfbuANFbB8wzpq9ZlJRsC/QP8XMd70vQ
# Tcens6uCdak1dYRLGd6eZpY=
# SIG # End signature block
