#
# Export the module members - KUDOS to the chocolatey project for this efficent code
# 


#get the path of where the module is saved (if module is at c:\myscripts\module.psm1, then c:\myscripts\)
$mypath = (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)

#find all the ps1 files in the subfolder functions
Resolve-Path -Path $mypath\functions\*.ps1 | ForEach-Object -Process {
    . $_.ProviderPath
    $Function = ((Split-Path -path $_.ProviderPath -Leaf).Split('.')[0])
    Export-ModuleMember -Function $function
}

#
# Define any alias and export them - Kieran Jacobsen
#
