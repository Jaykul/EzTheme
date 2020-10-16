function FindTheme {
    <#
        .SYNOPSIS
            Finds themes in the file system
        .DESCRIPTION
            List available theme names with full PSPath
    #>
    [CmdletBinding()]
    param(
        # The name of the theme(s) to find. Supports wildcards, and defaults to * everything.
        [string]$Name = "*"
    )
    process {
        $Name = $Name -replace "((\.theme)?\.psd1)?$" -replace '$', ".theme.psd1"
        [ThemeId[]]@(
            Join-Path $(
                Get-ConfigurationPath -Scope User -SkipCreatingFolder
                Join-Path $PSScriptRoot Themes
            ) -ChildPath $Name -Resolve -ErrorAction Ignore)
    }
}