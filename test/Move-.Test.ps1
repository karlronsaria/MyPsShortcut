. $PsScriptRoot\..\script\Move-.ps1

Describe 'Get-ItemDateTime' {
    It 'Called without arguments' {
        { Get-ItemDateTime } | Should Not Throw
    }

    $resPath = "$PsScriptRoot\res"
    $filePath = "$resPath\File.txt"

    $dateTimeProperties = @(
          "CreationTime"
        , "CreationTimeUtc"
        , "LastAccessTime"
        , "LastAccessTimeUtc"
        , "LastWriteTime"
        , "LastWriteTimeUtc"
    )

    It 'Called with a file name' {
        $result = Get-ItemDateTime `
            -Path $filePath

        diff ($result.Keys | Out-String) ($dateTimeProperties | Out-String) `
            | Should Be $null
    }

    $dateTimeFormat = 'yyyy_MM_dd_HHmmss'
    $dateTimePattern = '\d{4}(_\d{2}){2}_\d{6}'

    function ConvertTo-DateTimeString {
        Param(
            [DateTime]
            $Date,

            [String]
            $Format = $dateTimeFormat
        )

        return Get-Date `
            -Date $Date `
            -Format $Format
    }

    It "Called with a file name and valid Property pattern '<Pattern>'" -TestCases @(
        @{ Pattern = '*' }
        @{ Pattern = '*Time' }
        @{ Pattern = '*Utc' }
        @{ Pattern = '*U*' }
        @{ Pattern = 'CreationTime' }
    ) {
        Param ($Pattern, $Expected)

        $result = Get-ItemDateTime `
            -Path $filePath `
            -Property $Pattern

        @($result).Count | Should BeGreaterThan 0

        foreach ($item in $result) {
            ConvertTo-DateTimeString `
                -Date $item `
                | Should Match $dateTimePattern
        }
    }

    It "Called with a file name and invalid Property pattern '<Pattern>'" -TestCases @(
        @{ Pattern = 'WhatThe' }
    ) {
        Param ($Pattern, $Expected)

        $result = Get-ItemDateTime `
            -Path $filePath `
            -Property $Pattern

        @($result).Count | Should Be 0
    }
}
