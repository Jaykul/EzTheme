function Export-Theme {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        # The name of the theme to export the current settings
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        # One or more modules to export the theme from (ignores registered modules)
        [Parameter()]
        [Alias("Module")]
        [string[]]$IncludeModule,

        # If set, leave any additional modules in the theme
        [Parameter(ParameterSetName = "Default")]
        [switch]$Update,

        # If set, overwrite the existing theme
        [Parameter(ParameterSetName = "Overwrite")]
        [switch]$Force,

        # If set, pass through the theme object after exporting it to file
        [switch]$Passthru
    )
    end {
        if (!$IncludeModule) {
            $IncludeModule = (Import-Configuration).Modules
        }

        $Theme = if ($Update) {
            ImportTheme $Name
        } else {
            @{}
        }

        foreach ($module in $IncludeModule) {
            $Noun = ($module -replace "^Theme\.?|\.?Theme$") + "Theme"
            Write-Verbose "Get theme from $module"
            $Theme[$Module] = & "$module\Get-$Noun"
        }

        $Theme | ExportTheme -Name $Name -Passthru:$Passthru -Force:($Force -or $Update)
        $MyInvocation.MyCommand.Module.PrivateData["Theme"] = $Theme

    }
}