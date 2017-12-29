param(
    # Product Version
    [Parameter(Mandatory = $true)]
    [string]
    $ProductVersion
)

Describe "Setup for Dynamics $ProductVersion" {
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

Describe "Dynamics $ProductVersion" {
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

    It 'Other <language> ' -TestCases $testCases {
        param ($language)

        $language | Should Not be 'AA'
    }

    It 'Third <language> ' -TestCases $testCases {
        param ($language)

        $language | Should Not be 'AA'
    }
}