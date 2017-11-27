function Restore-RTMDatabase
{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    Restore RTM demo database 
    
    .PARAMETER ServerInstance
    Restore RTM database 
    
    .EXAMPLE

    Copy the 90DE RTM database 'Demo Database NAV (9-0).bak' 
    from \\vedfssrv01\DynNavFS\Releases\NAV\DynamicsNAV2016\DE\Dynamics.90.DE.1769282.DVD.zip\SQLDemoDatabase\CommonAppData\Microsoft\Microsoft Dynamics NAV\90\Database 
    to C:\Program Files\Microsoft SQL Server\MSSQL13.NAVDEMO\MSSQL\Backup


    #>

    [CmdletBinding()]
    param(
        # Server instance name like "Computer\Instance"
        [Parameter(Mandatory = $true)]
        [string]
        $ServerInstance,

        # New database name
        [Parameter(Mandatory = $true)]
        [string]
        $Database,

        [Parameter(Mandatory = $true)]
        [string]
        $BackupFile
    )
    process{
        
        try
        {
            if (-Not (Test-Path -PathType Leaf -Path $BackupFile))
            {
                $Message = ("Backup file '{0}' cannot be found!" -f $BuildDropPath)
                Write-Log $Message
                Throw $Message
            }
            
            Restore-SqlDatabase `
                -ServerInstance $ServerInstance `
                -Database $Database `
                -BackupFile $BackupFile
        }
        catch
        {
            $Message = ("Fail to restore '{0}" -f $Database)
            Write-Log $Message
            Throw $Message
        }

    }
}

Export-ModuleMember Restore-RTMDatabase