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
        [Alias("Module")]
        [string[]]$IncludeModule
    )
    process {
        # Without a theme name, show the current configuration
        $Themes = if (!$Name) {
            @($MyInvocation.MyCommand.Module.PrivateData.Theme)
        } else {
            Get-Theme $Name -Module $IncludeModule | ImportTheme
        }

        foreach ($Theme in $Themes) {
            if ($IncludeModule) {
                foreach ($themedModule in @($Theme.Keys)) {
                    if ($IncludeModule.ForEach({
                            $_ -eq $ThemedModule -or
                            $_ -like $ThemedModule -or
                            "Theme.$_" -eq $ThemedModule -or
                            "$_.Theme" -eq "$ThemedModule"
                        }) -notcontains $true) {
                        Write-Verbose "Not showing $ThemedModule theme "
                        $Theme.Remove($themedModule)
                    }
                }
            }
            foreach ($module in $Theme.Keys) {
                Write-Host "$module $($Theme.Name) theme:"
                $Theme[$module] | Out-Default
            }
        }
    }
}