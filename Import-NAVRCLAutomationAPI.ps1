if(Get-module -name "NAVTool" -eq $null)
{
    (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex 
    Install-Module Pester 
}

Get-module -name "NAVTool" | Remove-Module
Import-Module (Join-Path $PSScriptRoot "NAVRCLAutomationAPI.psm1" -Verbose -Force