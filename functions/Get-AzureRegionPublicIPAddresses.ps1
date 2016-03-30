function Get-AzureRegionPublicIPAddresses {
    <#
    .SYNOPSIS
        Gets the IP ranges associated with Azure regions in CIDR format.
    .DESCRIPTION
        The Get-AzureRegionPublicIPAddresses cmdlet gets a list of subnets in CIDR format (eg 192.168.1.0/24). A specific region can be specified, otherwise this cmdlet will return all subnets from all regions.
        
        The cmdlet gets the information from the Microsoft Azure Datacenter IP Ranges file, this is updated weekly, and is available for download from: https://www.microsoft.com/en-us/download/details.aspx?id=41653
        
    .EXAMPLE
        C:\PS> <example usage>
        Explanation of what the example does
    .EXAMPLE
        C:\PS> <example usage>
        Explanation of what the example does
    .INPUTS
        Can take Azure region names from the pipeline.
    .OUTPUTS
        Outputs an array of subnets in CIDR format.
    #>
    
    [CmdletBinding()]
    param(       
        # Path to Microsoft Azure Datacenter IP Ranges file, this can be downloaded at: https://www.microsoft.com/en-us/download/details.aspx?id=41653
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({Test-Path -Path $_})]
        [String]
        $AzurePublicIPXML,
        
        # Azure Datacenter/region
        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true)]
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
        $AzureRegion
    )
    
    begin {
        $PublicIPXML = [xml](Get-Content $AzurePublicIPXML)
    }
    
    process {
        # Are we selecting a specific region or returing all subnets?
        if ($PSBoundParameters.ContainsKey('AzureRegion'))
        {
            # Translate the friendly region name to the backend names
            switch ($AzureRegion)
            {
                'West Europe'           { $BackendRegionName = 'EuropeWest'             }
                'East US'               { $BackendRegionName = 'USEast'                 }
                'East US 2'             { $BackendRegionName = 'USEast2'                }
                'US West'               { $BackendRegionName = 'USWest'                 }
                'North Central US'      { $BackendRegionName = 'USNorth'                }
                'North Europe'          { $BackendRegionName = 'EuropeNorth'            }
                'Central US'            { $BackendRegionName = 'USCentral'              }
                'East Asia'             { $BackendRegionName = 'AsiaEast'               }
                'Southeast Asia'        { $BackendRegionName = 'AsiaSouthEast'          }
                'South Central US'      { $BackendRegionName = 'USSouth'                }
                'Japan West'            { $BackendRegionName = 'JapanWest'              }
                'Japan East'            { $BackendRegionName = 'JapanEast'              }
                'Brazil South'          { $BackendRegionName = 'BrazilSouth'            }
                'Australia East'        { $BackendRegionName = 'AustraliaEast'          }
                'Australia Southeast'   { $BackendRegionName = 'AustraliaSoutheast'     }
                'Central India'         { $BackendRegionName = 'IndiaCentral'           }
                'West India'            { $BackendRegionName = 'IndiaWest'              }
                'South India'           { $BackendRegionName = 'IndiaSouth'             }
            }
            
            Write-Verbose -Message "Backend region $BackendRegionName"
            Write-Output -InputObject ($PublicIPXML.AzurePublicIpAddresses.Region | Where-Object -FilterScript {$_.name -eq $BackendRegionName}).iprange.subnet   
        }
        else 
        {Write-Output -InputObject $PublicIPXML.AzurePublicIpAddresses.Region.iprange.subnet}
    }
}