function Import-SqlPsModule
{
    [CmdletBinding()]
    param
        (
        )
    PROCESS
    {

		$CurrentLocation = Get-Location
		try
		{
			$module = "sqlps"
			$snapIn = "SqlServerCmdletSnapin100"
			Import-Module $module -ErrorAction SilentlyContinue

			if((Get-Module $module) -eq $null)
			{
				if ((Get-PSSnapin -Name $snapIn -ErrorAction SilentlyContinue) -eq $null)
				{
					if ((Get-PSSnapin -Registered $snapIn -ErrorAction SilentlyContinue) -eq $null)
					{
						Write-Error "SQL Server PowerShell cmdlets could not be loaded."                                            
					}
					else
					{
						Add-PSSnapin $snapIn            
					}
				}
			}   
		}
		finally
		{
			Set-Location $CurrentLocation
		}    
	}
}   
Export-ModuleMember -Function Import-SqlPsModule

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUizbunmwtSB95UmZo1yZSK+P+
# nnegggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFIwYyv2C
# C9R2apj1N3AUa3Gwt2ohMA0GCSqGSIb3DQEBAQUABIGAVluZ7XkEYJdLrB5EHOr8
# 5ggeh188xCmKMxCydUMEXxjVhapWRoBLbMeXdBsHQ2hYmwIibRAGrfADmz9cffUZ
# s2oYkRWk0cJosVkJjAS2hLQFKELHa0g8ciHgQazs6BtoxG9XQ8/VDbyXzemao4DC
# WtBA+LyIogWPtJUNEqdOtew=
# SIG # End signature block
