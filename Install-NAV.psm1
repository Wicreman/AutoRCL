function Install-NAV {
    <#
    .SYNOPSIS
    Install NAV 
    
    .DESCRIPTION
    1.
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>

    [cmdletbinding(SupportsShouldProcess=$true)]

    param (
        # Parameter help description
        [Parameter(AttributeValues)]
        [ParameterType]
        $ParameterName
    )

    Process {
        Write-Log "Copying setup files locally..."
        # TODO: Copy-setupfile

        Write-Log "Running setup.exe to install NAV..."
        # TODO: call Invoke-NavInstaller

        Write-Log "Copy RTM Database to SQL backukp"
        # TODO: Copy-RTM-DB

        Write-Log "Restore RTM Database"
        # TODO: Restore-RTM-DB

        Write-Log "Convert the Database"
        # TODO: Convert-DB

        Write-Log "Convert the Database"
        # TODO: Import-Fob

        Write-Log "Convert the Database"
        # TODO: Import-Txt
    }
}

Export-ModuleMember -Function Install-NAV