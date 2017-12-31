param(
    # Product Version
    [Parameter(Mandatory = $true)]
    [string]
    $Version
)

Describe "Setup for Dynamics $ProductVersion"  -Tag "A" {
    $testCases = @(  
        @{ language = 'AT'}
        @{ language = 'US'}
        @{ language = 'CZ'}
        @{ language = 'FR'}
        @{ language = 'CH'}
        @{ language = 'DE'}
        @{ language = 'LL'}
        )

    It 'Test Language <language> ' -TestCases $testCases {
        param ($language)

        $language | Should Not be 'AA'
    }
}

Describe "Dynamics $ProductVersion" -Tag "B"{
    $testCases = @( 
        @{ language = 'AT'}
        @{ language = 'US'}
        @{ language = 'CZ'}
        @{ language = 'FR'}
        @{ language = 'CH'}
        @{ language = 'DE'}
        @{ language = 'LL'}
        )

    It 'Test Language <language> ' -TestCases $testCases {
        param ($language)

        $language | Should be 'AA'
    }

    It 'Other <language> ' -TestCases $testCases {
        param ($language)

        $language | Should be 'AA'
    }

    It 'Third <language> ' -TestCases $testCases {
        param ($language)

        $language | Should be 'AA'
    }
}