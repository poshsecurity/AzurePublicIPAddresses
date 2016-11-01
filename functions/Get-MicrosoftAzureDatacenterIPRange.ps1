#requires -Version 4.0
function Get-MicrosoftAzureDatacenterIPRange  
{
    <#
            .SYNOPSIS
            Gets the IP ranges associated with Azure regions in CIDR format.
            .DESCRIPTION
            The Get-MicrosoftAzureDatacenterIPRange cmdlet gets a list of subnets in CIDR format (eg 192.168.1.0/24). A specific region can be specified, otherwise this cmdlet will return all subnets from all regions.
        
            The cmdlet gets the information from the Microsoft Azure Datacenter IP Ranges file, this is updated weekly, and is available for download from: https://www.microsoft.com/en-us/download/details.aspx?id=41653.
            
            If a path to the above file is not specified, then this CMDLet will download the file and store it in memory. Note, it will only do this once per execution.
            
            If no region is specified, then all subnets for all regions will be returned.
            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRange -AzureRegion 'North Central US'
            Returns all of the subnets in the North Central US DC, will download the Microsoft Azure Datacenter IP Ranges file into memory
            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRange -Path C:\Temp\AzureRanges.xml -AzureRegion 'North Central US'
            Returns all of the subnets in the North Central US DC based on the specified file
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
                'West Europe',
                'East US',
                'East US 2',
                'West US',
                'North Central US',
                'North Europe',
                'Central US',
                'East Asia',
                'Southeast Asia',
                'South Central US',
                'Japan West',
                'Japan East',
                'Brazil South',
                'Australia East',
                'Australia Southeast',
                'Central India',
                'West India',
                'South India',
                'Canada Central',
                'Canada East',
                'West Central US',
                'West US 2',
                'UK South',
                'UK West'
        )]
        [String]
        $AzureRegion,
        
        # Path to Microsoft Azure Datacenter IP Ranges file
        [Parameter(Mandatory = $false, 
                   Position  = 1)]
        [ValidateScript({Test-Path -Path $_})]
        [String]
        $Path
    )
    
    begin 
    {
        if ($PSBoundParameters.ContainsKey('path'))
        {
            # Read the file
            $PublicIPXML = [xml](Get-Content -Path $Path)
        }
        else 
        {
            if ($null -eq $Script:PublicIPXML)
            {
                Write-Verbose -Message 'Fetching data file'        
                $Script:PublicIPXML = Get-MicrosoftAzureDatacenterIPRangeFile
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
        }
    }
    
    process 
    {
        # Are we selecting a specific region or returing all subnets?
        if ($PSBoundParameters.ContainsKey('AzureRegion'))
        {
            # Translate the friendly region name to the backend names
            $BackendRegionName = $AzureRegions[$AzureRegion]
                        
            Write-Verbose -Message "Backend region $BackendRegionName"
            $Subnets = ($PublicIPXML.AzurePublicIpAddresses.Region.where({$_.name -eq $BackendRegionName})).iprange.subnet
            foreach ($Subnet in $Subnets) 
            {
                $OutputObject = [PSCustomObject]@{
                    Region = $AzureRegion
                    Subnet = $Subnet
                }
                Write-Output -InputObject $OutputObject
            }
        }
        else 
        {
            $Regions = $PublicIPXML.AzurePublicIpAddresses.Region

            foreach ($Region in $Regions) 
            {
                $BackendRegionName = $Region.Name
                
                # Translate each region name to something friendly
                $AzureRegion = $AzureRegions.GetEnumerator().Where({$_.Value -eq $BackendRegionName}).Name
                                
                Write-Verbose -Message "Azure Region Name $AzureRegion"
                
                # Create the output object
                foreach ($Subnet in $Region.IpRange) 
                {
                    $OutputObject = [PSCustomObject]@{
                        Region = $AzureRegion
                        Subnet = $Subnet.Subnet
                    }
                    Write-Output -InputObject $OutputObject
                }
            }
        }
    }
}
