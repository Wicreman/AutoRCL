funcation Sync-NAVDatabase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $NAVServerInstance,

        [Parameter(Mandatory = $false)]
        [string]
        $Mode = "Sync"
    )
    process{
        try{
            Write-Log "Force Synchronize the NAV database "
            if ((Get-NAVServerInstance $NAVServerInstance) -eq $null)
            {
                Write-Error "The Microsoft Dynamics NAV Server instance $NAVServerInstance does not exist."
                return
            }

            Sync-NAVTenant -ServerInstance $NAVServerInstance -Mode $Mode -Force
        }
        catch{
            Write-Exception $_.Exception
        }
    }
}

Export-ModuleMember Sync-NAVDatabase