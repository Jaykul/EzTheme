using namespace PoshCode.Pansies

function Get-TerminalTheme {
    <#
        .SYNOPSIS
            Returns a hashtable of the _current_ values that can be splatted to Set-Theme
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$ColorScheme
    )
    process {
        if (!$ColorScheme) {
            $ColorScheme = (Get-ModuleTheme).Name
        }
        # if ($IsWindows) {
        #     Write-Warning "On Windows, reading the current colors is not supported. Please use Theme.WindowsTerminal or Theme.WindowsConsole. See Get-Help et-TerminalTheme"
        # } else {
            Write-Warning "Reading the current colors from terminals is not supported yet. Returning the theme from `$Host.PrivateData.Theme['Theme.Terminal']"
        # }

        Get-ModuleTheme
    }
}