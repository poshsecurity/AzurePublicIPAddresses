Import-Module $PSScriptRoot\..\AzurePublicIPAddresses.psm1 -Force

Describe 'AzurePublicIPAddresses' {
    Context 'Get-MicrosoftAzureDatacenterIPRange Parameter validation' {
        It 'throws an error for an invalid region is specified' {
            {Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'nomansland'} | should throw
        }

        It 'throws an error for $null is specified for a region' {
            {Get-MicrosoftAzureDatacenterIPRange -AzureRegion $null} | should throw
        }

        It 'throws an error for an empty string is specified for a region' {
            {Get-MicrosoftAzureDatacenterIPRange -AzureRegion ''} | should throw
        }

        It 'throws an error for @() is specified for a region' {
            {Get-MicrosoftAzureDatacenterIPRange -AzureRegion @()} | should throw
        }

        It 'throws an error for @() is specified for a region 2' {
            {Get-MicrosoftAzureDatacenterIPRange -AzureRegion @('')} | should throw
        }

        It 'throws an error for $null is specified for a path' {
            {Get-MicrosoftAzureDatacenterIPRange -Path $null} | should throw
        }

        It 'throws an error for an empty string is specified for a path' {
            {Get-MicrosoftAzureDatacenterIPRange -Path ''} | should throw
        }

        It 'throws an error for an invalid path is specified for a path' {
            {Get-MicrosoftAzureDatacenterIPRange -Path 'C:\Windowsthisdoesnotexit\file.xml'} | should throw
        }

        It 'throws an error for an folder path is specified for a path' {
            {Get-MicrosoftAzureDatacenterIPRange -Path 'C:\Windows'} | should throw
        }
    }

    Context 'Get-MicrosoftAzureDatacenterIPRangeFile Parameter validation' {
        It 'throws an error for $null is specified for a path' {
            {Get-MicrosoftAzureDatacenterIPRangeFile -Path $null} | should throw
        }

        It 'throws an error for an empty string is specified for a path' {
            {Get-MicrosoftAzureDatacenterIPRangeFile -Path ''} | should throw
        }

        It 'throws an error for an invalid path is specified for a path' {
            {Get-MicrosoftAzureDatacenterIPRangeFile -Path 'C:\Windowsthisdoesnotexit\file.xml'} | should throw
        }

        It 'throws an error for an folder path is specified for a path' {
            {Get-MicrosoftAzureDatacenterIPRangeFile -Path 'C:\Windows'} | should throw
        }
    }

    Context 'Get-MicrosoftAzureDatacenterIPRange outputs results for each supported Azure region' {
        It 'returns output for West Europe' {
            Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'West Europe' | Should not be $null
        }

        $regions = @(
            'Australia Central',
            'Australia Central 2',
            'Australia East',
            'Australia Southeast',
            'Brazil South',
            'Canada Central',
            'Canada East',
            'Central India',
            'Central US EUAP',
            'Central US',
            'China East',
            'China North',
            'East Asia',
            'East US 2 EUAP',
            'East US 2',
            'East US',
            'France Central',
            'France South',
            'Germany Central',
            'Germany Northeast',
            'Japan East',
            'Japan West',
            'Korea Central',
            'Korea South',
            'North Central US',
            'North Europe',
            'South Central US',
            'South India',
            'Southeast Asia',
            'UK North',
            'UK South',
            'UK South 2',
            'UK West',
            'West Central US',
            'West Europe',
            'West India',
            'West US 2',
            'West US',
            'South Africa North',
            'South Africa West',
            'UAE North',
            'UAE Central',
            'Germany North',
            'Germany West Central',
            'Norway East',
            'Norway West',
            'Switzerland North',
            'Switzerland West'
        )

        foreach ($region in $regions) {
            It "returns output for $region" {
                Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'East US'| Should not be $null
            }
        }

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
