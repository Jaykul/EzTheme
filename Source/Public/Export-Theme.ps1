function Export-Theme {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        # The name of the theme to export the current settings
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        # One or more modules to export the theme from (ignores other modules)
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
        $Theme = if ($Update) {
            ImportTheme $Name
        } else {
            @{}
        }

        if (!$IncludeModule) {
            $IncludeModule = @(Get-Module).Where{ $_.PrivateData -and $_.PrivateData.ContainsKey("EzTheme") }
        }

        foreach ($module in $IncludeModule) {
            Write-Verbose "Get theme from $($module.Name)"
            try {
                $Theme[$module.Name] = & "$($Module.Name)\$($Module.PrivateData["EzTheme"]["Set"])"
            } catch {
                Write-Warning "Unable to get theme from $($module.Name)\$($module.PrivateData["EzTheme"]["Get"])"
            }
        }

        $Theme | ExportTheme -Name $Name -Passthru:$Passthru -Force:($Force -or $Update)
        $MyInvocation.MyCommand.Module.PrivateData["Theme"] = $Theme
    }
}