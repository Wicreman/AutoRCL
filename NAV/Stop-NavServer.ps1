<#
.SYNOPSIS


.DESCRIPTION
Long description

.PARAMETER ServiceName
Parameter description

.PARAMETER RetryCount
Parameter description

.PARAMETER WaitTimeout
Parameter description

.EXAMPLE
Stop-NAVServer -ServiceName "DynamicsNAV"

.NOTES
General notes
#>
Function Stop-NAVServer
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)]
        [String]
        $ServiceName = "*NavServer*",
        
        [Parameter(Mandatory = $False)]
        [Int]
        $RetryCount = 3,
        
        [Parameter(Mandatory = $False)]
        [Timespan]
        $WaitTimeout = (New-Object Timespan 0, 5, 0)
    )
    
    Process
    {
        Write-Log "Trying to find Dynamics Nav Server service..."
        #$Services = Get-Service $ServiceName
        $Services = Get-Service "MicrosoftDynamicsNavServer`$$ServiceName"

        If ($Services -Eq $Null)
        {
            Write-Log "Service not found matching '$ServiceName'! Assuming Dynamics NAV server is not installed."
            Return
        }

        ForEach ($Service in $Services)
        {
            $Attempt = 1
            $Name = $Service.Name
            $ServiceStatus = $Service.Status

            While (($Attempt -Le $RetryCount) -And ($ServiceStatus -Ne [System.ServiceProcess.ServiceControllerStatus]::Stopped))
            {
                Write-Log "Service '$Name': Status is $ServiceStatus."
                Write-Log "Service '$Name': Attempt $Attempt to ensure service is stopped."
                # Get-Service returns a snapshot of the service at a certain point in time - it doesn't update the Status...
                $Service = Get-Service $Name
                $ServiceStatus = $Service.Status
                
                If ($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::StopPending)
                {
                    Write-Log "Service '$Name': Status is pending stop. Waiting for up to 5 minutes..."
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
                    Write-Log "Service '$Name': Status is pending pause. Waiting for up to 5 minutes..."
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
                If (($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::Running) `
                -Or ($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::Paused))
                {
                    Write-Log "Service '$Name': Attempting to stop service..."
                    Try
                    {
                        $Service.Stop()
                    }
                    Catch
                    {
                        Write-Log ("Service '$Name': Failed stopping service. Exception message: {0}" -f $_.Exception.Message)
                    }
                }
                
                $Service = Get-Service $Name
                $ServiceStatus = $Service.Status
                If (($ServiceStatus -Eq [System.ServiceProcess.ServiceControllerStatus]::StopPending))
                {
                    Write-Log "Service '$Name': Status is pending stop ($ServiceStatus). Waiting for up to 5 minutes..."
                    Try
                    {
                        $Service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running, $WaitTimeout)
                    }
                    Catch [System.ServiceProcess.TimeoutException]
                    {
                        Write-Log "Service '$Name': Timed out waiting for service to stop!"
                    }
                }

                $Attempt++
            }

            $Service = Get-Service $Name
            $ServiceStatus = $Service.Status
            If ($ServiceStatus -Ne [System.ServiceProcess.ServiceControllerStatus]::Stopped)
            {
                $Message = "Expected service '$Name' to be stopped but it is $ServiceStatus!"
                Write-Log $Message
                Throw $Message
            }
        }
    }
}

Export-ModuleMember -Function Stop-NAVServer

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUr/uF0dKed1t657Qzs0aTNzO7
# /iagggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFK0DZBOs
# K0ENHbKOfDZpglV4gSeEMA0GCSqGSIb3DQEBAQUABIGASTfPBHwZ5MtwP4Chssut
# tvqMpYjjwEasX6OZS7Gi7cqt3PqpM52MHzhqTe3huPtYLqezgiLjXfsngJUN27P6
# T7eivUIjKyOVKj3kKNSH0XOdsmHDo0embyrtgwZNCDu2b923SQQCsclwru8rhqlj
# nfa8yhddDQCDEnEGXrHNVIc=
# SIG # End signature block
