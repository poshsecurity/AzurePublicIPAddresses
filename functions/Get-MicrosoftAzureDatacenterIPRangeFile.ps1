function Get-MicrosoftAzureDatacenterIPRangeFile {
    <#
        .SYNOPSIS
        Downloads the Microsoft Azure Datacenter IP Ranges file
        .DESCRIPTION
        The Get-MicrosoftAzureDatacenterIPRangeFile cmdlet will download the Microsoft Azure Datacenter IP Ranges file from the Microsoft Downloads site (https://www.microsoft.com/en-us/download/details.aspx?id=41653).
        
        It should be noted that this file is updated on a weekly basis, so if you save this file, then you should re-download this file on a regular basis.
        
        This cmdlet makes use of Invoke-WebRequest.
        .EXAMPLE
        C:\PS> Get-MicrosoftAzureDatacenterIPRangeFile
        Returns an XML document from the Microsoft Azure Datacenter IP Ranges file
        .EXAMPLE
        C:\PS> Get-MicrosoftAzureDatacenterIPRangeFile -Path C:\Temp\AzureRanges.xml
        Dowloads the Microsoft Azure Datacenter IP Ranges file to C:\Temp\AzureRanges.xml
        .OUTPUTS
        XML document containing Azure Subnets, or
        Void if saving the file to the file system
    #>
    [CmdletBinding(DefaultParameterSetName = 'xml')]
    [OutputType([System.Xml.XmlDocument], ParameterSetName='path')]
    [OutputType([void], ParameterSetName='xml')]
    param(
        # Path where you want to save the XML file
        [Parameter(Mandatory = $false, ParameterSetName='path', Position = 0)]
        [String]
        $Path
    )
    
    $MicrosoftDownloadsURL = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=41653'
    $DownloadPage = Invoke-WebRequest -Uri $MicrosoftDownloadsURL
    $DownloadLink = ($DownloadPage.Links | Where-Object -FilterScript {$_.InnerText -eq 'Click here'}).href
        
    if ($PSCmdlet.ParameterSetName -eq 'path')
    {
        Invoke-WebRequest -Uri $DownloadLink -OutFile $Path
    }
    else 
    {
        $Request = Invoke-WebRequest -Uri $DownloadLink
        $RequestXML = Select-Xml -Content $Request.toString() -XPath /
        $RequestXML.Node
    }
}