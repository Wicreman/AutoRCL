function Import-FobOrTxtFile{
    param(
        # Specifies one or more files to import.
        [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseSQLServerInstance,

        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName,

        [Parameter(Mandatory = $true)]
        [string]
        $SynchronizeSchemaChanges = "Yes",

        [Parameter(Mandatory = $true)]
        [string]
        $ImportAction = "Default",

        [Parameter(Mandatory = $false)]
        [string]
        $LogPath

    )
    process{
        try {
            Write-Log "Import file $Path"
            if (-Not(Test-Path -PathType Leaf -Path $Path))
            {
                $Message = ("Imported file '{0}' cannot be found!" -f $Path)
                Write-Log $Message
                Throw $Message
            }
            Import-NAVApplicationObject `
                -Path $Path `
                -DatabaseName $DatabaseName `
                -DatabaseServer $DatabaseSQLServerInstance `
                -LogPath $LogPath `
                -ImportAction $ImportAction `
                -SynchronizeSchemaChanges $SynchronizeSchemaChanges `
                -Confirm:$false 
        }
        catch {
            Write-Exception $_.Exception
        }
    }
}

Export-ModuleMember Import-FobOrTxtFile