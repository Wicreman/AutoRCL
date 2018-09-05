function Send-UnitTestResult {
    
    param(
        # Report file path
        [Parameter(Mandatory = $true)]
        [string]
        $ReportPath,

        [Parameter(Mandatory = $true)]
        [string]
        $Version,

        [Parameter(Mandatory = $true)]
        [string]
        $Language,

        [Parameter(Mandatory = $false)]
        [string]
        $BuildDate
    )

    process{

        $toEmailAddress = ([adsi]"LDAP://$(whoami /fqdn)").mail.ToString()
        $fromEmailAddress = ([adsi]"LDAP://$(whoami /fqdn)").mail.ToString()
        $CcTo = "wsnavt@microsoft.com"
        $BCc = "v-doc@microsoft.com"

        $headerStyle = @"
        <style>
        body { 
            font-family:Verdana;
            font-size:12pt; 
        }
        td, th { 
            border:0px solid #9CC2E5; 
            border-collapse:collapse;
            white-space:pre; 
        }
        th { 
            color:white;
            background-color:#1C6EA4; 
        }
        table, tr, td, th { padding: 2px; margin: 0px ;white-space:pre; }
        tr:nth-child(odd) {background-color: lightgray}
        table { width:100%;margin:0px;}
        h2 {
            font-family:Verdana;
            color:#1C6EA4;
        }

        h3 {
            font-family:Verdana;
            color:#076A34;
        }

        .footer { 
            color:green; 
            margin-left:10px; 
            font-family:Tahoma;
            font-size:8pt;
            font-style:italic;
        }
        </style>
"@
        if(-Not(Test-Path $ReportPath))
        {
            throw "The report file doesn't exist" 
            return
        }

        [xml]$report = Get-Content $ReportPath

        $totalUTs = $report.SelectNodes("//test-case").Count
        $failedUTs = $report.SelectNodes("//test-case[@success='False']").Count
        $passedUTs = $report.SelectNodes("//test-case[@success='True']").Count
        $caseCount = @"
        <H2> Unit Test Result for RCL Automation </H2> 
        <H3> 
        Summary: <br />
        Passed: $passedUTs of $totalUTs<br/>
        Failed: $failedUTs of $totalUTs<br/>
        </H3>
"@
        if($totalUTs -gt 0)
        {
            $messageBodyUTs = $report.SelectNodes("//test-case") `
                | Select-Object `
                    @{ Name = "Test Case Name"; Expression = {$_.name}}, `
                    @{ Name = "Execution Time"; Expression = {$_.time}}, `
                    @{ Name = "Test Result"; Expression = {$_.result}},  `
                    @{ Name = "FailureLog"; Expression = {$_.InnerText}} `
                | ConvertTo-Html -Head $headerStyle 
        }

        $sendToArray = $SendTo.Split(",")

        $body = @{
            From = $fromEmailAddress
            To = $toEmailAddress
            Cc = @($CcTo)
            Bcc = @($BCc)
            Subject = "RCL Report for Dynamics$Version with $Language - $BuildDate"
            Body =  $caseCount + $messageBodyUTs
            SmtpServer = "smtphost.dns.microsoft.com"
            IsHtml = $true
        }

        if ($PSVersionTable.PSVersion.Major -ge 3)
        {
            Send-MailMessage @body
        }
        else
        {
            Write-Log "The powershell version does not support email courier service."
        }
    }
}

Export-ModuleMember -Function  Send-UnitTestResult


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