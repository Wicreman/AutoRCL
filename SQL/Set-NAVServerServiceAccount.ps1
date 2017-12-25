<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER NAVServerServiceAccount
Parameter description

.PARAMETER SqlServerInstance
Parameter description

.PARAMETER DatabaseName
Parameter description

.EXAMPLE
$setServiceAccountParam = @{
    NAVServerServiceAccount = $NAVServerServiceAccount
    SqlServerInstance = $SQLServerInstance
    DatabaseName = $RTMDatabaseName
}
Set-NAVServerServiceAccount @setServiceAccountParam

.NOTES
General notes
#>
function Set-NAVServerServiceAccount  {
    param(
        [parameter(Mandatory=$false)]
        [string]$NAVServerServiceAccount = "NT AUTHORITY\NETWORK SERVICE",

        # localhost\NAVDEMO
        [parameter(Mandatory=$false)]
        [string]$SqlServerInstance = "localhost\NAVDEMO",

        [parameter(Mandatory=$false)]
        [string]$DatabaseName = "NAVRTMDB"
    )

    process{

        try {
            Write-Log "Verify that the service account for the 
            Microsoft Dynamics NAV Server has a login in the SQL Server instance."

            $checkQuery = "IF EXISTS (SELECT 1 
                FROM master.sys.server_principals
                WHERE name = '$NAVServerServiceAccount') 
                SELECT 1 AS res ELSE SELECT 0 AS res;"

            $sqlLoginExists = Invoke-Sqlcmd $checkQuery -ServerInstance $SqlServerInstance  
            
            if($sqlLoginExists.res -eq 0)
            {
                Write-Error "SQL Server $SqlServerInstance does not contain a Login for $NAVServerServiceAccount"      
                return      
            }

            Write-Log "Create a user for the service account in the SQL Server database if the login is not already a user."
            
            $createQuery =  
            "IF NOT EXISTS
            (SELECT * from sys.database_principals where name = '$NAVServerServiceAccount')
            BEGIN    
                CREATE USER [$NAVServerServiceAccount] FOR LOGIN [$NAVServerServiceAccount] WITH DEFAULT_SCHEMA=[dbo]
            END" 

            Invoke-Sqlcmd $createQuery -ServerInstance $SqlServerInstance -Database $DatabaseName -Verbose
            
            Write-Log "Set the Service Account user as db_owner for the database"
            Invoke-Sqlcmd "EXEC sp_addrolemember N`'db_owner`', N`'$NAVServerServiceAccount`'" -ServerInstance $SqlServerInstance -Database $DatabaseName
            
        }
        catch {

            Write-Exception $_.Exception
        }
        
    }
}

Export-ModuleMember -Function Set-NAVServerServiceAccount

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpRSwv977Q4011TDURLRiOtAt
# aMugggH1MIIB8TCCAV6gAwIBAgIQXzmgd4HWBJtM+inKVx0UhDAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFNkyvjEb
# 4iLfO/MwfzBXSOqYdhntMA0GCSqGSIb3DQEBAQUABIGAoK3ZMBrpOuYP37AHZzCT
# FC7iOJIIWQuQgLhcf8N/UzDBaYBcOI0Gurai61mAgLj3cc3z6cwyxg1GwG1AqnQ7
# u3FoV44rDPkdEovN4rvE1ti8+j2TDrL+HwtByZDd8naPRLBxnQ7pIm34z6OfETT1
# +WA/zAzs/HNhA47NCEmjGc0=
# SIG # End signature block