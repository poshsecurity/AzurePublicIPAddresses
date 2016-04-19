function Get-MicrosoftAzureDatacenterIPRangeFile {
    <#
        .SYNOPSIS
            Short description
        .DESCRIPTION
            Long description
        .EXAMPLE
            C:\PS> <example usage>
            Explanation of what the example does
        .INPUTS
            Inputs (if any)
        .OUTPUTS
            Output (if any)
        .NOTES
            General notes
    #>
    [CmdletBinding()]
    param(
        #
        [Parameter(Mandatory = $true, Position = 0)]
        #[ValidateScript({Test-Path -Path $_})]
        [String]
        $Path
    )
    
    $MicrosoftDownloadsURL = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=41653'
    $DownloadPage = Invoke-WebRequest -Uri $MicrosoftDownloadsURL
    $DownloadLink = ($DownloadPage.Links | Where-Object -FilterScript {$_.InnerText -eq 'Click here'}).href
    Invoke-WebRequest -Uri $DownloadLink -OutFile $Path
}