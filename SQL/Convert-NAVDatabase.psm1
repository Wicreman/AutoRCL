function Convert-NAVDatabase {
    [CmdletBinding()]
    param(
        # Specifies the name of the SQL server instance on which you want to create the database
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseServer, 

        # Specifies the instance of the Dynamics NAV database
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseInstance, 

        # Specifies the name of the Dynamics NAV database that will be created.
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName, 

        [Parameter(Mandatory = $false)]
        [string]
        $LogPath 
    )
    process{
        $DatabaseServerInstanceName = $DatabaseServer;

        if (!($DatabaseInstance.Equals("") -or $DatabaseInstance.Equals("NAVDEMO")))
        {       
            $DatabaseServerInstanceName = "$DatabaseServer`\$DatabaseInstance"
        }
        try
        {
            Write-Log "Convert NAV Database $DatabaseName"
            Invoke-NAVDatabaseConversion `
                -DatabaseName $DatabaseName `
                -DatabaseServer $DatabaseSQLServerInstance `
                -LogPath $LogPath\"Database Conversion"  
        }
        catch
        {
            Write-Log "Fail to convert NAV Database $DatabaseName" + "For detailed information, please refer to $LogPath."
            Write-Exception $_.Exception
        }
    }
}

Export-ModuleMember Convert-NAVDatabase