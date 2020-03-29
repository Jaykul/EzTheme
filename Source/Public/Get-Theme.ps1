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
        [AllowEmptyCollection()]
        [string[]]$SupportedModule
    )

    $Name = $Name -replace "((\.theme)?\.psd1)?$" -replace '$', ".theme.psd1"

    Write-Verbose "Searching for theme: $Name"
    $(
        foreach ($Theme in Join-Path $(
                Get-ConfigurationPath -Scope User -SkipCreatingFolder
                Join-Path $PSScriptRoot Themes
            ) -ChildPath $Name -Resolve -ErrorAction Ignore ) {
                if ($SupportedModule) {
                    $ThemeData = Import-Metadata -Path $Theme

                    $SupportedModule.ForEach({
                        $ThemedModule = $_
                        if ($ThemeData.Keys.ForEach({
                                $_ -eq $ThemedModule -or $_ -like $ThemedModule -or
                                $_ -eq "Theme.$ThemedModule" -or $_ -eq "$ThemedModule.Theme"
                            }) -notcontains $true) {
                            # skip outputting this theme because it doesn't support this module
                            Write-Verbose "The $Name theme doesn't support $ThemedModule $($ThemeData.Keys -join ', ')"
                            continue
                        }
                    })
                }
                $Name = if ($ThemeData.Name) {
                    $ThemeData.Name
                } else {
                    [IO.Path]::GetFileName($Theme) -replace "\.theme\.psd1$"
                }
                # Remember, they're still strings, so when we Select -Unique it's by string uniqueness
                # Which means that we only output each theme name once
                $Name | Add-Member NoteProperty PSPath $Theme -PassThru |
                        Add-Member NoteProperty Name $Name -PassThru
        }
    ) | Select-Object -Unique
}