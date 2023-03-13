@{
    'Theme.Terminal'    = PSObject @{
        foreground      = RgbColor '#EEEDF0'
        background      = RgbColor '#012456'
        brightBlack     = RgbColor '#808080'
        brightBlue      = RgbColor '#0000FF'
        brightCyan      = RgbColor '#00FFFF'
        brightGreen     = RgbColor '#00FF00'
        brightPurple    = RgbColor '#FF00FF'
        brightRed       = RgbColor '#FF0000'
        brightWhite     = RgbColor '#FFFFFF'
        brightYellow    = RgbColor '#FFFF00'
        black           = RgbColor '#000000'
        blue            = RgbColor '#000080'
        cyan            = RgbColor '#008080'
        green           = RgbColor '#008000'
        purple          = RgbColor '#012456'
        red             = RgbColor '#800000'
        white           = RgbColor '#C0C0C0'
        yellow          = RgbColor '#EEEDF0'
    } -TypeName 'Terminal.ColorScheme'

    'Theme.WindowsTerminal'    = PSObject @{
        foreground      = RgbColor '#EEEDF0'
        background      = RgbColor '#012456'
        brightBlack     = RgbColor '#808080'
        brightBlue      = RgbColor '#0000FF'
        brightCyan      = RgbColor '#00FFFF'
        brightGreen     = RgbColor '#00FF00'
        brightPurple    = RgbColor '#FF00FF'
        brightRed       = RgbColor '#FF0000'
        brightWhite     = RgbColor '#FFFFFF'
        brightYellow    = RgbColor '#FFFF00'
        black           = RgbColor '#000000'
        blue            = RgbColor '#000080'
        cyan            = RgbColor '#008080'
        green           = RgbColor '#008000'
        purple          = RgbColor '#012456'
        red             = RgbColor '#800000'
        white           = RgbColor '#C0C0C0'
        yellow          = RgbColor '#EEEDF0'
    } -TypeName 'Terminal.ColorScheme'

    'Theme.WindowsConsole' = PSObject @{
        foreground      = RgbColor '#EEEDF0'
        background      = RgbColor '#012456'
        brightBlack     = RgbColor '#808080'
        brightBlue      = RgbColor '#0000FF'
        brightCyan      = RgbColor '#00FFFF'
        brightGreen     = RgbColor '#00FF00'
        brightPurple    = RgbColor '#FF00FF'
        brightRed       = RgbColor '#FF0000'
        brightWhite     = RgbColor '#FFFFFF'
        brightYellow    = RgbColor '#FFFF00'
        black           = RgbColor '#000000'
        blue            = RgbColor '#000080'
        cyan            = RgbColor '#008080'
        green           = RgbColor '#008000'
        purple          = RgbColor '#012456'
        red             = RgbColor '#800000'
        white           = RgbColor '#C0C0C0'
        yellow          = RgbColor '#EEEDF0'
        popupBackground = RgbColor '#FFFFFF'
        popupForeground = RgbColor '#008080'
    } -TypeName 'Terminal.ColorScheme'

    'Theme.PowerShell' = PSObject @{
        Background              = ConsoleColor DarkMagenta
        Foreground              = ConsoleColor DarkYellow
        DebugBackgroundColor    = ConsoleColor DarkMagenta
        DebugForegroundColor    = ConsoleColor Green
        ErrorAccentColor        = ConsoleColor Cyan
        ErrorBackgroundColor    = ConsoleColor Black
        ErrorForegroundColor    = ConsoleColor Red
        FormatAccentColor       = ConsoleColor Green
        ProgressBackgroundColor = ConsoleColor DarkCyan
        ProgressForegroundColor = ConsoleColor Yellow
        VerboseBackgroundColor  = ConsoleColor DarkMagenta
        VerboseForegroundColor  = ConsoleColor Cyan
        WarningBackgroundColor  = ConsoleColor DarkMagenta
        WarningForegroundColor  = ConsoleColor Yellow
    } -TypeName 'Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy'

    'Theme.PSReadLine' = PSObject @{
        CommandColor            = "$([char]27)[38;2;255;230;109m"
        CommentColor            = "$([char]27)[38;2;139;123;139m"
        ContinuationPromptColor = "$([char]27)[38;2;0;232;198m"
        DefaultTokenColor       = "$([char]27)[38;2;213;206;217m"
        EmphasisColor           = "$([char]27)[38;2;243;156;18m"
        ErrorColor              = "$([char]27)[4;38;2;255;93;97m"
        KeywordColor            = "$([char]27)[38;2;199;77;147m"
        MemberColor             = "$([char]27)[38;2;43;168;256m"
        NumberColor             = "$([char]27)[38;2;243;43;23m"
        OperatorColor           = "$([char]27)[38;2;238;130;98m"
        ParameterColor          = "$([char]27)[38;2;143;228;256m"
        SelectionColor          = "$([char]27)[100;38;2;190;190;190m"
        StringColor             = "$([char]27)[38;2;150;224;114m"
        TypeColor               = "$([char]27)[38;2;255;130;171m"
        VariableColor           = "$([char]27)[38;2;0;242;178m"
    } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions'
    PowerLine          = (PowerLineTheme @{
        DefaultCapsLeftAligned            = '', ''
        DefaultCapsRightAligned           = '', ''
        DefaultSeparator                  = '', ''
        Prompt                            = @(
            Show-HistoryId -DBg "Gray100" -EBg 'VioletRed' -Fg 'Gray20' -EFg 'Gray20'
            New-TerminalBlock -Content "I $([char]27)[31m&hearts;$([char]27)[38;2;0;0;0m PS" -Background "SkyBlue" -Fg 'Gray0'
        )
        PSReadLineContinuationPrompt      = '█ '
        PSReadLineContinuationPromptColor = ''
        PSReadLinePromptText              = '', ''
        SetCurrentDirectory               = $false
    })
}
