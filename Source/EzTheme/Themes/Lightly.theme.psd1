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

    PowerLine = PSObject @{
        FullColor           = $True
        PowerLineFont       = $True
        SetCurrentDirectory = $True
        Colors              = @(
            RgbColor "#5495BA"
            RgbColor "#73CCFF"
            RgbColor "#DBB04A"
            RgbColor "#B4903C"
        )
        Prompt              = @(
            ScriptBlock 'New-PromptText $MyInvocation.HistoryId -EBg "#C84F68"'
            ScriptBlock 'Get-SegmentedPath'
            ScriptBlock '"`t"'
            ScriptBlock 'Get-Elapsed'
            ScriptBlock 'Get-Date -f "T"'
            ScriptBlock '"`n"'
            ScriptBlock 'New-PromptText "I $(New-PromptText "&hearts;" -Bg "#32586E" -EBg Red -Fg "#ABD1C9")$(New-PromptText " PS" -Bg "#32586E" -EBg Red -Fg White)" -Bg "#32586E" -EBg Red -Fg White'
        )
        PSReadLinePromptText = @(
            "$([char]27)[97m$([char]27)[48;2;50;88;110mI $([char]27)[38;2;115;204;255m♥$([char]27)[38;2;255;255;255m PS$([char]27)[38;2;50;88;110m$([char]27)[49m"
            "$([char]27)[97m$([char]27)[48;2;50;88;110mI $([char]27)[38;2;255;99;71m♥$([char]27)[38;2;255;255;255m PS$([char]27)[38;2;50;88;110m$([char]27)[49m"
        )
        PowerLineCharacters = @{
            ReverseSeparator      = ''
            ColorSeparator        = ''
            ReverseColorSeparator = ''
            Separator             = ''
        }
    } -TypeName 'PowerLine.Theme'
}