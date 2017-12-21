function Add-Admin  {
    [CmletBingding()]
    param(
        # Local or Remote machine name
        [Parameter(Mandatory =$true)]
        [string]
        $ComputerName = $ENV:COMPUTERNAME,

        [Parameter(Mandatory =$true)]
        [string]
        $User = $env:USERNAME,

        [Parameter(Mandatory =$true)]
        [string]
        $Domain =$env:USERDNSDOMAIN
    )
    process{
        try {
            Invoke-Command -Computername localhost -Cred $Cred -ScriptBlock {
                param ($User, $Domain, $ComputerName)
                $Group = [ADSI]("WinNT://$ComputerName/Administrators,Group")
                $Group.add("WinNT://$Domain/$User,user")
            } -ArgumentList $User, $Domain, $ComputerName
        }
        catch {

            Write-Exception $_.Exception
        }      
    }
}

Export-ModuleMember -Function Add-Admin