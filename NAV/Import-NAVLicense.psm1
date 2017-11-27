function Import-NAVLicense {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $NAVServerInstance,

        [Parameter(Mandatory = $true)]
        [string]
        $LicenseFile,

        [Parameter(Mandatory = $false)]
        [string]
        $LicenseDatabase = "NavDatabase"
    )
    process{
        try
        {
            Write-Log "Looking for NAV Server instance $NAVServerInstance"
            if ((Get-NAVServerInstance $NAVServerInstance) -eq $null)
            {
                Write-Error "The Microsoft Dynamics NAV Server instance $NAVServerInstance does not exist."
                return
            }
    
            Write-Log "Import the new version license into the application database, and restart the server in order for the license to be loaded"
            Import-NAVServerLicense -ServerInstance $NAVServerInstance -LicenseFile $LicenseFile -Database $LicenseDatabase 
            Set-NAVServerInstance -ServerInstance $NAVServerInstance -Restart  
        }
        catch
        {
            Write-Exception $_.Exception
        }     
    }
}

Export-ModuleMember Import-NAVLicense