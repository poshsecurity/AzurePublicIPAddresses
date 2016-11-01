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

    Context 'Get-MicrosoftAzureDatacenterIPRange outputs results for each supported Azure region' {
        It 'returns output for West Europe' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'West Europe' | Should not be $null
        }

        It 'returns output for East US' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'East US'| Should not be $null
        }

        It 'returns output for East US 2' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'East US 2' | Should not be $null
        }

        It 'returns output for West US' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'West US' | Should not be $null
        }

        It 'returns output for North Central US' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'North Central US' | Should not be $null
        }

        It 'returns output for North Europe' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'North Europe' | Should not be $null
        }

        It 'returns output for Central US' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Central US' | Should not be $null
        }

        It 'returns output for East Asia' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'East Asia' | Should not be $null
        }

        It 'returns output for Southeast Asia' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Southeast Asia' | Should not be $null
        }

        It 'returns output for South Central US' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'South Central US' | Should not be $null
        }

        It 'returns output for Japan West' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Japan West' | Should not be $null
        }

        It 'returns output for Japan East' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Japan East' | Should not be $null
        }

        It 'returns output for Brazil South' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Brazil South' | Should not be $null
        }

        It 'returns output for Australia East' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Australia East' | Should not be $null
        }

        It 'returns output for Australia Southeast' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Australia Southeast' | Should not be $null
        }

        It 'returns output for Central India' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Central India' | Should not be $null
        }

        It 'returns output for West India' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'West India' | Should not be $null
        }

        It 'returns output for South India' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'South India' | Should not be $null
        }

        It 'returns output for Canada Central' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Canada Central' | Should not be $null
        }

        It 'returns output for Canada East' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'Canada East' | Should not be $null
        }

        It 'returns output for West Central US' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'West Central US' | Should not be $null
        }

        It 'returns output for West US 2' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'West US 2' | Should not be $null
        }

        It 'returns output for UK South' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'UK South' | Should not be $null
        }

        <# Currently this region appears to be missing from the file (is available in Azure though)
        It 'returns output for UK West' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'UK West' | Should not be $null
        }
        #>
        It 'accepts an Azure region from the pipeline' {
            {'West US 2' | Get-MicrosoftAzureDatacenterIPRange} | Should not be $null
        }

        It 'accepts multiple Azure regions from the pipeline' {
            { @('West US 2', 'Canada East') | Get-MicrosoftAzureDatacenterIPRange} | Should not be $null
        }

        It 'returns values if no region is specified' {
            Get-MicrosoftAzureDatacenterIPRange | Should not be $null
        }
    }

    Context 'File operations' {
        $TestPath = "TestDrive:\test.txt"

        It 'Get-MicrosoftAzureDatacenterIPRangeFile saves the IP range file as specified' {
            $Test = Get-MicrosoftAzureDatacenterIPRangeFile -Path $TestPath
            $Test | Should be $null
            Test-Path -Path $TestPath | Should be $true
        }

        It 'Get-MicrosoftAzureDatacenterIPRange reads from the IP range file if specifies' {
            Get-MicrosoftAzureDatacenterIPRange -Path $TestPath | should not be $null
        }
    }

    Context 'Get-MicrosoftAzureDatacenterIPRangeFile' {
        It 'outputs an xml document if no path is specified' {
            $null -ne  (Get-MicrosoftAzureDatacenterIPRangeFile).AzurePublicIpAddresses | should be $true
            $null -ne  (Get-MicrosoftAzureDatacenterIPRangeFile).AzurePublicIpAddresses.Region | should be $true
        }
    }
}
