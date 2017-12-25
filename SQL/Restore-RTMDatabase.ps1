function Restore-RTMDatabase
{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    Restore RTM demo database 
    
    .PARAMETER ServerInstance
    Restore RTM database 
    
    .EXAMPLE


    #>

    [CmdletBinding()]
    param(
        # Server instance name like "Computer\Instance"
        [Parameter(Mandatory = $true)]
        [string]
        $ServerInstance,

        # New database name
        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName,

        [Parameter(Mandatory = $true)]
        [string]
        $BackupFile
    )
    process{
        $CurrentLocation = Get-Location
        try
        {
            if (-Not (Test-Path -PathType Leaf -Path $BackupFile))
            {
                $Message = ("Backup file '{0}' cannot be found!" -f $BuildDropPath)
                Write-Log $Message
                Throw $Message
            }

            $SqlServerInstance = $DatabaseServer

            if (!($DatabaseInstance.Equals("") -or $DatabaseInstance.Equals("NAVDEMO")))
            {       
                $SqlServerInstance  = "$DatabaseServer`\$DatabaseInstance"
            }

            $navDataDir = join-path $env:HOMEDRIVE "navDataDir"
            Write-Log "Preparing $navDataDir directory..."
            if (-Not(Test-Path $navDataDir)) {
                if (-Not(Test-Path $navDataDir -IsValid)) {
                    $Message = ("NAV Working Directory '{0}' is not valid!" -f $navDataDir)
                    Write-Log $Message
                    Throw $Message
                }

                Write-Log ("navWorkingDir path '{0}' does not exist - creating..." -f $navDataDir)

                $null = New-Item -ItemType Directory $navDataDir -Force
            }

            $newMdf = join-path $navDataDir "$DatabaseName'_Data.mdf'"
            $newLdf = join-path $navDataDir "$DatabaseName'_log.ldf'"

            $RTMDBName = [System.IO.Path]::GetFileNameWithoutExtension($BackupFile)

            $rtmMdf = "$RTMDBName'_Data'"
            $rtmLdf = "$RTMDBName'_Log'"

            Invoke-Sqlcmd "USE [master]
                        DECLARE @id INTEGER
                        DECLARE @sql NVARCHAR(200)
                        WHILE EXISTS(SELECT * FROM master..sysprocesses WHERE dbid = DB_ID(N'$DatabaseName'))
                        BEGIN
                            SELECT TOP 1 @id = spid FROM master..sysprocesses WHERE dbid = DB_ID(N'$DatabaseName')
                            SET @sql = 'KILL '+RTRIM(@id) 
                        EXEC(@sql)  
                        END
                        
                        -- Restore RTM database
                        restore database $DatabaseName from Disk = $BackupFile
                        WITH REPLACE, 
                        Move '$rtmMdf' TO '$newMdf',
                        Move '$rtmLdf' TO '$newLdf'
                        
                        " -ServerInstance $SqlServerInstance
        }
        catch
        {
            $Message = ("Fail to restore '{0}" -f $Database)
            Write-Log $Message
            Throw $Message
        }
        finally
        {
            Set-Location $CurrentLocation
        }

    }
}

Export-ModuleMember -Function Restore-RTMDatabase
# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUAs12bncRargZR3NDdmdusPpW
# 0JugggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFMLUiFZI
# PmmdeSKEdUXPDK547nYOMA0GCSqGSIb3DQEBAQUABIGAefj5T+/P5b8SS7B/ns1v
# IpmzPrYbGCbM4AR4fnrY6SubkhhtFOs/CpxHe4IR+3xXqj16La/P/IUXq8rQSX8i
# jsafqsYPKvPEMNwLgmxNyj5WxbAhjmw2YZaHaNgYgVF6gaUL17Cy5iF9qxhofvTS
# 0zY5DICIJMI04QBp4VA4j20=
# SIG # End signature block
