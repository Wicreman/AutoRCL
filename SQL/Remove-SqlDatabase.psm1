function Remove-SqlDatabase  {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseServer = "localhost",

        [Parameter(Mandatory = $true)]
        [string]
        $SQLInstanceName,

        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName
    )

    process{
        Try
        {
            Write-Log "Remove '$DatabaseName'" 

            $databaseLocation = "SQLSERVER:\SQL\$DatabaseServer\$SQLInstanceName\Databases\$DatabaseName"

            if(Get-Item $databaseLocation -ErrorAction SilentlyContinue)
            {
                Remove-SqlConnectionsToDatabase -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $DatabaseName
                Remove-Item $databaseLocation
            }
            else
            {
                Write-Error "Database '$DatabaseName' does not exist on SQL Server instance '$DatabaseServer\$SQLInstanceName'"
            }
        }
        Catch
        {
            Write-Error "Fail to remove $DatabaseName"
        }

    }
}

Export-ModuleMember Remove-SqlDatabase

function Remove-SqlConnectionsToDatabase  {
    param
    (
        [parameter(Mandatory=$true)]
        [string]$DatabaseServer,
        
        [parameter(Mandatory=$false)]            
        [string]$DatabaseInstance = "",
        
        [parameter(Mandatory=$true)]
        [string]$DatabaseName
    )
    PROCESS
    {
        $CurrentLocation = Get-Location
        try
        {
            $SqlServerInstance = $DatabaseServer

            if (!($DatabaseInstance.Equals("") -or $DatabaseInstance.Equals("NAVDEMO")))
            {       
                $SqlServerInstance  = "$DatabaseServer`\$DatabaseInstance"
            }
        
            Invoke-Sqlcmd "USE [master]
                        DECLARE @id INTEGER
                        DECLARE @sql NVARCHAR(200)
                        WHILE EXISTS(SELECT * FROM master..sysprocesses WHERE dbid = DB_ID(N'$DatabaseName'))
                        BEGIN
                            SELECT TOP 1 @id = spid FROM master..sysprocesses WHERE dbid = DB_ID(N'$DatabaseName')
                            SET @sql = 'KILL '+RTRIM(@id) 
                        EXEC(@sql)  
                        END" -ServerInstance $SqlServerInstance
        }
        finally
        {
            Set-Location $CurrentLocation
        }
    }
}