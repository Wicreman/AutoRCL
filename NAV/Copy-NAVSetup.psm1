Function Copy-NAVSetup  {
    <#
    .SYNOPSIS
    Copy setup file from release build drop
    
    .DESCRIPTION
    \\vedfssrv01\DynNavFS\Releases\NAV\DynamicsNAV2016\Cumulative_Updates\2017-02\DE
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>

    Param(
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $BuildDropPath,

        [Parameter(Mandatory = $true)]
        [string]
        $BuildDate,

        [Parameter(Mandatory = $False)]
        [string]
        $BuildFlavor = "Cumulative_Updates",

        [Parameter(Mandatory = $true)]
        [string]
        $Language,

        [Parameter(Mandatory = $False)]
        [String]
        $Destination = (Join-Path $env:TEMP "NAVSetup")
    )

    Process{

        Write-Log "Preparing $Destination directory..."
        if (-Not(Test-Path $Destination)) {
            if (-Not(Test-Path $Destination -IsValid)) {
                $Message = ("Destination path '{0}' is not valid!" -f $Destination)
                Write-Log $Message
                Throw $Message
            }

            Write-Log ("Destination path '{0}' does not exist - creating..." -f $Destination)
            $null = New-Item -ItemType Directory $Destination -Force
        }

        Write-Log "Preparing directory to extract files to..."
        $ExtractToPath  = Join-Path $Destination "Extracted"
        if(Test-Path $ExtractToPath)
        {
            Write-Log "$ExtractToPath exists. Deleting..."
            Remove-Item $ExtractToPath -Force -Recurse
        }

        $Null = New-Item -ItemType Directory -Path $ExtractToPath -Force

        Write-Log "Looking for $BuildDropPath..."
        If (-Not (Test-Path -PathType Container $BuildDropPath))
        {
            $Message = ("Build drop path '{0}' cannot be found!" -f $BuildDropPath)
            Write-Log $Message
            Throw $Message
        }

        $BuildFlavorPath = Join-Path $BuildDropPath $BuildFlavor

        if (-Not ([String]::IsNullOrEmpty($BuildDate)))
        {
            $BuildDatePath = Join-Path $BuildFlavorPath $BuildDate
            Write-Log "Looking for $BuildDatePath..."
            if(Test-Path -PathType Container $BuildDatePath)
            {
                $BuildDropPath = $BuildDatePath
            }
            else 
            {

                Write-Log ("Build Date '{0}' in build drop path '{1}' cannot be found! Assuming that it is already included..." -f $BuildDate, $BuildDropPath)
            }
        }

        if (-Not ([String]::IsNullOrEmpty($Language)))
        {
            $BuildDropPath = Join-Path $BuildDropPath $Language
            Write-Log "Looking for $BuildDropPath..."
            if(-Not(Test-Path -PathType Container $BuildDropPath))
            {
                $Message = ("Build Language '{0}' cannot be found for the build in path '{1}'!" -f $Language, $BuildDropPath)
                Write-Log $Message
                Throw $Message
            }
        }

        Push-Location $BuildDropPath
        $BuilPackge = Get-ChildItem * | where { $_.Name -match ".*NAV.*\.zip"}
        Pop-Location

        if($BuilPackge -eq $null)
        {
            $Message = ("Could not find any build package in path '{0}'!" -f $BuildDropPath)
            Write-Log $Message
            Throw $Message
        }
        
        Write-Log ("Found build package {0}." -f $BuilPackge.FullName)

        $FileSize = $BuilPackge.Length / 1024 / 1024
        Write-Log ("Copying file {0} ({1:F2} MB) to {2}..." -f $BuilPackge.Name, $FileSize, $Destination)
        Try
        {
            $BuilPackge = Copy-Item -Path $BuilPackge.FullName -Destination $Destination -Force -PassThru
        }
        Catch
        {
            $Message = ("Copy failed! Error message: {0}" -f $_.Message)
            Write-Log $Message
            Throw $Message
        }

        Push-Location $Destination
        Expand-ZipFile -zipfile $BuilPackge.FullName -outpath ExtractToPath
        Pop-Location

        $ExtractToDVDPath = Join-Path $ExtractToPath "DVD"

        Push-Location $ExtractToPath
        $BuilDVDPackge = Get-ChildItem * | where { $_.Name -match ".*DVD.*\.zip"}
        if($BuilDVDPackge -eq $null)
        {
            $Message = ("Could not find any DVD package in path '{0}'!" -f $ExtractToPath)
            Write-Log $Message
            Throw $Message
        }
        else 
        {
            $null = New-Item -ItemType Directory -Path $ExtractToDVDPath -Force
        }
        
        Expand-ZipFile -zipfile $BuilDVDPackge.FullName -outpath ExtractToDVDPath
        Pop-Location

        Push-Location ExtractToDVDPath

        If(-Not (Test-Path (Join-Path $ExtractToDVDPath "Setup.exe")))
        {
            $Message = ("Could not find Setup.exe in path '{0}'!" -f $ExtractToDVDPath)
            Write-Log $Message
            Throw $Message
        }
        Pop-Location

        Return ExtractToDVDPath
    }
}