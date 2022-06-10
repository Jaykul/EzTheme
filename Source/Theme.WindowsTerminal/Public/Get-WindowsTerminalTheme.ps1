using namespace PoshCode.Pansies

function Get-WindowsTerminalTheme {
    <#
        .SYNOPSIS
            Returns an object representing the color scheme from the Windows Terminal settings
        .DESCRIPTION
            The expectation is that you call Get-WindowsTerminalTheme, modify the result,
            then pipe the modified value into Set-WindowsTerminalTheme.

            By default (without parameters), this function detects the current profile via Env:WT_PROFILE_ID
            and returns the color scheme associated with that profile.
        .LINK
            Set-WindowsTerminalTheme
    #>
    [CmdletBinding()]
    param(
        # If specified, returns the named color scheme instead of the one associated with the current profile
        [Parameter(ValueFromPipeline)]
        [string]$ColorScheme
    )
    process {
        $Config = GetLayeredConfig -FlattenDefaultProfile

        if (!$ColorScheme) {
            $ActiveProfile = FindProfile $Config.profiles.list
            $ColorScheme = $ActiveProfile.ColorScheme
        }

        if ($ColorScheme) {
            $Result = @($Config.schemes).Where({ $_.name -eq $colorScheme })[0]
            $Result.PSTypeNames.Insert(0, "Terminal.ColorScheme")
            $Result.PSTypeNames.Insert(0, "WindowsTerminal.ColorScheme")
            if ($ActiveProfile) {
                # Update with overrides from the active profile
                if ($ActiveProfile.foreground) { # -and -not $Result.foreground
                    Add-Member -InputObject $Result -NotePropertyMembers @{ foreground = $ActiveProfile.foreground } -Force
                }
                if ($ActiveProfile.background) { # -and -not $Result.background
                    Add-Member -InputObject $Result -NotePropertyMembers @{ background = $ActiveProfile.background } -Force
                }
                if ($ActiveProfile.cursorColor) { # -and -not $Result.cursorColor
                    Add-Member -InputObject $Result -NotePropertyMembers @{ cursorColor = $ActiveProfile.cursorColor } -Force
                }
                if (!$Result.cursorColor) {
                    Add-Member -InputObject $Result -NotePropertyMembers @{ cursorColor = $Result.foreground } -Force
                }
            }

            # Since all the properties are colors, we cast them to RgbColor for display purposes
            foreach ($property in @(Get-Member -Input $Result -Type Properties).Where({$_.Name -ne "name"}).name) {
                $Result.$property = [RgbColor]$Result.$property
            }
            $Result
        }
    }
}