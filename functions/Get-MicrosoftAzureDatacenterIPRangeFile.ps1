function Get-MicrosoftAzureDatacenterIPRangeFile {
    <#
        .SYNOPSIS
            Downloads the Microsoft Azure Datacenter IP Ranges file
        .DESCRIPTION
            The Get-MicrosoftAzureDatacenterIPRangeFile cmdlet will download the Microsoft Azure Datacenter IP Ranges file from the Microsoft Downloads site.
            
            It should be noted that this file is updated on a weekly basis, and as such you should re-download this file on a regular basis.
            
            This cmdlet makes use of Invoke-WebRequest.
        .EXAMPLE
            C:\PS> Get-MicrosoftAzureDatacenterIPRangeFile -Path C:\Temp\AzureRanges.xml
            Dowloads the Microsoft Azure Datacenter IP Ranges file to C:\Temp\AzureRanges.xml
    #>
    [CmdletBinding()]
    param(
        # Path where you want to save the XML file
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $Path
    )
    
    $MicrosoftDownloadsURL = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=41653'
    $DownloadPage = Invoke-WebRequest -Uri $MicrosoftDownloadsURL
    $DownloadLink = ($DownloadPage.Links | Where-Object -FilterScript {$_.InnerText -eq 'Click here'}).href
    Invoke-WebRequest -Uri $DownloadLink -OutFile $Path
}