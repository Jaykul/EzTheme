function Show-Theme {
    <#
        .SYNOPSIS
            Import a theme and output the custom PSObjects
    #>
    [Alias("shth")]
    [OutputType([string])]
    [CmdletBinding(DefaultParameterSetName="CurrentTheme")]
    param(
        # The name of the theme to export the current settings
        [Alias("Theme","PSPath")]
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter({Get-Theme})]
        [string]$Name,

        # One or more modules to export the theme from (ignores registered modules)
        [Parameter()]
        [AllowEmptyCollection()]
        [Alias("Module")]
        [string[]]$IncludeModule = "*"
    )
    process {
        # Without a theme name, show the current configuration
        $Themes = if (!$Name) {
            @($MyInvocation.MyCommand.Module.PrivateData.Theme)
        } else {
            Get-Theme $Name -Module $IncludeModule
        }

        foreach ($Theme in $Themes) {
            foreach ($module in $IncludeModule) {
                foreach ($ModuleTheme in $Theme.Modules.Where({ ($_ -like $Module) -or $_ -eq "Theme.$Module" -or $_ -eq "$Module.Theme" })) {
                    Write-Host "$([char]27)[0m$ModuleTheme $($Theme.Name) theme:"
                    foreach ($ThemeObject in $Theme[$ModuleTheme]) {
                        $ThemeObject | Out-Default
                    }
                }
            }
        }
    }
}