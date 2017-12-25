Get-module -name "NAVTool" | Remove-Module
Import-Module (Join-Path $PSScriptRoot "NAVRCLAutomationAPI.psm1" -Verbose -Force