using namespace PoshCode.Pansies

function Get-WindowsConsoleTheme {
    <#
        .SYNOPSIS
            Get the current theme from the Windows Console
    #>
    [CmdletBinding()]
    param(
        # The name for the theme
        [string]$Name = "EzTheme",

        # If set, get the default theme from Windows. Otherwise return the current theme
        [Switch]$Default
    )

    end {
        $Palette = if ($Default)
        {
            [WindowsConsoleHelper]::GetDefaultConsolePalette($true);
        }
        else
        {
            [WindowsConsoleHelper]::GetCurrentConsolePalette($true);
        }

        [PSCustomObject]@{
            PSTypeName      = "Terminal.ColorScheme"
            name            = "$Name"
            # The windows API uses a different palette order than everyone else
            black           = $Palette[0]
            blue            = $Palette[1]
            green           = $Palette[2]
            cyan            = $Palette[3]
            red             = $Palette[4]
            purple          = $Palette[5]
            yellow          = $Palette[6]
            white           = $Palette[7]
            brightBlack     = $Palette[8]
            brightBlue      = $Palette[9]
            brightGreen     = $Palette[10]
            brightCyan      = $Palette[11]
            brightRed       = $Palette[12]
            brightPurple    = $Palette[13]
            brightYellow    = $Palette[14]
            brightWhite     = $Palette[15]

            foreground      = $Palette[16]
            background      = $Palette[17]

            popupForeground = $Palette[18]
            popupBackground = $Palette[19]
        }
    }
}
