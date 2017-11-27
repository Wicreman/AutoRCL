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
        [Parameter(Mandatory = $true)]
        [string]
        $BuildDropPath,

        [Parameter(Mandatory = $true)]
        [string]
        $BuildDate,

        [Parameter(Mandatory = $true)]
        [string]
        $Language
    )

    Process {
        Write-Log "Copying setup files locally..."
        Try
        {
            $LocalBuildPath = Copy-NAVSetup`
                -BuildDropPath $BuildDropPath `
                -BuildDate $BuildDate `
                -Language $Language
        }
        Catch
        {
            Write-Log "The Copy-NAVSetup function failed! See exception for more information."
            Throw $_
        }
        

        Write-Log "Running setup.exe to install NAV..."
        Try
        {
            Invoke-NavSetup `
                -

        }
        Catch
        {

        }

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