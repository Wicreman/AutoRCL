function Update-RegionalFormat {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Language
    )
    process{
        

        $aGroupDMY = "AT", "FI", "CH", "IS", "CZ", "DE", "NO", "RU"
        $bGroupDMY = "ES", "FR", "BE", "GB", "IT"
        $cGroupDYM = "DK", "NL", "W1"
        $TimeFormat = "HH:mm:ss"
        switch($Language)
        {
            {$aGroupDMY -contains $_} {
                $ShortDate = "dd.MM.yy"
                Update-RegkeyValue($ShortDate, $TimeFormat)
                break
             }
             {$bGroupDMY -contains $_} {
                $ShortDate = "dd/MM/yy"
                Update-RegkeyValue($ShortDate, $TimeFormat)
                break
             }
             {$cGroupDYM -contains $_} {
                $ShortDate = "dd-MM-yy"
                Update-RegkeyValue($ShortDate, $TimeFormat)
                break
             }
             "SE" {
                $ShortDate = "yy-MM-dd"
                Update-RegkeyValue($ShortDate, $TimeFormat)
                break
             }
             "AU" {
                $ShortDate = "dd/MM/yy"
                $auTimeFormat = "HH:mm:ss tt"
                
                Update-RegkeyValue($ShortDate, $auTimeFormat)
                break
             }
             "NZ" {
                $ShortDate = "dd/MM/yy"
                $nzTimeFormat = "HH:mm:ss tt"
                $am = "a.m."
                $pm = "p.m."
                Update-RegkeyValue($ShortDate, $nzTimeFormat, $am, $pm)
                break
             }
             "NA" {
                $ShortDate = "MM/dd/yy"
                $naTimeFormat = "HH:mm:ss tt"
                Update-RegkeyValue($ShortDate, $naTimeFormat)
                break
             }
        }
        if(-Not(Get-WinCultureFromLanguageListOptOut))
        {
            Write-Log "Match Windows Display language (recommended)"
            Set-WinCultureFromLanguageListOptOut 1
        }
        Write-Log "Change the Region format of language to $Languge"
        Set-ItemProperty 'HKCU:\Control Panel\International' -Name "LocaleName" -Value $Language 
    }
}


function Update-RegkeyValue ([string] $shortData, [string] $timeFormat, [string]$am = "AM", [string]$pm = "PM") {
    $RegKeyPath = "HKCU:\Control Panel\International"

    Set-ItemProperty -Path $RegKeyPath -Name sShortDate -Value "$shortData"
    Set-ItemProperty -Path $RegKeyPath -Name sShortTime -Value "$timeFormat"
    Set-ItemProperty -Path $RegKeyPath -Name sTimeFormat -Value "$timeFormat"
    Set-ItemProperty -Path $RegKeyPath -Name s1159 -Value "$am"
    Set-ItemProperty -Path $RegKeyPath -Name s2359 -Value "$pm"
}

Export-ModuleMember -Function Update-RegionalFormat