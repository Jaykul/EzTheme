using namespace PoshCode.Pansies

function Set-TerminalTheme {
    <#
        .SYNOPSIS
            Set the theme for Windows Terminal
            Has parameters for each color, including foreground and background
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
    process {
        $e = [char]27
        $b = [char]7

        # PowerShell is really dumb, and has this setting that ignores the terminal. We need to help it out:
        $Host.UI.RawUI.ForegroundColor = $foreground.ConsoleColor
        $Host.UI.RawUI.BackgroundColor =
            $Host.PrivateData.DebugBackgroundColor =
            $Host.PrivateData.VerboseBackgroundColor =
            $Host.PrivateData.WarningBackgroundColor =
            $Host.PrivateData.ErrorBackgroundColor = $background.ConsoleColor

        @(
            "$e]10;rgb:{0:x}/{1:x}/{2:x}$b"   -f [int]$foreground.R, [int]$foreground.G, [int]$foreground.B
            "$e]11;rgb:{0:x}/{1:x}/{2:x}$b"   -f [int]$background.R, [int]$background.G, [int]$background.B
            "$e]4;0;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$black.R, [int]$black.G, [int]$black.B
            "$e]4;1;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$red.R, [int]$red.G, [int]$red.B
            "$e]4;2;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$green.R, [int]$green.G, [int]$green.B
            "$e]4;3;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$yellow.R, [int]$yellow.G, [int]$yellow.B
            "$e]4;4;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$blue.R, [int]$blue.G, [int]$blue.B
            "$e]4;5;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$purple.R, [int]$purple.G, [int]$purple.B
            "$e]4;6;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$cyan.R, [int]$cyan.G, [int]$cyan.B
            "$e]4;7;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$white.R, [int]$white.G, [int]$white.B
            "$e]4;8;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$brightBlack.R, [int]$brightBlack.G, [int]$brightBlack.B
            "$e]4;9;rgb:{0:x}/{1:x}/{2:x}$b"  -f [int]$brightRed.R, [int]$brightRed.G, [int]$brightRed.B
            "$e]4;10;rgb:{0:x}/{1:x}/{2:x}$b" -f [int]$brightGreen.R, [int]$brightGreen.G, [int]$brightGreen.B
            "$e]4;11;rgb:{0:x}/{1:x}/{2:x}$b" -f [int]$brightYellow.R, [int]$brightYellow.G, [int]$brightYellow.B
            "$e]4;12;rgb:{0:x}/{1:x}/{2:x}$b" -f [int]$brightBlue.R, [int]$brightBlue.G, [int]$brightBlue.B
            "$e]4;13;rgb:{0:x}/{1:x}/{2:x}$b" -f [int]$brightPurple.R, [int]$brightPurple.G, [int]$brightPurple.B
            "$e]4;14;rgb:{0:x}/{1:x}/{2:x}$b" -f [int]$brightCyan.R, [int]$brightCyan.G, [int]$brightCyan.B
            "$e]4;15;rgb:{0:x}/{1:x}/{2:x}$b" -f [int]$brightWhite.R, [int]$brightWhite.G, [int]$brightWhite.B
        ) -join ""

        if ($Host.PrivateData.Theme) {
            $Host.PrivateData.Theme["Theme.Terminal"] = [PSCustomObject]@{
                PSTypeName   = "Terminal.ColorScheme"
                name         = $Name
                background   = $background
                foreground   = $foreground
                black        = $black
                red          = $red
                green        = $green
                yellow       = $yellow
                blue         = $blue
                purple       = $purple
                cyan         = $cyan
                white        = $white
                brightBlack  = $brightBlack
                brightRed    = $brightRed
                brightGreen  = $brightGreen
                brightYellow = $brightYellow
                brightBlue   = $brightBlue
                brightPurple = $brightPurple
                brightCyan   = $brightCyan
                brightWhite  = $brightWhite
            }
        }
    }
}