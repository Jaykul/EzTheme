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
    [Alias("ipth")]
    [CmdletBinding(DefaultParameterSetName = "Whitelist")]
    param(
        # A theme to import (can be the name of an installed theme, or the full path to a psd1 file)
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ArgumentCompleter({Get-Theme})]
        [string]$Name,

        # One or more modules to export the theme from (ignores all other modules)
        [Parameter(ParameterSetName = "Whitelist")]
        [Alias("Module")]
        [string[]]$IncludeModule,

        # One or more modules to skip in the theme
        [Parameter(Mandatory, ParameterSetName = "Blacklist")]
        [string[]]$ExcludeModule,

        # Normally, only modules that are currently imported are themed.
        # If you set this, any module in the theme that's installed will be imported and themed
        [switch]$Force
    )
    begin {
        $SupportedModules = @(Get-Module).Where{ $_.PrivateData -is [Collections.IDictionary] -and $_.PrivateData.ContainsKey("EzTheme") }
        if (!$IncludeModule) {
            $IncludeModule = $SupportedModules
        }
    }
    process {
        $null = $PSBoundParameters.Remove("Force")
        $Theme = ImportTheme @PSBoundParameters
        # Store the current theme in our private data
        $MyInvocation.MyCommand.Module.PrivateData["Theme"] = $Theme
        # Also store the current theme on the Host.PrivateData which survives module reload
        if ($Host.PrivateData.Theme -and $Host.PrivateData.Theme -is [Theme]) {
            # Instead of overwriting the theme, just update the modules we're importing:
            $Host.PrivateData.Theme = $Theme
        } else {
            $Host.PrivateData | Add-Member -NotePropertyName Theme -NotePropertyValue $Theme -Force -ErrorAction SilentlyContinue
        }
        # Also export it to the configuration which survives PowerShell sessions (and affects new sessions)
        $Configuration = Import-Configuration
        $Configuration.Theme = $Theme.Name
        $Configuration | Export-Configuration

        if ($Force) {
            foreach ($module in $Theme.Modules) {
                Write-Verbose "Importing $module because of -Force"
                Import-Module $module -ErrorAction SilentlyContinue -Scope Global
            }
            $SupportedModules = @(Get-Module).Where{ $_.PrivateData -is [Collections.IDictionary] -and $_.PrivateData.ContainsKey("EzTheme") }
        }

        foreach ($module in $Theme.Modules) {
            # No point themeing modules that aren't imported?
            if ($module -notin @($SupportedModules.Name)) {
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