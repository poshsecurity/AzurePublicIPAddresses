#requires -Version 4.0
function Get-MicrosoftAzureDatacenterIPRange
{
    <#
            .SYNOPSIS
            Gets the IP ranges associated with Azure regions in CIDR format.

            .DESCRIPTION
            The Get-MicrosoftAzureDatacenterIPRange cmdlet gets a list of subnets in CIDR format (eg 192.168.1.0/24). You can get the ranges for a specific region, or get all subnets for all regions.

            There are three files that contain all the information that this CMDLet uses:
                Microsoft Azure Datacenter IP Ranges file (https://www.microsoft.com/en-us/download/details.aspx?id=41653)
                Windows Azure Datacenter IP Ranges in China (https://www.microsoft.com/en-us/download/details.aspx?id=42064)
                Windows Azure Datacenter IP Ranges in Germany (https://www.microsoft.com/en-us/download/details.aspx?id=54770)

            These files are updated each week.

            If the -path parameter is omitted, then the CMDLet will download both files and store them in memory (it doesn't save them to disk). The CMDLet will not download the file upon each execution,
            as it checks to see if the file has already been stored in memory.

            If you specify -path, the CMDLet will generate warnings that not all regions will be available. This is by design. I will look at handling both files saved to the file system in a later release.

            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'North Central US'
            Returns all of the subnets in the North Central US regions, will download the Microsoft Azure Datacenter IP Ranges file into memory

            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRange -AzureRegion @('North Central US', 'West India')
            Returns all of the subnets in the North Central US and West India regions, will download the Microsoft Azure Datacenter IP Ranges file into memory

            .EXAMPLE
            C:\PS> @('Japan West', 'Japan East') | Get-MicrosoftAzureDatacenterIPRange
            Returns all of the subnets in the Japan West and East regions, will download the Microsoft Azure Datacenter IP Ranges file into memory

            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRange -Path C:\Temp\AzureRanges.xml -AzureRegion 'North Central US'
            Returns all of the subnets in the North Central US region based on the specified file

            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRange
            Returns all of the subnets used by Azure, will download the Microsoft Azure Datacenter IP Ranges file into memory

            .INPUTS
            Can take Azure region names from the pipeline.

            .OUTPUTS
            Outputs objects containing each subnet and their region.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        # Azure Datacenter/region
        [Parameter(Mandatory         = $false,
                   Position          = 0,
                   ValueFromPipeline = $true)]
        [ValidateSet(
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
            'North Europe 2',  #Placeholder until azure region name is confirmed
            'East Europe',     #Placeholder until azure region name is confirmed
            'Korea South 2',    #Placeholder until azure region name is confirmed
            'Brazil Southeast', #Placeholder until azure region name is confirmed
            'Brazil Northeast', #Placeholder until azure region name is confirmed
            'Chile Central'    #Placeholder until azure region name is confirmed
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $AzureRegion,

        # Path to Microsoft Azure Datacenter IP Ranges file
        [Parameter(Mandatory = $false,
                   Position  = 1)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path -Path $_ -PathType Leaf})]
        [String]
        $Path
    )

    begin
    {
        if ($PSBoundParameters.ContainsKey('path'))
        {
            # Read the file
            $PublicIPXML = [xml](Get-Content -Path $Path)
            $Script:Regions = $PublicIPXML.AzurePublicIpAddresses.Region

            # Display warning stating that some regions may not be available
            Write-Warning -Message 'Using -Path may result in some regions being unavailable and returning no values.'
        }
        else
        {
            if ($null -eq $Script:Regions)
            {
                Write-Verbose -Message 'Fetching the standard region data file'
                $Script:Regions = (Get-MicrosoftAzureDatacenterIPRangeFile).AzurePublicIpAddresses.Region

                Write-Verbose -Message 'Fetching the China region file'
                $Script:Regions += (Get-MicrosoftAzureDatacenterIPRangeFile -Region 'China').AzurePublicIpAddresses.Region

                Write-Verbose -Message 'Fetching the Germany region file'
                $Script:Regions += (Get-MicrosoftAzureDatacenterIPRangeFile -Region 'Germany').AzurePublicIpAddresses.Region
            }
        }

        # Define the region mappings (What we see in the portal to the names in the file)
        $AzureRegions = @{
            'West Europe'         = 'EuropeWest'
            'East US'             = 'USEast'
            'East US 2'           = 'USEast2'
            'West US'             = 'USWest'
            'North Central US'    = 'USNorth'
            'North Europe'        = 'EuropeNorth'
            'Central US'          = 'USCentral'
            'East Asia'           = 'AsiaEast'
            'Southeast Asia'      = 'AsiaSouthEast'
            'South Central US'    = 'USSouth'
            'Japan West'          = 'JapanWest'
            'Japan East'          = 'JapanEast'
            'Brazil South'        = 'BrazilSouth'
            'Australia East'      = 'AustraliaEast'
            'Australia Southeast' = 'AustraliaSoutheast'
            'Central India'       = 'IndiaCentral'
            'West India'          = 'IndiaWest'
            'South India'         = 'IndiaSouth'
            'Canada Central'      = 'CanadaCentral'
            'Canada East'         = 'CanadaEast'
            'West Central US'     = 'USWestCentral'
            'West US 2'           = 'USWest2'
            'UK South'            = 'UKSouth'
            'UK West'             = 'UKWest'
            'China North'         = 'chinanorth'
            'China East'          = 'chinaeast'
            'Central US EUAP'     = 'uscentraleuap'
            'East US 2 EUAP'      = 'useast2euap'
            'Korea South'         = 'koreasouth'
            'Korea Central'       = 'koreacentral'
            'France Central'      = 'francec'
            'France South'        = 'frances'
            'Germany Central'     = 'germanycentral'
            'Germany Northeast'   = 'germanynortheast'
            'Australia Central'   = 'australiac'
            'Australia Central 2' = 'australiac2'
            'UK North'            = 'uknorth'
            'UK South 2'          = 'uksouth2'
            'North Europe 2'      = 'europenorth2' #Placeholder until azure region name is confirmed
            'East Europe'         = 'europeeast' #Placeholder until azure region name is confirmed
            'Korea South 2'       = 'koreas2' #Placeholder until azure region name is confirmed
            'Brazil Southeast'    = 'brazilse' #Placeholder until azure region name is confirmed
            'Brazil Northeast'    = 'brazilne' #Placeholder until azure region name is confirmed
            'Chile Central'       = 'chilec' #Placeholder until azure region name is confirmed
        }
    }

    process
    {
        # Are we selecting a specific region or returing all subnets?
        if ($PSBoundParameters.ContainsKey('AzureRegion'))
        {
            #We need to process this as we may have one or many regions specified in $AzureRegion
            foreach ($Region in $AzureRegion)
            {
                # Translate the friendly region name to the backend names
                $BackendRegionName = $AzureRegions[$Region]

                Write-Verbose -Message "Backend region: $BackendRegionName"
                $Subnets = ($Regions.where({$_.name -eq $BackendRegionName})).iprange.subnet
                foreach ($Subnet in $Subnets)
                {
                    $OutputObject = [PSCustomObject]@{
                        Region = $Region
                        Subnet = $Subnet
                    }
                    Write-Output -InputObject $OutputObject
                }
            }
        }
        else
        {
            foreach ($Region in $Regions)
            {
                $BackendRegionName = $Region.Name

                Write-Verbose -Message "Backend region: $BackedRegionName"

                # Translate each region name to something friendly
                $RegionName = $AzureRegions.GetEnumerator().Where({$_.Value -eq $BackendRegionName}).Name
                if ($null -eq $RegionName) {
                    Write-Warning -Message "Could not find Azure Region: $BackendRegionName"
                }

                Write-Verbose -Message "Azure Region Name: $RegionName"

                # Create the output object
                foreach ($Subnet in $Region.IpRange)
                {
                    $OutputObject = [PSCustomObject]@{
                        Region = $RegionName
                        Subnet = $Subnet.Subnet
                    }
                    Write-Output -InputObject $OutputObject
                }
            }
        }
    }
}
