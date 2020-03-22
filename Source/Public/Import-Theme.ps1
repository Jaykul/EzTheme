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

        # One or more modules to apply the theme to (ignores registered modules)
        [Parameter(ParameterSetName = "Whitelist")]
        [Alias("Module")]
        [string[]]$IncludeModule,

        # One or more modules to skip in the theme
        [Parameter(Mandatory, ParameterSetName = "Blacklist")]
        [string[]]$ExcludeModule
    )
    begin {
        if (!$IncludeModule) {
            $IncludeModule = (Import-Configuration).Modules
        }
    }

    process {
        $Theme = ImportTheme $Name
        $Theme.PSTypeNames.Insert(0, "Theme.Everything.Theme")
        # Store the current theme in our private data
        $MyInvocation.MyCommand.Module.PrivateData["Theme"] = $Theme
        # Also store the current theme on the Host.PrivateData if we can
        if ($Host.PrivateData.Theme -and $Host.PrivateData.Theme.PSTypeNames[0] -eq "Theme.Everything.Theme") {
            $Host.PrivateData.Theme = $Theme
        } else {
            $Host.PrivateData | Add-Member -NotePropertyName Theme -NotePropertyValue $Theme -ErrorAction SilentlyContinue
        }

        foreach ($module in $Theme.Keys) {
            if ($IncludeModule -and $module -notin $IncludeModule) {
                continue
            }
            if ($ExcludeModule -and $module -in $ExcludeModule) {
                continue
            }

            $Noun = ($module -replace "^Theme\.?|\.?Theme$") + "Theme"
            Write-Verbose "Applying the $Name theme to $module"
            $Theme[$module] | & "$module\Set-$Noun"
        }
    }
}