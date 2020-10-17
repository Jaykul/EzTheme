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
        [ConsoleColor]$ForegroundColor = "White",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$BackgroundColor = "Black",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$FormatAccentColor = "Green",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ErrorAccentColor = "Yellow",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ErrorForegroundColor = "Red",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ErrorBackgroundColor = "Black",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$WarningForegroundColor = "Yellow",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$WarningBackgroundColor = "Black",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$DebugForegroundColor = "Cyan",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$DebugBackgroundColor = "Black",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$VerboseForegroundColor = "Green",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$VerboseBackgroundColor = "Black",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ProgressForegroundColor = "Yellow",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ConsoleColor]$ProgressBackgroundColor = "DarkMagenta"
    )
    process {
        switch ($PSBoundParameters.Keys) {
            "Foreground" {
                $Host.UI.RawUI.ForegroundColor = $PSBoundParameters[$_]
            }
            "Background" {
                $Host.UI.RawUI.ForegroundColor = $PSBoundParameters[$_]
            }
            default {
                $Key = $_
                try {
                    $Host.PrivateData.$_ = $PSBoundParameters[$_]
                } catch {
                    Write-Debug "Adding $Key = '$($PSBoundParameters[$Key])' to Host.PrivateData"
                    Add-Member -InputObject $Host.PrivateData -NotePropertyName $Key -NotePropertyValue $PSBoundParameters[$Key] -ErrorAction SilentlyContinue
                }
            }
        }
    }
}