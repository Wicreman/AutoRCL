<#
.SYNOPSIS
    A brief description of the module.
.DESCRIPTION
    A detailed description of the module.
#>

function Start-NavServer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [String]
		$ServiceName = "*NavServer*",
		
		[Parameter(Mandatory=$False)]
		[int]
		$RetryCount = 5,
		
		[Parameter(Mandatory = $False)]
        [Timespan]
        $WaitTimeout = (New-Object Timespan 0, 5, 0),

        [Parameter(Mandatory = $True)]
        [String]
        $LogPath
    )
    process {
        Write-Log "Trying to find Dynamics NAV service..."
        $Services = Get-Service $ServiceName

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
                    Write-Log "Service '$Name': Status is pending start ($ServiceStatus). Waiting for up to 5 minutes..."
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
                # We assume that AOS service name is in the format like "AOS60$01".
                $NavServerInstanceNum = $Name.Split('$')[1]
                $NavServerEventLogFileName = "$Name-EventLog-{0}.log" -f (Get-Date).ToString("yyyyMMddHHmmss")
                $NavServerEventLogFilePath = Join-Path $LogPath $NavServerEventLogFileName

                $LogFilter = @{
                    LogName = 'Application'
                    ProviderName = $NavServerInstanceNum 
                }

                Get-WinEvent -FilterHashtable $LogFilter | Select TimeCreated, Id, LevelDisplayName, Message | Export-Csv $NavServerEventLogFilePath -NoTypeInformation

                $Message = "Expected service '$Name' to be running but it is $ServiceStatus!"
                Write-Log $Message
                Throw $Message
            }
        }
    }
}

Export-ModuleMember Start-NavServer

# Optional commands to create a public alias for the function
New-Alias -Name StartServer -Value Start-NavServer
Export-ModuleMember -Alias StartServer