Describe "TestCasesFor146968" {
    
    BeforeEach {
        # TODO: Create self-working dir
        $navWorkingDir = join-path $env:HOMEDRIVE "NAVWorking"
        Write-Log "Preparing $Destination directory..."
        if (-Not(Test-Path $navWorkingDir)) {
            if (-Not(Test-Path $navWorkingDir -IsValid)) {
                $Message = ("NAV Working Directory '{0}' is not valid!" -f $navWorkingDir)
                Write-Log $Message
                Throw $Message
            }

            Write-Log ("navWorkingDir path '{0}' does not exist - creating..." -f $navWorkingDir)
            $null = New-Item -ItemType Directory $Destination -Force
        }
        
        # TODO: load required modoule

        # TODO: uninstall NAV

        

    }
    
    It "DE" -test {
        
    }

    AfterEach {

    }
}