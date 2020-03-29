@{
    'Theme.PowerShell' = PSObject @{
        Background              = ConsoleColor Black
        DebugBackgroundColor    = ConsoleColor Black
        DebugForegroundColor    = ConsoleColor Green
        ErrorAccentColor        = ConsoleColor Cyan
        ErrorBackgroundColor    = ConsoleColor Black
        ErrorForegroundColor    = ConsoleColor Red
        Foreground              = ConsoleColor Gray
        FormatAccentColor       = ConsoleColor Green
        ProgressBackgroundColor = ConsoleColor DarkMagenta
        ProgressForegroundColor = ConsoleColor Yellow
        VerboseBackgroundColor  = ConsoleColor Black
        VerboseForegroundColor  = ConsoleColor Cyan
        WarningBackgroundColor  = ConsoleColor Black
        WarningForegroundColor  = ConsoleColor Yellow
    } -TypeName 'Selected.Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy', 'System.Management.Automation.PSCustomObject', 'System.Object'

    'Theme.PSReadLine' = PSObject @{
        CommandColor            = "$([char]27)[36m"
        CommentColor            = "$([char]27)[37m"
        ContinuationPromptColor = "$([char]27)[93m"
        DefaultTokenColor       = "$([char]27)[97m"
        EmphasisColor           = "$([char]27)[38;2;199;21;133m"
        ErrorColor              = "$([char]27)[91m"
        KeywordColor            = "$([char]27)[93m"
        MemberColor             = "$([char]27)[95m"
        NumberColor             = "$([char]27)[31m"
        OperatorColor           = "$([char]27)[91m"
        ParameterColor          = "$([char]27)[96m"
        SelectionColor          = "$([char]27)[100;96m"
        StringColor             = "$([char]27)[92m"
        TypeColor               = "$([char]27)[34m"
        VariableColor           = "$([char]27)[35m"
    } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions', 'System.Management.Automation.PSCustomObject', 'System.Object'

    'Theme.WindowsTerminal' = PSObject @{
        name         = 'Darkly'
        foreground   = RgbColor '#FFFCFF'
        background   = RgbColor '#212021'

        black        = RgbColor '#212021'
        blue         = RgbColor '#01A0E4'
        brightBlack  = RgbColor '#493F3F'
        brightBlue   = RgbColor '#6ECEFF'
        brightCyan   = RgbColor '#95F2FF'
        brightGreen  = RgbColor '#6CD18E'
        brightPurple = RgbColor '#D29BC6'
        brightRed    = RgbColor '#FF6E6D'
        brightWhite  = RgbColor '#FFFCFF'
        brightYellow = RgbColor '#FFFF85'
        cyan         = RgbColor '#55C4CF'
        green        = RgbColor '#01A252'
        purple       = RgbColor '#A16A94'
        red          = RgbColor '#D92D20'
        white        = RgbColor '#A5A2A2'
        yellow       = RgbColor '#FBED02'
    } -TypeName 'WindowsTerminal.ColorScheme', 'System.Management.Automation.PSCustomObject', 'System.Object'

    PowerLine = PSObject @{
        FullColor           = $True
        SetCurrentDirectory = $True
        PowerLineFont       = $True
        Colors              = @(
            RgbColor 'Gray20'
            RgbColor 'Gray26'
            RgbColor 'Gray54'
            RgbColor 'Gray44'
        )
        PowerLineCharacters = @{
            ReverseSeparator      = ''
            ReverseColorSeparator = ''
            ColorSeparator        = ''
            Separator             = ''
        }
        Prompt              = @(
            ScriptBlock '$MyInvocation.HistoryId'
            ScriptBlock 'Get-SegmentedPath'
            ScriptBlock '"`t"'
            ScriptBlock 'Get-Elapsed'
            ScriptBlock 'Get-Date -f "T"'
            ScriptBlock '"`n"'
            ScriptBlock 'New-PromptText "I $(New-PromptText "&hearts;" -Bg Gray40 -EBg Red -EFg Black -Fg Sienna1)$(New-PromptText " PS" -Bg Gray40 -EBg Red -Fg White)" -Bg Gray40 -EBg Red -Fg White'
        )
    } -TypeName 'PowerLine.Theme', 'System.Management.Automation.PSCustomObject', 'System.Object'
}
