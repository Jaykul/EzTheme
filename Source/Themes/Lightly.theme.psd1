@{
    'Theme.PowerShell' = PSObject @{
        Background              = ConsoleColor Black
        DebugBackgroundColor    = ConsoleColor White
        DebugForegroundColor    = ConsoleColor DarkGreen
        ErrorAccentColor        = ConsoleColor Cyan
        ErrorBackgroundColor    = ConsoleColor White
        ErrorForegroundColor    = ConsoleColor DarkRed
        Foreground              = ConsoleColor Gray
        FormatAccentColor       = ConsoleColor Green
        ProgressBackgroundColor = ConsoleColor DarkMagenta
        ProgressForegroundColor = ConsoleColor Yellow
        VerboseBackgroundColor  = ConsoleColor White
        VerboseForegroundColor  = ConsoleColor DarkBlue
        WarningBackgroundColor  = ConsoleColor White
        WarningForegroundColor  = ConsoleColor DarkMagenta
    } -TypeName 'Selected.Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy', 'System.Management.Automation.PSCustomObject', 'System.Object'

    'Theme.PSReadLine' = PSObject @{
        CommandColor            = "$([char]27)[30m"
        CommentColor            = "$([char]27)[37m"
        ContinuationPromptColor = "$([char]27)[93m"
        DefaultTokenColor       = "$([char]27)[90m"
        EmphasisColor           = "$([char]27)[38;2;199;21;134m"
        ErrorColor              = "$([char]27)[91m"
        KeywordColor            = "$([char]27)[33m"
        MemberColor             = "$([char]27)[95m"
        NumberColor             = "$([char]27)[31m"
        OperatorColor           = "$([char]27)[91m"
        ParameterColor          = "$([char]27)[90m"
        SelectionColor          = "$([char]27)[100;96m"
        StringColor             = "$([char]27)[36m"
        TypeColor               = "$([char]27)[34m"
        VariableColor           = "$([char]27)[35m"
    } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions', 'System.Management.Automation.PSCustomObject', 'System.Object'

    'Theme.WindowsTerminal' = PSObject @{
        name         = 'Lightly'
        foreground   = RgbColor '#000000'
        background   = RgbColor '#FFFFFF'

        black        = RgbColor '#000000'
        blue         = RgbColor '#0073C3'
        brightBlack  = RgbColor '#454545'
        brightBlue   = RgbColor '#12A8CD'
        brightCyan   = RgbColor '#2BC2A7'
        brightGreen  = RgbColor '#81B600'
        brightPurple = RgbColor '#C05478'
        brightRed    = RgbColor '#CA7073'
        brightWhite  = RgbColor '#FFFFFF'
        brightYellow = RgbColor '#CC9800'
        cyan         = RgbColor '#008E81'
        green        = RgbColor '#4A8100'
        purple       = RgbColor '#8F0057'
        red          = RgbColor '#BE0000'
        white        = RgbColor '#848388'
        yellow       = RgbColor '#BB6200'
    } -TypeName 'Terminal.ColorScheme', 'System.Management.Automation.PSCustomObject', 'System.Object'

    PowerLine = PSObject @{
        FullColor           = $True
        PowerLineFont       = $True
        SetCurrentDirectory = $True
        Colors              = @(
            RgbColor '#98F5FF'
            RgbColor '#6495ED'
        )
        Prompt              = @(
            ScriptBlock '$MyInvocation.HistoryId'
            ScriptBlock 'Get-SegmentedPath'
            ScriptBlock '"`t"'
            ScriptBlock 'Get-Elapsed'
            ScriptBlock 'Get-Date -f "T"'
            ScriptBlock '"`n"'
            ScriptBlock 'New-PromptText "I $(New-PromptText "&hearts;" -Bg DeepSkyBlue4 -EBg Red -EFg Black -Fg Sienna1)$(New-PromptText " PS" -Bg DeepSkyBlue4 -EBg Red -Fg White)" -Bg DeepSkyBlue4 -EBg Red -Fg White'
        )
        PowerLineCharacters = @{
            ReverseSeparator      = ''
            ColorSeparator        = ''
            ReverseColorSeparator = ''
            Separator             = ''
        }
    } -TypeName 'PowerLine.Theme', 'System.Management.Automation.PSCustomObject', 'System.Object'
}