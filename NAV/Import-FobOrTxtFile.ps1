function Import-FobOrTxtFile{
    param(
        # Specifies one or more files to import.
        [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [string]
        $SQLServerInstance,

        [Parameter(Mandatory = $true)]
        [string]
        $DatabaseName,

        [Parameter(Mandatory = $false)]
        [string]
        $FileType = "Fob",

        [Parameter(Mandatory = $false)]
        [string]
        $SynchronizeSchemaChanges = "Yes",

        [Parameter(Mandatory = $false)]
        [string]
        $ImportAction = "Overwrite",

        [Parameter(Mandatory = $false)]
        [string]
        $LogPath = (Join-Path $env:HOMEDRIVE "NAVWorking\Logs")

    )

    process{
        try {
            Write-Log "Import file $Path"
            if (-Not(Test-Path -PathType Leaf -Path $Path))
            {
                $Message = ("Imported file '{0}' cannot be found!" -f $Path)
                Write-Log $Message
                Throw $Message
            }
            $LogPath = Join-Path $LogPath "ImportFobOrTxt\$FileType"
            if(-Not(Test-Path $LogPath))
            {
                $null = New-Item -ItemType Directory -Path $LogPath -Force 
            }

            Import-NAVApplicationObject `
                -Path $Path `
                -DatabaseName $DatabaseName `
                -DatabaseServer $SQLServerInstance `
                -LogPath $LogPath `
                -ImportAction $ImportAction `
                -SynchronizeSchemaChanges $SynchronizeSchemaChanges `
                -Confirm:$false 
        }
        catch {
            Write-Exception $_.Exception
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

Export-ModuleMember -Function Import-FobOrTxtFile

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU8m+eEvTOPXw5KMu2YdVs2R6D
# Fm+gggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFHM5QCT6
# om7t4j85aMedkf9JqcSFMA0GCSqGSIb3DQEBAQUABIGAh6WWdNmjgPLMVG8btt/N
# aqYINPbdkCMGC12BoLuM6fwhz9ORfQ301JZCgsiSEbnB3dAVg42wmC07aVdn7ZE+
# ZvX7Sk5CqOpMLt21XqbaC7mPrKYSoFNuyac/Mw0lIsdPmQGfWZGSEwfxOgbsjgqj
# IxtK/xonBQ9KVNh6R1wCXPs=
# SIG # End signature block
