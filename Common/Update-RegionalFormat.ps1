function Update-RegionalFormat {
    <#
    .SYNOPSIS
    specify the default country/region, regional format, pre-enabled keyboard, and speech languages for the device.
    
    .DESCRIPTION
    https://docs.microsoft.com/en-us/windows-hardware/customize/mobile/mcsf/regional-format

    
    .PARAMETER Language
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>

    param(
        # language name  'fr-FR'
        [Parameter(Mandatory = $true)]
        [string]
        $Language
    )
    process{
        if(-Not(Get-WinCultureFromLanguageListOptOut))
        {
            Write-Log "Match Windows Display language (recommended)"
            Set-WinCultureFromLanguageListOptOut 1
        }
        Write-Log "Change the Region format of language to $Languge"
        Set-ItemProperty 'HKCU:\Control Panel\International' -Name "LocaleName" -Value $Language 
    }
}

Export-ModuleMember -Function Update-RegionalFormat