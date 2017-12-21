function Convert-NAVDatabase {
    [CmdletBinding()]
    param(
        # Specifies the name of the SQL server instance on which you want to create the database
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseServer, 

        # Specifies the instance of the Dynamics NAV database
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseInstance, 

        # Specifies the name of the Dynamics NAV database that will be created.
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName, 

        [Parameter(Mandatory = $false)]
        [string]
        $LogPath 
    )
    process{
        $DatabaseServerInstanceName = $DatabaseServer;

        if (!($DatabaseInstance.Equals("") -or $DatabaseInstance.Equals("NAVDEMO")))
        {       
            $DatabaseServerInstanceName = "$DatabaseServer`\$DatabaseInstance"
        }
        try
        {
            Write-Log "Convert NAV Database $DatabaseName"
            Invoke-NAVDatabaseConversion `
                -DatabaseName $DatabaseName `
                -DatabaseServer $DatabaseSQLServerInstance `
                -LogPath $LogPath\"Database Conversion"  
        }
        catch
        {
            Write-Log "Fail to convert NAV Database $DatabaseName" + "For detailed information, please refer to $LogPath."
            Write-Exception $_.Exception
        }
    }
}

Export-ModuleMember -Function Convert-NAVDatabase
# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUiCGaTwrLwf9xpD3yooRMhxFr
# E62gggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
# MA4xDDAKBgNVBAMTA05BVjAeFw0xNzExMjgwNDAwMzlaFw0zOTEyMzEyMzU5NTla
# MA4xDDAKBgNVBAMTA05BVjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAp5GZ
# c6U30Wj/1Y5mmZpi4BU7Cy1Pbo7gDOVnxvIHCi1Bfivb7WQB3cpp1b2vYeBgH3y0
# Cl9th4bgTy9fPe/zdin57thq/OwJS3qB8rxKazh+Xa3BpHxvAumX7THqZ8ocvirB
# JGIl3K9fDUyeRkPDKq+CC0eqnKDaS6ANuHdvCg8CAwEAAaNYMFYwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwPwYDVR0BBDgwNoAQEgOra+cR2aH3BOGG7Qzr1qEQMA4xDDAK
# BgNVBAMTA05BVoIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUAA4GBABelU7ZT
# +OXIZH2HfiD4Ngv7lef7RGEaLtBCiXyxkcmTInxY8s6FImkD0Hywf1jcDcU3LeEt
# QnxDsQvfkUFBRHhzFIUvhCxmTHgKfDvisV07bOIrraHuCUAQ+72yrQ7HSRQ5p9z4
# B98bWycdUXSY7mg5l6VilFT2A2Bs03U0WZ82MYIBQjCCAT4CAQEwIjAOMQwwCgYD
# VQQDEwNOQVYCEHq2r9TiRoyURK9oQzHhKh8wCQYFKw4DAhoFAKB4MBgGCisGAQQB
# gjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFPQoQbAV
# hDVQkJydG+N/hJUdAWXBMA0GCSqGSIb3DQEBAQUABIGAl1QA0xaXChEky25viekL
# j2jokZ09hNo+/uK9CddpsDgXsi+T9WfpdopFtB0smfFQH5w8ArbZEWp64d2Lr7UY
# JloIMYEQu4oUXLMCBsPNGP+cmYCS6Hws1d8QWN4VnmGVCffItA7hrFXKcOIymPpt
# 3NUizDxWIj5fHycVhKLrnFo=
# SIG # End signature block
