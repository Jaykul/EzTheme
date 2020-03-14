using namespace PoshCode.Pansies

function Set-PowerShellTheme {
    <#
        .SYNOPSIS
            Set the color theme for PowerShell output
            Has parameters for each color, including the default foreground and background, plus the new ErrorAccentColor and FormatAccentColor
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ForegroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$BackgroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$FormatAccentColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ErrorAccentColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ErrorForegroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ErrorBackgroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$WarningForegroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$WarningBackgroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$DebugForegroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$DebugBackgroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$VerboseForegroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$VerboseBackgroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ProgressForegroundColor,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ProgressBackgroundColor
    )
    process {
        switch ($PSBoundParameters.Keys) {
            "ForegroundColor" {
                $Host.UI.RawUI.ForegroundColor = $PSBoundParameters[$_]
            }
            "BackgroundColor" {
                $Host.UI.RawUI.ForegroundColor = $PSBoundParameters[$_]
            }
            default {
                $Host.PrivateData.$_ = $PSBoundParameters[$_]
            }
        }
    }
}