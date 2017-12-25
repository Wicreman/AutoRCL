Import-Module -Name "NAVTool"
Describe "TestCasesFor146968 NAV2017" {

    $Version = "NAV2017"
    $BuildDate = "2018-01"
    BeforeEach { 
        Uninstall-NAVAll
    }
    
    It "DE" -test {
        #Update Regional Formart
        $language = "DE"
        Update-RegionalFormat -Language $Language

        $paramDE = @{
            Version = $
            BuildDate = $buildDate
            Language = $Language
        }

        Install-NAV @paramDE | Should -Be 1
    }

    It "AT" -test {
        #Update Regional Formart
        $language = "DE"
        Update-RegionalFormat -Language $Language

        $paramDE = @{
            Version = $
            BuildDate = $buildDate
            Language = $Language
        }

        Install-NAV @paramDE | Should -Be 1
    }

    AfterEach {
        Uninstall-NAVAll
    }
}