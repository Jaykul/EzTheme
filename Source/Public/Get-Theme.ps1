function Get-Theme {
    <#
        .SYNOPSIS
            List available themes, optionally filtering
        .DESCRIPTION
            List available themes, optionally filtering by partial name or functionality.
    #>
    [CmdletBinding()]
    param(
        # The name of the theme(s) to show. Supports wildcards, and defaults to * everything.
        [string]$Name = "*",

        # If set, only returns themes that support theming all the specified modules
        [Alias("Module")]
        [string[]]$SupportedModule
    )

    $Name = $Name -replace "((\.theme)?\.psd1)?$" -replace '$', ".theme.psd1"

    foreach ($Theme in Join-Path $(
            Get-ConfigurationPath -Scope User -SkipCreatingFolder
            Join-Path $PSScriptRoot Themes
        ) -ChildPath $Name -Resolve -ErrorAction Ignore ) {
            if ($SupportedModule) {
                $ThemeData = Import-Metadata -Path $Theme

                foreach ($module in $SupportedModule) {
                    if (-not $ThemeData.ContainsKey($module)) {
                        continue
                    }
                }
            }
            $Name = if ($ThemeData.Name) {
                $ThemeData.Name
            } else {
                [IO.Path]::GetFileName($Theme) -replace "\.theme\.psd1$"
            }
            $Name | Add-Member NoteProperty PSPath $Theme -PassThru |
                    Add-Member NoteProperty Name $Name -PassThru
    }
}