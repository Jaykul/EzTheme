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
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            Get-Theme $wordToComplete*
        })]
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
        # Trace-Message -Verbose "BEGIN Import-Theme $Name"
        $SupportedModules = @(Get-Module).Where{ $_.PrivateData -is [Collections.IDictionary] -and $_.PrivateData.ContainsKey("EzTheme") }
        # Trace-Message -Verbose "Found $($SupportedModules.Count) modules"
        if (!$IncludeModule) {
            $IncludeModule = $SupportedModules
        }
    }
    process {
        # Trace-Message -Verbose "PROCESS Import-Theme $Name -IncludeModule $IncludeModule"
        $null = $PSBoundParameters.Remove("Force")
        $Theme = ImportTheme @PSBoundParameters
        # Trace-Message -Verbose "Setting EzTheme.PrivateData.Theme $($Theme.Name)"
        # Store the current theme in our private data
        $MyInvocation.MyCommand.Module.PrivateData["Theme"] = $Theme
        # Also store the current theme on the Host.PrivateData which survives module reload
        # Trace-Message -Verbose "Setting Host.PrivateData.Theme $($Theme.Name)"
        if ($Host.PrivateData.Theme -and $Host.PrivateData.Theme -is [Theme]) {
            # Instead of overwriting the theme, just update the modules we're importing:
            $Host.PrivateData.Theme = $Theme
        } else {
            $Host.PrivateData | Add-Member -NotePropertyName Theme -NotePropertyValue $Theme -Force -ErrorAction SilentlyContinue
        }

        # Trace-Message -Verbose "Import Module Configuration to change Theme"
        # Also export it to the configuration which survives PowerShell sessions (and affects new sessions)
        $Configuration = Import-Configuration
        $Configuration.Theme = $Theme.Name
        # Trace-Message -Verbose "Export Module Configuration with changed theme"
        $Configuration | Export-Configuration

        if ($Force -or $PSBoundParameters.ContainsKey("IncludeModule")) {
            # Trace-Message -Verbose "Either Force ($Force) or IncludeModule $($IncludeModule -join ',')"
            foreach ($module in $Theme.Modules) {
                # Trace-Message -Verbose "Import-Module $module -Scope Global"
                Write-Debug "Importing $module because it was Included or Forced by hand"
                if (!(Get-Module $Module)) { # Only try importing if the module isn't loaded already
                    Import-Module $module -ErrorAction SilentlyContinue -Scope Global -Verbose:$false
                }
            }
            $SupportedModules = @(Get-Module).Where{ $_.PrivateData -is [Collections.IDictionary] -and $_.PrivateData.ContainsKey("EzTheme") }
        }

        # Trace-Message -Verbose "Modules imported. Must theme modules"
        foreach ($module in $Theme.Modules) {
            # No point themeing modules that aren't imported?
            if ($module -notin @($SupportedModules.Name)) {
                # Trace-Message -Verbose "Skipping $module because it's not loaded"
                continue
            }

            try {
                # Trace-Message -Verbose "Themeing $module"
                $TheModule = $SupportedModules.Where({$module -eq $_.Name}, "First", 1)[0]
                Write-Verbose "Set the $Name theme for $TheModule $($Theme.Item($module) | Out-String)"
                $Theme.Item($module) | & "$($TheModule.Name)\$($TheModule.PrivateData["EzTheme"]["Set"])"
                # Trace-Message -Verbose "Themed $module"
            } catch {
                Write-Warning "Unable to set theme for $($module)\$($TheModule.PrivateData["EzTheme"]["Set"])"
            }
        }
        # Trace-Message -Verbose "END Import-Theme" -KillTimer
    }
}