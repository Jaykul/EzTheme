using namespace PoshCode.Pansies

function Set-WindowsTerminalTheme {
    <#
        .SYNOPSIS
            Set the theme for Windows Terminal
            Has parameters for each color, including foreground, background, and cursorColor
        .DESCRIPTION
            The expectation is that you call Get-WindowsTerminalTheme and modify the result,
            then pipe the modified value into Set-WindowsTerminalTheme
        .LINK
            Get-WindowsTerminalTheme
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Name           = "EzTheme",

        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$background   = "#0C0C0C",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$foreground   = "#CCCCCC",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$cursorColor  = "#FFFFFF",

        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$black        = "#0C0C0C",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$red          = "#C50F1F",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$green        = "#13A10E",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$yellow       = "#C19C00",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$blue         = "#0037DA",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$purple       = "#881798",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$cyan         = "#3A96DD",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$white        = "#CCCCCC",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightBlack  = "#767676",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightRed    = "#E74856",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightGreen  = "#16C60C",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightYellow = "#F9F1A5",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightBlue   = "#3B78FF",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightPurple = "#B4009E",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightCyan   = "#61D6D6",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightWhite  = "#F2F2F2"
    )

    begin {
        $Config = GetLayeredConfig -FlattenDefaultProfile
        $CurrentProfile = FindProfile $Config.profiles.list
    }
    process {
        $UserConfig = ConvertFrom-Json (Get-Content $UserConfigFile -Raw)
        $SchemeIndex = $UserConfig.schemes.name.IndexOf($name)

        # Make sure we're using simple strings that match the json Windows Terminal needs
        $Scheme = [PSCustomObject]@{
            name         = "$Name"
            background   = "$background"
            foreground   = "$foreground"
            black        = "$black"
            red          = "$red"
            green        = "$green"
            yellow       = "$yellow"
            blue         = "$blue"
            purple       = "$purple"
            cyan         = "$cyan"
            white        = "$white"
            brightBlack  = "$brightBlack"
            brightRed    = "$brightRed"
            brightGreen  = "$brightGreen"
            brightYellow = "$brightYellow"
            brightBlue   = "$brightBlue"
            brightPurple = "$brightPurple"
            brightCyan   = "$brightCyan"
            brightWhite  = "$brightWhite"
        }

        if ($SchemeIndex -lt 0) {
            $UserConfig.schemes += $Scheme
        } else {
            $UserConfig.schemes[$SchemeIndex] = $Scheme
        }

        if(!($CurrentUserProfile = $UserConfig.profiles.where({$_.guid -eq $CurrentProfile.guid}))) {
            $CurrentUserProfile = $UserConfig.profiles.list.where({$_.guid -eq $CurrentProfile.guid})
        }

        if ($CurrentUserProfile.colorScheme) {
            $CurrentUserProfile.colorScheme = $Scheme.name
        } elseif($UserConfig.profiles.defaults) {
            $UserConfig.profiles.defaults | Add-Member -NotePropertyName colorScheme -NotePropertyValue $Scheme.name -Force
        } else {
            $UserConfig.profiles.defaults = [PSCustomObject]@{
                colorScheme = $Scheme.name
            }
        }

        Set-Content $UserConfigFile ($UserConfig | ConvertTo-Json -Depth 10)
    }
}