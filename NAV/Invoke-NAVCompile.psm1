Funcation Invoke-NAVCompile{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName,

        [Parameter(Mandatory = $false)]
        [string]
        $DatabaseServer = ".",

        [Parameter(Mandatory = $true)]
        [string]
        $LogPath
    )
    process{
        try
        {
            Compile-NAVApplicationObject `
                -DatabaseName $DatabaseName `
                -DatabaseServer $DatabaseServer`
                -LogPath $LogPath
            # TODO: 
        }
        catch
        {
            Write-Exception $_.Exception
        }
    }
    
}

Export-ModuleMember Import-NAVLicense