function Remove-SqlConnectionsToDatabase  {
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true)]
        [string]$DatabaseServer,
        
        [parameter(Mandatory=$false)]            
        [string]$DatabaseInstance = "",
        
        [parameter(Mandatory=$true)]
        [string]$DatabaseName
    )
    PROCESS
    {
        $CurrentLocation = Get-Location
        try
        {
            $SqlServerInstance = $DatabaseServer
            
            if (-not($DatabaseInstance.Equals("")) -or $DatabaseInstance.Equals("NAVDEMO"))
            {       
                $SqlServerInstance  = "$DatabaseServer`\$DatabaseInstance"
            }
        
            Invoke-Sqlcmd "USE [master]
                        DECLARE @id INTEGER
                        DECLARE @sql NVARCHAR(200)
                        WHILE EXISTS(SELECT * FROM master..sysprocesses WHERE dbid = DB_ID(N'$DatabaseName'))
                        BEGIN
                            SELECT TOP 1 @id = spid FROM master..sysprocesses WHERE dbid = DB_ID(N'$DatabaseName')
                            SET @sql = 'KILL '+RTRIM(@id) 
                        EXEC(@sql)  
                        END" -ServerInstance $SqlServerInstance
        }
        finally
        {
            Set-Location $CurrentLocation
            # TODO: add log informaiton
            # FIXME: Today
        }
    }
}

Export-ModuleMember -Function Remove-SqlConnectionsToDatabase

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfIWjTbAXd2zR7TVrIheDIWFO
# 6OygggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFEtUTyPQ
# nwWgltiBc/+qymIUgQqEMA0GCSqGSIb3DQEBAQUABIGAmd4ZAPvZ+a1UCZdxrG0x
# N6jxAEevDntZ22AgCZAFJ4srLqx33pZgGgwpWNC+tNqias2vztwU676I8TRGvHzU
# 6zBlUo2Y2Ua5nqmK2JpX8lgQxMnJRtYgTT2tdt+VJPoOidh7unu01cFYwSpezgDr
# wxq3wu4UMeUNaQwcr42bCws=
# SIG # End signature block