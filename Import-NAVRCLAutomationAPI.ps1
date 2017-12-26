
Get-module  -name "NAVRCLAPI" | Remove-Module
Import-Module (Join-Path $PSScriptRoot "NAVRCLAPI.psm1") -Verbose -Force

if(-Not(Get-Module -ListAvailable -Name "Pester"))
{
    (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression 
    Install-Module Pester 
}