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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ConfigFilePath,

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

Export-ModuleMember  Invoke-NavSetup