Function Stop-ApplicationObjectServer
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
        $Services = Get-Service $ServiceName

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

Export-ModuleMember Stop-ApplicationObjectServer
