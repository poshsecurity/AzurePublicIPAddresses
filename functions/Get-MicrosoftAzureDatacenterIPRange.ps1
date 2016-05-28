#requires -Version 2
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
    param(              
        # Azure Datacenter/region
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true)]
        [ValidateSet(
                'West Europe',
                'East US',
                'East US 2',
                'US West',
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
                'South India'
        )]
        [String]
        $AzureRegion,
        
        # Path to Microsoft Azure Datacenter IP Ranges file
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateScript({Test-Path -Path $_})]
        [String]
        $Path
    )
    
    begin 
    {
        if ($PSBoundParameters.ContainsKey('path'))
        {
            # Read the file
            $PublicIPXML = [xml](Get-Content $Path)
        }
        else 
        {
            if ($null -eq $Script:PublicIPXML)
            {
                Write-Verbose -Message 'Fetching data file'        
                $Script:PublicIPXML = Get-MicrosoftAzureDatacenterIPRangeFile
            }
        }
    }
    
    process {
        # Are we selecting a specific region or returing all subnets?
        if ($PSBoundParameters.ContainsKey('AzureRegion'))
        {
            # Translate the friendly region name to the backend names
            switch ($AzureRegion)
            {
                'West Europe'         { $BackendRegionName = 'EuropeWest'         }
                'East US'             { $BackendRegionName = 'USEast'             }
                'East US 2'           { $BackendRegionName = 'USEast2'            }
                'US West'             { $BackendRegionName = 'USWest'             }
                'North Central US'    { $BackendRegionName = 'USNorth'            }
                'North Europe'        { $BackendRegionName = 'EuropeNorth'        }
                'Central US'          { $BackendRegionName = 'USCentral'          }
                'East Asia'           { $BackendRegionName = 'AsiaEast'           }
                'Southeast Asia'      { $BackendRegionName = 'AsiaSouthEast'      }
                'South Central US'    { $BackendRegionName = 'USSouth'            }
                'Japan West'          { $BackendRegionName = 'JapanWest'          }
                'Japan East'          { $BackendRegionName = 'JapanEast'          }
                'Brazil South'        { $BackendRegionName = 'BrazilSouth'        }
                'Australia East'      { $BackendRegionName = 'AustraliaEast'      }
                'Australia Southeast' { $BackendRegionName = 'AustraliaSoutheast' }
                'Central India'       { $BackendRegionName = 'IndiaCentral'       }
                'West India'          { $BackendRegionName = 'IndiaWest'          }
                'South India'         { $BackendRegionName = 'IndiaSouth'         }
            }
            
            Write-Verbose -Message "Backend region $BackendRegionName"
            $Subnets = ($PublicIPXML.AzurePublicIpAddresses.Region | Where-Object -FilterScript {$_.name -eq $BackendRegionName}).iprange.subnet
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
                switch ($BackendRegionName)
                {
                    'EuropeWest'         { $AzureRegion = 'West Europe'         }
                    'USEast'             { $AzureRegion = 'East US'             }
                    'USEast2'            { $AzureRegion = 'East US 2'           }
                    'USWest'             { $AzureRegion = 'US West'             }
                    'USNorth'            { $AzureRegion = 'North Central US'    }
                    'EuropeNorth'        { $AzureRegion = 'North Europe'        }
                    'USCentral'          { $AzureRegion = 'Central US'          }
                    'AsiaEast'           { $AzureRegion = 'East Asia'           }
                    'AsiaSouthEast'      { $AzureRegion = 'Southeast Asia'      }
                    'USSouth'            { $AzureRegion = 'South Central US'    }
                    'JapanWest'          { $AzureRegion = 'Japan West'          }
                    'JapanEast'          { $AzureRegion = 'Japan East'          }
                    'BrazilSouth'        { $AzureRegion = 'Brazil South'        }
                    'AustraliaEast'      { $AzureRegion = 'Australia East'      }
                    'AustraliaSoutheast' { $AzureRegion = 'Australia Southeast' }
                    'IndiaCentral'       { $AzureRegion = 'Central India'       }
                    'IndiaWest'          { $AzureRegion = 'West India'          }
                    'IndiaSouth'         { $AzureRegion = 'South India'         }
                }
                
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