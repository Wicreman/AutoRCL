function Invoke-ProcessWithProgress
{
    [CmdletBinding()]
    param 
        (
            [parameter(Mandatory=$true)]
            [string] 
            $FilePath,
            [parameter(Mandatory=$true)]
            [string] 
            $ArgumentList,
            [parameter(Mandatory=$true)]
            [int] 
            $TimeOutSeconds
        )
    PROCESS 
    {
        $process = Start-Process `
            -FilePath $FilePath `
            -PassThru `
            -ErrorAction SilentlyContinue `
            -ArgumentList $ArgumentList

        $milliSecBetweenPolls = $TimeOutSeconds * 10
        $percent = 0;

        while (!$process.WaitForExit($milliSecBetweenPolls)) {
            $percent = $percent + 1;

            if ($percent -eq 100) {
                Stop-Process $process.Id -Force
                Write-Error "The setup program did not complete within the expected time, the setup was aborted."
                break
            }

            Write-Progress `
                -Activity "Installing..." `
                -PercentComplete $percent `
                -CurrentOperation "$percent% complete" `
                -Status "Please wait."
        }

        Write-Progress -Activity "Installing..." -PercentComplete 100 -Status "Done."
    }
}

Export-ModuleMember  Invoke-ProcessWithProgress