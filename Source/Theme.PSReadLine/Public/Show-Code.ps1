using namespace System.Management.Automation.Language
function Show-Code {
    [CmdletBinding(DefaultParameterSetName = 'HistoryId')]
    param(
        # A script block or a path to a script file
        [Parameter(Mandatory, ParameterSetName = 'Script', Position = 0)]
        [string]$Script,

        # The history id of the script to show
        [Parameter(Mandatory, ParameterSetName = 'History', Position = 0)]
        [int]$HistoryId,

        # The PSReadLine theme to use. If not specified, the current theme is used.
        # Can be the output of Get-VSCodeTheme or Get-PSReadLineTheme
        $Theme = (Get-PSReadLineTheme)
    )
    if ($HistoryId) {
        $Script = (Get-History -Id $HistoryId).CommandLine
    }

    $ParseErrors = $null
    $Tokens = $null
    $null = if (Test-Path "$Script" -ErrorAction SilentlyContinue) {
        [System.Management.Automation.Language.Parser]::ParseFile((Convert-Path $Script), [ref]$Tokens, [ref]$ParseErrors)
    } else {
        [System.Management.Automation.Language.Parser]::ParseInput([String]$Script, [ref]$Tokens, [ref]$ParseErrors)
    }

    $lastEndOffset = 0
    $StringBuilder = [Text.StringBuilder]::new()

    foreach ($token in $tokens) {
        $null = $StringBuilder.Append([char]' ', ($token.Extent.StartOffset - $lastEndOffset))
        $lastEndOffset = $token.Extent.EndOffset
        $null = WriteToken -Token $token -StringBuilder $StringBuilder -Theme $Theme
    }
    # Reset the colors
    $null = $StringBuilder.Append("$([char]0x1b)[0m$([char]0x1b)[24m$([char]0x1b)[27m")
    $StringBuilder.ToString()
}