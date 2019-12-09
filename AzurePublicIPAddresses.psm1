#
# Export the module members - KUDOS to the chocolatey project for this efficent code
#

Write-Warning -Message '[Deprecation Notice] This module relies on files that will be deprecated by June 30, 2020. Please switch to the JSON Azure Tags file or the Azure AZ module.'

#get the path of where the module is saved (if module is at c:\myscripts\module.psm1, then c:\myscripts\)
$mypath = (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)

#find all the ps1 files in the subfolder functions
Resolve-Path -Path $mypath\functions\*.ps1 | ForEach-Object -Process {
    . $_.ProviderPath
    $Function = ((Split-Path -Path $_.ProviderPath -Leaf).Split('.')[0])
    Export-ModuleMember -Function $Function
}

#
# Define any alias and export them - Kieran Jacobsen
#
