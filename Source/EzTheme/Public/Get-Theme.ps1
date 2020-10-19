function Get-Theme {
    <#
        .SYNOPSIS
            List available themes, optionally filtering
        .DESCRIPTION
            List available themes, optionally filtering by partial name or functionality.
    #>
    [Alias("gth")]
    [CmdletBinding()]
    param(
        # The name of the theme(s) to show. Supports wildcards, and defaults to * everything.
        [Alias("Theme", "PSPath")]
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            Get-Theme $wordToComplete*
        })]
        [string]$Name = "*",

        # If set, only returns themes that support theming all the specified modules. Supports wildcards.
        [Alias("Module")]
        [AllowEmptyCollection()]
        [string[]]$SupportedModule,

        # If set, outputs just the module theme object(s)
        [string[]]$ExpandModule
    )
    Write-Verbose "Searching for theme: $Name"
    $Themes = @(FindTheme $Name)
    foreach ($Theme in $Themes) {
        if ($SupportedModule -or $ExpandModule -or ($Themes.Count -eq 1)) {
            $ThemeData = [Theme]$Theme

            Write-Verbose "The $($ThemeData.Name) theme supports $($ThemeData.Modules -join ', ')"

            $SupportedModule.ForEach({
                $ExpectedModule = $_
                if (!$ThemeData.Item($_)) {
                    # skip outputting this theme because it doesn't support this module
                    Write-Verbose "The $Name theme doesn't support $ExpectedModule $($ThemeData.Modules -join ', ')"
                    continue # goes to the outer foreach in FindTheme
                }
            })
            if ($ExpandModule) {
                $ThemeData.Item($ExpandModule) | ForEach-Object { $_ } # Enumerate
            } else {
                $ThemeData
            }
        } else {
            $Theme
        }
    }
}