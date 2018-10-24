function Export-FobOrTxtFile  {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Version,

        [Parameter(Mandatory = $false)]
        [string]
        $DatabaseName = "NAVRTMDB",

        [Parameter(Mandatory = $false)]
        [string]
        $DatabaseServer = "localhost",

        [Parameter(Mandatory = $false)]
        [string]
        $Path = (Join-Path $env:HOMEDRIVE "NAVWorking\Export"),

        [Parameter(Mandatory = $false)]
        [string]
        $LogPath = (Join-Path $env:HOMEDRIVE "NAVWorking\Logs"),

        [Parameter(Mandatory = $false)]
        [string]
        $FileType = "fob"
    )

    process{
        Write-Log "Export file to directory $Path"
        if(-Not(Test-Path $Path))
        {
            $null = New-Item -ItemType Directory -Path $Path -Force 
        }
        
        $exportedFile = Join-Path $Path "$DatabaseName$ShortVersion.$FileType"
        Write-Log "Export file to file $exportedFile"
        if (Test-Path $exportedFile)
        {
            Remove-Item $exportedFile -Force -Recurse
        }

        $LogPath = Join-Path $LogPath "ExportFobOrTxt\$FileType"
        if(-Not(Test-Path $LogPath))
        {
            $null = New-Item -ItemType Directory -Path $LogPath -Force 
        }

        $FilterMap = @{
            365 = "Version List=*13.*"
            NAV2018 = "Version List=*11.*.00*"
            NAV2017 = "Version List=*10.*.00*"
            NAV2016 = "Version List=*9.*.00*"
            NAV2015 = "Version List=*8.*.00*"
        }

        $isExportTxtSkipUnlicensed = $false
        if($FileType -eq "txt")
        {
            $isExportTxtSkipUnlicensed = $true
        }

        $RTMDatabaseName = "$DatabaseName$ShortVersion"

        $SQLServerInstance = $DatabaseServer;
        if (!$DatabaseInstance.Equals("") -or $DatabaseInstance.Equals("NAVDEMO"))
        {       
            $SQLServerInstance = "$DatabaseServer`\$DatabaseInstance"
        }

        try {
            $exportParm = @{
                DatabaseName = $RTMDatabaseName
                Path = $exportedFile
                DatabaseServer = $SQLServerInstance
                LogPath = $LogPath
                Filter = $FilterMap.$Version
                Confirm = $false
                Force = $true
                ExportTxtSkipUnlicensed = $isExportTxtSkipUnlicensed
            }
    
            Export-NAVApplicationObject @exportParm

            return ,$exportedFile
        }
        catch {
            Wirte-Log "Fail to export $FileType to $Path"
            Write-Exception $_.Exception
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }  
    }
}

Export-ModuleMember -Function Export-FobOrTxtFile

# SIG # Begin signature block
# MIID2QYJKoZIhvcNAQcCoIIDyjCCA8YCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfIWjTbAXd2zR7TVrIheDIWFO
# 6OygggH+MIIB+jCCAWegAwIBAgIQQOxXfO4MQJNA8TDp2dgD4TAJBgUrDgMCHQUA
# MBExDzANBgNVBAMTBk5BVlJDTDAeFw0xNzEyMjcxMTUxMDlaFw0zOTEyMzEyMzU5
# NTlaMBExDzANBgNVBAMTBk5BVlJDTDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkC
# gYEA3m9qUEauUeJ/ssE6Y7ArtMkGvc7ihxfhjLKMuOHDpKfupos436Dh632IHVrD
# PxfbbkDZ4taLvVjDPXjaClBTlxsTeUI4bIlymFnlx8OYhd1lVyKYMa6ffE9yXpE2
# /xHaDp819LyfkBMl1b/oV1ZTSjM6uPBCPmyDuzWXve2aXRECAwEAAaNbMFkwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwQgYDVR0BBDswOYAQXxZRqoiFJtrDIudJq6L9+KET
# MBExDzANBgNVBAMTBk5BVlJDTIIQQOxXfO4MQJNA8TDp2dgD4TAJBgUrDgMCHQUA
# A4GBAFeNJDlB48Kf7Yhndhnre5wFLT/D8XB/YKJ+RBQqoY1UBjJX4KsHADhVyd8A
# kI2j9X83VBXmuU5Sf0GoS9TbAlBfjyNG5AtoTC3/4Ann/eyqBSlZDUyu+hcV+Jqu
# uoa9lvMUzuFszC5n3zvpyfNbXHW0RPXRq7Hbb/B92d3paJU7MYIBRTCCAUECAQEw
# JTARMQ8wDQYDVQQDEwZOQVZSQ0wCEEDsV3zuDECTQPEw6dnYA+EwCQYFKw4DAhoF
# AKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcN
# AQkEMRYEFEtUTyPQnwWgltiBc/+qymIUgQqEMA0GCSqGSIb3DQEBAQUABIGA2zZn
# KvyJUZ2brTMakH4UfXUNc/9sFrj9kZH/MpQI0DfomiklKYn7GjT3Cx4wQwkgQe90
# BN4ZBaY8NG3XPoRqHxjZbJaIoF56feZk3EXfyTjSWBbiJODczi3HbELI4IP4fHwm
# jMU2AEj9IB5XYQGsDDuZUqe4M3jku/N9ROgALR0=
# SIG # End signature block