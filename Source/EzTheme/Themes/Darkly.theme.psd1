@{  # There are three copies here of the Terminal.ColorScheme, one for each terminal-theming module
    'Theme.Terminal' = PSObject @{
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
    } -TypeName 'Terminal.ColorScheme'


    'Theme.WindowsTerminal' = PSObject @{
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
    } -TypeName 'Terminal.ColorScheme'

    'Theme.WindowsConsole'        = PSObject @{
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
    } -TypeName 'Terminal.ColorScheme'

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
    } -TypeName 'Selected.Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy'

    'Theme.PSReadLine' = PSObject @{
        CommandColor            = "$([char]27)[38;2;255;230;109m"
        CommentColor            = "$([char]27)[38;2;95;97;103m"
        ContinuationPromptColor = "$([char]27)[38;2;0;232;198m"
        DefaultTokenColor       = "$([char]27)[38;2;213;206;217m"
        EmphasisColor           = "$([char]27)[38;2;243;156;18m"
        ErrorColor              = "$([char]27)[4;38;2;255;93;97m"
        KeywordColor            = "$([char]27)[38;2;199;77;147m"
        MemberColor             = "$([char]27)[38;2;43;168;256m"
        NumberColor             = "$([char]27)[38;2;243;43;23m"
        OperatorColor           = "$([char]27)[38;2;238;93;67m"
        ParameterColor          = "$([char]27)[38;2;143;228;256m"
        PredictionColor         = "$([char]27)[38;2;95;97;103m"
        SelectionColor          = "$([char]27)[100;38;2;190;190;190m"
        StringColor             = "$([char]27)[38;2;150;224;114m"
        TypeColor               = "$([char]27)[38;2;238;93;67m"
        VariableColor           = "$([char]27)[38;2;0;242;178m"
    } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions'

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
    } -TypeName 'PowerLine.Theme'
}
