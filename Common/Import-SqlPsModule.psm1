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