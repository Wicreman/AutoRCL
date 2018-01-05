<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ServiceName
Parameter description

.PARAMETER RetryCount
Parameter description

.PARAMETER WaitTimeout
Parameter description

.PARAMETER LogPath
Parameter description

.EXAMPLE
Start-NavServer -ServiceName "DynamicsNAV" -LogPath "C:\NAVWorking"

.NOTES
General notes
#>
function Start-NavServer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [String]
		$ServiceName = "*DynamicsNAV*",
		
		[Parameter(Mandatory=$false)]
		[int]
		$RetryCount = 5,
		
		[Parameter(Mandatory = $false)]
        [Timespan]
        $WaitTimeout = (New-Object Timespan 0, 2, 0),

        [Parameter(Mandatory = $false)]
        [String]
        $LogPath = (Join-Path $env:HOMEDRIVE "NAVWorking")
    )
    process {

        $LogPath = Join-Path $LogPath "Logs"
        if(-Not(Test-Path $LogPath))
        {
            $null = New-Item -ItemType Directory -Path $LogPath -Force
        }

        Write-Log "Trying to find Dynamics NAV service..."
        # $Services = Get-Service $ServiceName
        $Services = Get-Service "MicrosoftDynamicsNavServer`$$ServiceName"

        If ($Services -Eq $Null)
        {
            Write-Log "Service not found matching '$ServiceName'! Assuming NAV Server is not installed."
            Return
        }

        ForEach ($Service in $Services)
        {
            $Attempt = 1
            $Name = $Service.Name
            $ServiceStatus = $Service.Status

            While (($Attempt -Le $RetryCount) -And ($ServiceStatus -Ne [System.ServiceProcess.ServiceControllerStatus]::Running))
            {
                Write-Log "Service '$Name': Status is $ServiceStatus."
                Write-Log "Service '$Name': Attempt $Attempt to ensure service is running."
                # Get-Service returns a snapshot of the service at a certain point in time - it doesn't update the Status...
                $Service = Get-Service $Name
                $ServiceStatus = $Service.Status
                
                If ($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::StopPending)
                {
                    Write-Log "Service '$Name': Status is pending stop. Waiting for up to 2 minutes..."
                    Try
                    {
                        $Service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped, $WaitTimeout)
                    }
                    Catch [System.ServiceProcess.TimeoutException]
                    {
                        Write-Log "Service '$Name': Timed out waiting for service to stop!"
                    }
                }
                
                If ($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::PausePending)
                {
                    Write-Log "Service '$Name': Status is pending pause. Waiting for up to 2 minutes..."
                    Try
                    {
                        $Service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Paused, $WaitTimeout)
                    }
                    Catch [System.ServiceProcess.TimeoutException]
                    {
                        Write-Log "Service '$Name': Timed out waiting for service to pause!"
                    }
                }
                
                $Service = Get-Service $Name
                $ServiceStatus = $Service.Status
                If (($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::Stopped) `
                -Or ($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::Paused))
                {
                    Write-Log "Service '$Name': Attempting to start service..."
                    Try
                    {
                        $Service.Start()
                    }
                    Catch
                    {
                        Write-Log ("Service '$Name': Failed starting service. Exception message: {0}" -f $_.Exception.Message)
                    }
                }
                
                $Service = Get-Service $Name
                $ServiceStatus = $Service.Status
                If (($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::StartPending) `
                -Or ($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::ContinuePending))
                {
                    Write-Log "Service '$Name': Status is pending start ($ServiceStatus). Waiting for up to 2 minutes..."
                    Try
                    {
                        $Service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running, $WaitTimeout)
                    }
                    Catch [System.ServiceProcess.TimeoutException]
                    {
                        Write-Log "Service '$Name': Timed out waiting for service to start!"
                    }
                }

                $Attempt++
            }

            $Service = Get-Service $Name
            $ServiceStatus = $Service.Status
            If ($ServiceStatus -Ne [System.ServiceProcess.ServiceControllerStatus]::Running)
            {
                $NavServerInstanceNum = $Name.Split('$')[1]
                $NavServerEventLogFileName = "$Name-EventLog-{0}.log" -f (Get-Date).ToString("yyyyMMddHHmmss")
                $NavServerEventLogFilePath = Join-Path $LogPath $NavServerEventLogFileName

                $LogFilter = @{
                    LogName = 'Application'
                    ProviderName = $NavServerInstanceNum 
                }

                Get-WinEvent -FilterHashtable @LogFilter | Select-Object TimeCreated, Id, LevelDisplayName, Message | Export-Csv $NavServerEventLogFilePath -NoTypeInformation

                $Message = "Expected service '$Name' to be running but it is $ServiceStatus!"
                Write-Log $Message
                Throw $Message
            }
        }
    }
}

Export-ModuleMember -Function Start-NavServer

# Optional commands to create a public alias for the function
New-Alias -Name StartServer -Value Start-NavServer
Export-ModuleMember -Alias StartServer
# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUhXzVBPGaRIz07nSdbGIuJZir
# A8agggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFACCXH7P
# fSiPTxhd7lzC42eAXGu/MA0GCSqGSIb3DQEBAQUABIGAoAKz6gXK9IL6FZOPg2mF
# eLYJzoziis5QYjgMuoDgKs9obSXGMMh9nx8NyeStMtNP69kK5t/KcYpn+DjxDGwx
# /E29daSnX5WL79+qPbHDxbzJd6JO/EFExlg9NgzsRduLo/gl7AfQc9IbBrzyeubD
# gh2OvSOLoCjr6Mz4sF3JPlU=
# SIG # End signature block
