<#
.SYNOPSIS
    Unzip zip files
.DESCRIPTION
    Unzip zip files
#>

Function Expand-ZipFile
{
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $zipfile,

        [Parameter(Mandatory=$true)]
        [string]
        $outpath
    )
    
    process{
        if (Test-Path $outpath)
        {
            Get-ChildItem -Path $outpath -Recurse | Remove-Item -Force -Recurse
            Remove-Item $outpath -Force
        }
    
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    }
}

Export-ModuleMember Expand-ZipFile

# Optional commands to create a public alias for the function
New-Alias -Name Unzip -Value Expand-ZipFile
Export-ModuleMember -Alias Unzip