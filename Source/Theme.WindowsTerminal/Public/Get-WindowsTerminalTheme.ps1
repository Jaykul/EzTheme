using namespace PoshCode.Pansies

function Get-WindowsTerminalTheme {
    <#
        .SYNOPSIS
            Returns a hashtable of the _current_ values that can be splatted to Set-Theme
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$ColorScheme
    )
    process {
        $Config = GetLayeredConfig -FlattenDefaultProfile

        if (!$ColorScheme) {
            $ColorScheme = (FindProfile $Config.profiles.list).ColorScheme
        }

        if ($ColorScheme) {
            $Result = $Config.schemes.Where({ $_.name -eq $colorScheme })[0]
            $Result.PSTypeNames.Insert(0, "WindowsTerminal.ColorScheme")

            foreach ($property in (Get-Member -Input $Result -Type Properties).Where({$_.Name -ne "name"}).name) {
                $Result.$property = [RgbColor]$Result.$property
            }
            $Result
        }
    }
}