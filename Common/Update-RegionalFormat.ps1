function Update-RegionalFormat {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Language
    )
    process{
        $aGroupDMY = "AT", "FI", "CH", "IS", "CZ", "DE", "NO", "RU"
        $bGroupDMY = "ES", "FR", "BE", "GB"
        $cGroupDYM = "DK", "NL", "W1"
        $dGroupMDY = "IN", "NA"
        $TimeFormat = "HH:mm:ss"
        switch($Language)
        {
            {$aGroupDMY -contains $_} {
                $ShortDate = "dd.MM.yy"
                Update-RegkeyValue $ShortDate $TimeFormat
                break
             }
             {$bGroupDMY -contains $_} {
                $ShortDate = "dd/MM/yy"
                Update-RegkeyValue $ShortDate $TimeFormat
                break
             }
             {$cGroupDYM -contains $_} {
                $ShortDate = "dd-MM-yy"
                Update-RegkeyValue $ShortDate $TimeFormat
                break
             }
             "IT" {
                $ShortDate = "dd/MM/yy"
                $itTimeFormat = "HH.mm.ss tt"
                Update-RegkeyValue $ShortDate $itTimeFormat
                break
             }
             "SE" {
                $ShortDate = "yy-MM-dd"
                Update-RegkeyValue $ShortDate $TimeFormat
                break
             }
             "AU" {
                $ShortDate = "dd/MM/yy"
                $auTimeFormat = "HH:mm:ss tt"
                
                Update-RegkeyValue $ShortDate $auTimeFormat
                break
             }
             "NZ" {
                $ShortDate = "dd/MM/yy"
                $nzTimeFormat = "HH:mm:ss tt"
                $am = "a.m."
                $pm = "p.m."
                Update-RegkeyValue $ShortDate $nzTimeFormat $am $pm
                break
             }
             {$dGroupMDY -contains $_} {
                $ShortDate = "MM/dd/yy"
                $naTimeFormat = "HH:mm:ss tt"
                Update-RegkeyValue $ShortDate $naTimeFormat
                break
             }
        }
        if(-Not(Get-WinCultureFromLanguageListOptOut))
        {
            Write-Log "Match Windows Display language (recommended)"
            Set-WinCultureFromLanguageListOptOut 1
        } 
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

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfIWjTbAXd2zR7TVrIheDIWFO
# 6OygggH1MIIB8TCCAV6gAwIBAgIQXzmgd4HWBJtM+inKVx0UhDAJBgUrDgMCHQUA
# MA4xDDAKBgNVBAMTA25hdjAeFw0xNzEyMjIwNTI5MzBaFw0zOTEyMzEyMzU5NTla
# MA4xDDAKBgNVBAMTA25hdjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAqLuf
# pYPvuzFdbyl6pQhjk8/zCoF1ygEw6+hRkseKHXfWI7m6UbilXIpVXLx5Wwob+nw8
# XuEFPfoDEXbt2vqiK66euLxQhaQCI2Q3S2O3/cDwLrNglIztikB3kVSALIjOE4iS
# XFhVNp5O+YQglok26p+CaI3dUPt7Z968DSBtVUkCAwEAAaNYMFYwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwPwYDVR0BBDgwNoAQLppon05tRx+xRJW7RvDlzqEQMA4xDDAK
# BgNVBAMTA25hdoIQXzmgd4HWBJtM+inKVx0UhDAJBgUrDgMCHQUAA4GBACWy/Vv0
# Xsa5bZAiG2uRWKCyNcmq78zLx22xum+2BMczI/5G7+QzZfO7fNumxVzUNVIVGR0q
# uK+Z+nq+CO12Wm8sTBhjFnLfh3mVzgGqPKfw1GjCDsEragQg77vla7jWtAcir64Y
# iizE714eNtaO6tRAg7/sqrXC+anCUJjQK9ocMYIBQjCCAT4CAQEwIjAOMQwwCgYD
# VQQDEwNuYXYCEF85oHeB1gSbTPopylcdFIQwCQYFKw4DAhoFAKB4MBgGCisGAQQB
# gjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFEtUTyPQ
# nwWgltiBc/+qymIUgQqEMA0GCSqGSIb3DQEBAQUABIGAlzhh7ftgg9RfdEoZR1tH
# w8AAdp2TahLWvDDR0XQvsPY5FpXgWxdYVA59Rz2zVwb7+B+/gVkqdiBuBwY1/GG/
# uv+sON7fcFymbrSstnJA3dxX4rblJTJZlfbuANFbB8wzpq9ZlJRsC/QP8XMd70vQ
# Tcens6uCdak1dYRLGd6eZpY=
# SIG # End signature block