using namespace PoshCode.Pansies

function Set-WindowsConsoleTheme {
    <#
        .SYNOPSIS
            Set the theme for the Windows Console
            Has parameters for each color, including foreground and background
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Name = "EzTheme",

        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$background = "#0C0C0C",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$foreground = "#CCCCCC",

        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$black = "#0C0C0C",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$red = "#C50F1F",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$green = "#13A10E",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$yellow = "#C19C00",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$blue = "#0037DA",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$purple = "#881798",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$cyan = "#3A96DD",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$white = "#CCCCCC",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightBlack = "#767676",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightRed = "#E74856",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightGreen = "#16C60C",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightYellow = "#F9F1A5",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightBlue = "#3B78FF",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightPurple = "#B4009E",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightCyan = "#61D6D6",
        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$brightWhite = "#F2F2F2",

        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$PopupBackground = "#881798",

        [Parameter(ValueFromPipelineByPropertyName)]
        [RgbColor]$PopupForeground = "#F2F2F2",

        # Set the default Windows Console theme as well as the current theme
        [switch]$Default
    )

    process {
        # The windows API uses a different palette order
        [RgbColor[]]$Palette = @(
            $Black
            $Blue
            $Green
            $Cyan
            $Red
            $Purple
            $Yellow
            $BrightBlack
            $White
            $BrightBlue
            $BrightGreen
            $BrightCyan
            $BrightRed
            $BrightPurple
            $BrightYellow
            $BrightWhite
        )

        if ($PSBoundParameters.ContainsKey("Foreground")) {
            $Palette += $Foreground
        } else {
            $Palette += $White
        }

        if ($PSBoundParameters.ContainsKey("Background")) {
            $Palette += $Background
        } else {
            $Palette += $Black
        }

        if ($PSBoundParameters.ContainsKey("PopupForeground")) {
            $Palette += $PopupForeground
        } else {
            $Palette += $BrightWhite
        }

        if ($PSBoundParameters.ContainsKey("PopupBackground")) {
            $Palette += $PopupBackground
        } else {
            $Palette += $Purple
        }

        if ($Default) {
            [WindowsConsoleHelper]::SetDefaultConsolePalette($Palette)
        }
        [WindowsConsoleHelper]::SetCurrentConsolePalette($Palette)
    }
}