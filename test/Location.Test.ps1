. $PsScriptRoot\..\script\Location.ps1

Describe 'Set-Location' {
    It 'Called without arguments' {
        Set-Location | Should Be (Get-Location).Path
    }
}
