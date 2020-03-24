function Import-Theme {
    <#
        .SYNOPSIS
            Import a named theme and apply it to all the registered themable modules that are in the theme
        .EXAMPLE
            Import-Theme Light

            Imports the built-in Light theme and applies it to all the supported modules that are registered
        .EXAMPLE
            Import-Theme Light -Include Theme.ConsoleColors

            Imports the built-in Light theme, but only applies the theme to Theme.ConsoleColors
    #>
    [CmdletBinding(DefaultParameterSetName = "Whitelist")]
    param(
        # A theme to import (can be the name of an installed theme, or the full path to a psd1 file)
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [string]$Name,

        # One or more modules to export the theme from (ignores all other modules)
        [Parameter(ParameterSetName = "Whitelist")]
        [Alias("Module")]
        [string[]]$IncludeModule,

        # One or more modules to skip in the theme
        [Parameter(Mandatory, ParameterSetName = "Blacklist")]
        [string[]]$ExcludeModule,

        # Normally, only modules that are currently imported are themed.
        # If you set this, any supported module that's installed will be imported and themed
        [switch]$Force
    )
    begin {
        $SupportedModules = @(Get-Module).Where{ $_.PrivateData -and $_.PrivateData.ContainsKey("EzTheme") }
        if (!$IncludeModule) {
            $IncludeModule = $SupportedModules.Name
        }
    }

    process {
        $Theme = ImportTheme $Name
        $Theme.PSTypeNames.Insert(0, "EzTheme.Theme")
        # Store the current theme in our private data
        $MyInvocation.MyCommand.Module.PrivateData["Theme"] = $Theme
        # Also store the current theme on the Host.PrivateData if we can
        if ($Host.PrivateData.Theme -and $Host.PrivateData.Theme.PSTypeNames[0] -eq "EzTheme.Theme") {
            $Host.PrivateData.Theme = $Theme
        } else {
            $Host.PrivateData | Add-Member -NotePropertyName Theme -NotePropertyValue $Theme -ErrorAction SilentlyContinue
        }

        if ($Force) {
            foreach ($module in $Theme.Keys) {
                Import-Module $module -ErrorAction SilentlyContinue
            }
            $SupportedModules = @(Get-Module).Where{ $_.PrivateData -and $_.PrivateData.ContainsKey("EzTheme") }
            $IncludeModule = $SupportedModules.Name
        }

        foreach ($module in $Theme.Keys) {
            # No point themeing modules that aren't imported?
            if ($module -notin @($SupportedModules.Name)) {
                continue
            }
            if ($module -in @($ExcludeModule)) {
                continue
            }

            try {
                Write-Verbose "Set the $Name theme for $($module)"
                $TheModule = $SupportedModules.Where({$module -eq $_.Name}, "First", 1)[0]
                $Theme[$module] | & "$($TheModule.Name)\$($TheModule.PrivateData["EzTheme"]["Set"])"
            } catch {
                Write-Warning "Unable to set theme for $($module)\$($TheModule.PrivateData["EzTheme"]["Set"])"
            }
        }
    }
}