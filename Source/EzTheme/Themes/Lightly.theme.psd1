@{  # There are three copies here of the Terminal.ColorScheme, one for each terminal-theming module
    'Theme.Terminal' = PSObject @{
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
    } -TypeName 'Terminal.ColorScheme'

    'Theme.WindowsTerminal' = PSObject @{
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
    } -TypeName 'Terminal.ColorScheme'

    'Theme.WindowsConsole' = PSObject @{
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
    } -TypeName 'Terminal.ColorScheme'

    'Theme.PowerShell' = PSObject @{
        Background              = ConsoleColor White
        Foreground              = ConsoleColor Gray
        DebugBackgroundColor    = ConsoleColor White
        DebugForegroundColor    = ConsoleColor DarkGreen
        ErrorBackgroundColor    = ConsoleColor White
        ErrorForegroundColor    = ConsoleColor DarkRed
        ErrorAccentColor        = ConsoleColor Cyan
        FormatAccentColor       = ConsoleColor Green
        ProgressBackgroundColor = ConsoleColor DarkMagenta
        ProgressForegroundColor = ConsoleColor Yellow
        VerboseBackgroundColor  = ConsoleColor White
        VerboseForegroundColor  = ConsoleColor DarkBlue
        WarningBackgroundColor  = ConsoleColor White
        WarningForegroundColor  = ConsoleColor DarkMagenta
    } -TypeName 'Selected.Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy'

    'Theme.PSReadLine' = PSObject @{
        CommandColor            = "$([char]27)[38;2;0;0;255m"
        CommentColor            = "$([char]27)[38;2;0;100;0m"
        ContinuationPromptColor = "$([char]27)[38;2;128;0;128m"
        DefaultTokenColor       = "$([char]27)[38;2;0;0;0m"
        EmphasisColor           = "$([char]27)[38;2;199;21;134m"
        ErrorColor              = "$([char]27)[38;2;102;0;0m"
        KeywordColor            = "$([char]27)[38;2;0;0;139m"
        MemberColor             = "$([char]27)[38;2;0;0;255m"
        NumberColor             = "$([char]27)[38;2;128;0;128m"
        OperatorColor           = "$([char]27)[38;2;169;169;169m"
        ParameterColor          = "$([char]27)[38;2;109;109;109m"
        InlinePredictionColor   = "$([char]27)[38;2;169;169;169m"
        SelectionColor          = "$([char]27)[48;2;148;198;247m"
        StringColor             = "$([char]27)[38;2;139;0;0m"
        TypeColor               = "$([char]27)[38;2;0;0;139m"
        VariableColor           = "$([char]27)[38;2;255;69;0m"
    } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions'
    PowerLine               = (PSObject @{
        DefaultCapsLeftAligned            = '', ''
        DefaultCapsRightAligned           = '', ''
        DefaultSeparator                  = '', ''
        Prompt                            = @(
            Show-HistoryId -DBg "#5495BA" -EBg '#8B2252' -Fg 'White' -EFg 'White'
            Show-Path -HomeString "&House;" -Separator '' -Background "#73CCFF" -Foreground '#000000'
            Show-Date -Format "h\:mm" -Prefix "🕒"  -Alignment 'Right' -Background "#B4903C" -Foreground '#000000'
            Show-ElapsedTime -Autoformat -Prefix "⏱️"  -Alignment 'Right' -Background "#DBB04A" -Foreground '#000000'
            New-TerminalBlock -Content "I $([char]27)[31m&hearts;$([char]27)[37m PS" -Background "#32586E" -Fg 'White' -Efg 'Red'
        )
        PSReadLineContinuationPrompt      = '█ '
        PSReadLineContinuationPromptColor = ''
        PSReadLinePromptText              = '', ''
        SetCurrentDirectory               = $false
    })
}