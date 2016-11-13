#requires -Version 3.0

function Get-MicrosoftAzureDatacenterIPRangeFile 
{
    <#
            .SYNOPSIS
            Downloads either the Microsoft Azure Datacenter IP Ranges file, or the Windows Azure Datacenter IP Ranges in China file. The file can be stored in memory or to the file system.
            
            .DESCRIPTION           
            This CMDLet will download either of the two files:
                Microsoft Azure Datacenter IP Ranges (https://www.microsoft.com/en-us/download/details.aspx?id=41653)
                Windows Azure Datacenter IP Ranges in China (https://www.microsoft.com/en-us/download/details.aspx?id=42064)

            If the -ChinaRegion parameter is not specified, then Microsoft Azure Datacenter IP Ranges is downloaded.
            If the -ChinaRegion parameter is specified, then Windows Azure Datacenter IP Ranges in China is downloaded.
       
            It should be noted that this file is updated on a weekly basis, so if you save these file, then you should re-download them on a regular basis.
        
            This cmdlet makes use of Invoke-WebRequest.
            
            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRangeFile
            Returns an XML document from the Microsoft Azure Datacenter IP Ranges file
            
            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRangeFile -Path C:\Temp\AzureRanges.xml
            Dowloads the Microsoft Azure Datacenter IP Ranges file to C:\Temp\AzureRanges.xml

            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRangeFile -ChinaRegion
             Returns an XML document from the Microsoft Azure Datacenter IP Ranges in China file

            .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRangeFile -ChinaRegion -Path C:\Temp\AzureRangesChina.xml
            Downloads the Microsoft Azure Datacenter IP Ranges in China file to C:\Temp\AzureRangesChina.xml
            
            .OUTPUTS
            XML document containing Azure Subnets, or
            Void if saving the file to the file system
    #>
    [CmdletBinding(DefaultParameterSetName = 'xml')]
    [OutputType([System.Xml.XmlDocument], ParameterSetName = 'path')]
    [OutputType([void], ParameterSetName = 'xml')]
    param(
        # Path where you want to save the XML file
        [Parameter(Mandatory        = $false,
                   ParameterSetName = 'path',
                   Position         = 0)]
        [String]
        $Path,

        # Download China Region File
        [Parameter(Mandatory        = $false,
                   Position         = 1)]
        [Switch]
        $ChinaRegion
    )

    if ($PSBoundParameters.ContainsKey('ChinaRegion') -and $ChinaRegion)
    {   
        Write-Verbose -Message 'Downloading... Windows Azure Datacenter IP Ranges in China'
        $MicrosoftDownloadsURL = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=42064'
    }
    else
    {
        Write-Verbose -Message 'Downloading... Microsoft Azure Datacenter IP Ranges'
        $MicrosoftDownloadsURL = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=41653'
    }
        
    $DownloadPage = Invoke-WebRequest -UseBasicParsing -Uri $MicrosoftDownloadsURL
    $DownloadLink = ($DownloadPage.Links | Where-Object -FilterScript {$_.outerHTML -match 'Click here' -and $_.href -match '.xml'}).href[0]
        
    if ($PSCmdlet.ParameterSetName -eq 'path')
    {
        Write-Verbose -Message ('Saving file to {0}' -f $Path)
        Invoke-WebRequest -UseBasicParsing -Uri $DownloadLink -OutFile $Path
    }
    else 
    {
        Write-Verbose -Message 'Downloading and creating XML object'
        $Request = Invoke-WebRequest -UseBasicParsing -Uri $DownloadLink
        $RequestXML = Select-Xml -Content $Request.toString() -XPath /
        $RequestXML.Node
    }
}
