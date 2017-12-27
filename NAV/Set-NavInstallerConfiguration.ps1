function Set-NavInstallerConfiguration
{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string] $SetupConfigFile, 

        [parameter(ParameterSetName="Component", Mandatory=$false)]
        [string] $ComponentId,

        [parameter(ParameterSetName="Component", Mandatory=$false)]
        [string] $ComponentState,

        [parameter(ParameterSetName="Component", Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $ComponentShowOptionNode = "Yes",

        [parameter(ParameterSetName="Parameter", Mandatory=$false)]
        [string] $ParameterId,

        [parameter(ParameterSetName="Parameter", Mandatory=$false)]
        [AllowEmptyString()]
        [string] $ParameterValue
        )    
    PROCESS
    {                            
        if ((Test-Path $SetupConfigFile) -eq $false)
        {
            Write-Error "The config file used for NAV installation cannot be found: $SetupConfigFile"
            return
        }
                
        $document = [xml] (Get-Content $SetupConfigFile)       
        
        if(Test-Path -PathType Leaf -Path $SetupConfigFile)
        {
            Remove-Item $SetupConfigFile -Force
        }

        switch ($PsCmdlet.ParameterSetName) 
        {                    
            "Component"  { 
                            SetAddComponentIdStateOption $document "Configuration" $ComponentId $ComponentState $ComponentShowOptionNode
                            break
                         } 
            "Parameter"  { 
                            SetAddParameterIdValue $document "Configuration" $ParameterId $ParameterValue
                            break
                         } 
        } 

        $document.Save($SetupConfigFile)
    }

}

function SetAddComponentIdStateOption([xml] $document, [string] $parentNode, [string] $component, [string] $state, [string] $showOptionNode)
{	
    $node = $document.SelectSingleNode("//Component[@Id='$component']");
    if ($node -eq $null)                 
    {
        $node = $document.CreateElement('Component');
        $node.SetAttribute('Id', $component);
        $node.SetAttribute('State', $state);
        $node.SetAttribute('ShowOptionNode', $showOptionNode);		
         
        AppendNodeToXmlDocument $document $parentNode $node               
    }
    else
    {    
        $node.State = $state
        $node.ShowOptionNode = $showOptionNode
    }
}

function SetAddParameterIdValue([xml] $document, [string] $parentNode, [string] $key, [string] $value)
{	
    $node = $document.SelectSingleNode("//Parameter[@Id='$key']");
    if ($node -eq $null)                 
    {
        $node = $document.CreateElement('Parameter');
        $node.SetAttribute('Id', $key);
        $node.SetAttribute('Value', $value);		
        
        AppendNodeToXmlDocument $document $parentNode $node               
    }
    else
    {
        $node.Value = $value
    }
}

function AppendNodeToXmlDocument([xml] $document, [string] $parentNode, [System.Xml.XmlElement]$node)
{
    try
    {
        $document.SelectSingleNode($parentNode).AppendChild($node) | Out-Null
    }
    catch
    {
        Write-Error "Wrong formatted NAV Installer Configuration file. Node `"$parentNode`" not found.Original exception message: $_.Exception.Message."        
    }
}
Export-ModuleMember -Function Set-NavInstallerConfiguration

# SIG # Begin signature block
# MIIDzQYJKoZIhvcNAQcCoIIDvjCCA7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfIWjTbAXd2zR7TVrIheDIWFO
# 6OygggH1MIIB8TCCAV6gAwIBAgIQerav1OJGjJREr2hDMeEqHzAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFEtUTyPQ
# nwWgltiBc/+qymIUgQqEMA0GCSqGSIb3DQEBAQUABIGAmd4ZAPvZ+a1UCZdxrG0x
# N6jxAEevDntZ22AgCZAFJ4srLqx33pZgGgwpWNC+tNqias2vztwU676I8TRGvHzU
# 6zBlUo2Y2Ua5nqmK2JpX8lgQxMnJRtYgTT2tdt+VJPoOidh7unu01cFYwSpezgDr
# wxq3wu4UMeUNaQwcr42bCws=
# SIG # End signature block
