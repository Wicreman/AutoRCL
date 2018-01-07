<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ServerInstance
Parameter description

.PARAMETER KeyName
Parameter description

.PARAMETER KeyValue
Parameter description

.EXAMPLE
$params = @{
ServerInstance = "DynamicsNAV";
KeyName = "DatabaseName" ;
KeyValue = "RTM100B"
}
Set-NAVServerConfiguration @params

.NOTES
General notes
#>
function Set-NewNAVServerConfiguration  {
   param(

    [Parameter(Mandatory = $false)]
    [string]
    $ServerInstance = "DynamicsNAV",

    [Parameter(Mandatory = $false)]
    [string]
    $KeyName = "DatabaseName",

    [Parameter(Mandatory = $false)]
    [string]
    $KeyValue = "NAVRTMDB"

   ) 

   process{
        try { 
            Write-Log "Update NAV Server configuration for $KeyName = $KeyValue in $ServerInstance "
            $params = @{
                ServerInstance = "$ServerInstance";
                KeyName = "$KeyName" ;
                KeyValue = "$KeyValue"        
            }

            Set-NAVServerConfiguration @params
            Set-NAVServerInstance -ServerInstance $ServerInstance -Restart
        }
        catch  {
            Write-Error "Fail to udpate NAV Server configuration!"
            Write-Exception $_.Exception
        }
   }
}

Export-ModuleMember -Function Set-NewNAVServerConfiguration

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