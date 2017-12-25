<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-NAVServerServiceAccount  {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $NAVServerServiceAccount
    )

    process{
        # TODO: Update service account
    }
}

Export-ModuleMember -Function Set-NAVServerServiceAccount