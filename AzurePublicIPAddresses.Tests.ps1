Import-Module $PSScriptRoot\AzurePublicIPAddresses.psm1 -Force -Verbose


Describe 'AzurePublicIPAddresses' {
    Context 'Script Analyzer' {
        It 'Does not have any issues with the Script Analyser - Get-MicrosoftAzureDatacenterIPRange' {
            Invoke-ScriptAnalyzer $PSScriptRoot\Functions\Get-MicrosoftAzureDatacenterIPRange.ps1 | Should be $null
        }
        It 'Does not have any issues with the Script Analyser - Get-MicrosoftAzureDatacenterIPRangeFile' {
            Invoke-ScriptAnalyzer $PSScriptRoot\Functions\Get-MicrosoftAzureDatacenterIPRangeFile.ps1 | Should be $null
        }
    }
}