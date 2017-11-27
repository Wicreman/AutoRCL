function Invoke-NavInstaller {
    <#
    .SYNOPSIS
    Invoke setup.exe Dynamics NAV installer
    
    .DESCRIPTION
    Invokes the setup.exe Dynamics NAV installer with specified parameters
    
    .EXAMPLE
    setup.exe /quiet /config C:\config.xml /log C:\log.txt
    
    .NOTES
    General notes
    #>

    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory = $true)]
        [string]
        $Path

    )
    Process {

    }
}