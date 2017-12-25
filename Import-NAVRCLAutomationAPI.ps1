
Get-module -name "NAVTool" | Remove-Module
Import-Module (Join-Path $PSScriptRoot "NAVRCLAutomationAPI.psm1") -Verbose -Force

if(-Not(Get-Module -ListAvailable -Name "Pester"))
{
    (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex 
    Install-Module Pester 
}