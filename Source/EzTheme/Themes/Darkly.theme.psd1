@{  # There are three copies here of the Terminal.ColorScheme, one for each terminal-theming module
    'Theme.Terminal'        = PSObject @{
        foreground   = '#FFFCFF'
        background   = '#212021'

        black        = '#212021'
        blue         = '#01A0E4'
        brightBlack  = '#493F3F'
        brightBlue   = '#6ECEFF'
        brightCyan   = '#95F2FF'
        brightGreen  = '#6CD18E'
        brightPurple = '#D29BC6'
        brightRed    = '#FF6E6D'
        brightWhite  = '#FFFCFF'
        brightYellow = '#FFFF85'
        cyan         = '#55C4CF'
        green        = '#01A252'
        purple       = '#A16A94'
        red          = '#D92D20'
        white        = '#A5A2A2'
        yellow       = '#FBED02'
    } -TypeName 'Terminal.ColorScheme'

    'Theme.WindowsTerminal' = PSObject @{
        name         = 'Darkly'
        foreground   = '#FFFCFF'
        background   = '#212021'
        cursorColor  = '#EFEFEF'
        selectionBackground = '#82C1FF'

        black        = '#212021'
        blue         = '#01A0E4'
        brightBlack  = '#493F3F'
        brightBlue   = '#6ECEFF'
        brightCyan   = '#95F2FF'
        brightGreen  = '#6CD18E'
        brightPurple = '#D29BC6'
        brightRed    = '#FF6E6D'
        brightWhite  = '#FFFCFF'
        brightYellow = '#FFFF85'
        cyan         = '#55C4CF'
        green        = '#01A252'
        purple       = '#A16A94'
        red          = '#D92D20'
        white        = '#A5A2A2'
        yellow       = '#FBED02'
    } -TypeName 'Terminal.ColorScheme'

    'Theme.WindowsConsole'  = PSObject @{
        foreground   = '#FFFCFF'
        background   = '#212021'

        black        = '#212021'
        blue         = '#01A0E4'
        brightBlack  = '#493F3F'
        brightBlue   = '#6ECEFF'
        brightCyan   = '#95F2FF'
        brightGreen  = '#6CD18E'
        brightPurple = '#D29BC6'
        brightRed    = '#FF6E6D'
        brightWhite  = '#FFFCFF'
        brightYellow = '#FFFF85'
        cyan         = '#55C4CF'
        green        = '#01A252'
        purple       = '#A16A94'
        red          = '#D92D20'
        white        = '#A5A2A2'
        yellow       = '#FBED02'
    } -TypeName 'Terminal.ColorScheme'

    'Theme.PowerShell'      = PSObject @{
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

    'Theme.PSReadLine'      = PSObject @{
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
        InlinePredictionColor   = "$([char]27)[38;2;95;97;103m"
        SelectionColor          = "$([char]27)[100;38;2;190;190;190m"
        StringColor             = "$([char]27)[38;2;150;224;114m"
        TypeColor               = "$([char]27)[38;2;238;93;67m"
        VariableColor           = "$([char]27)[38;2;0;242;178m"
    } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions'

    PowerLine               = PSObject @{
        Cap = ''
        Colors = @('#333333','#424242','#8A8A8A','#707070')
        FullColor = $True
        PowerLineFont = $True
        Prompt = @(
(ConvertFrom-Metadata @'
@{
ForegroundColor='White'
BackgroundColor='#333333'
ErrorBackgroundColor='#8B2252'
Separator='‍'
Cap='‍'
Entities=1
Persist=1
Object=(ScriptBlock '$MyInvocation.HistoryId')
}
'@ -As PoshCode.PowerLine.PowerLineBlock),
(ConvertFrom-Metadata @'
@{
ForegroundColor='#C4C0C7'
BackgroundColor='#424242'
Separator='‍'
Cap='‍'
Entities=1
Persist=1
Object=(ScriptBlock 'Get-ShortPath')
}
'@ -As PoshCode.PowerLine.PowerLineBlock),
(ConvertFrom-Metadata @'
@{
Separator='‍'
Cap='‍'
Entities=1
Persist=1
Object="`t"
}
'@ -As PoshCode.PowerLine.PowerLineBlock),
(ConvertFrom-Metadata @'
@{
ForegroundColor='#000000'
BackgroundColor='#8A8A8A'
Separator='‍'
Cap='‍'
Entities=1
Persist=1
Object=(ScriptBlock 'Get-Elapsed')
}
'@ -As PoshCode.PowerLine.PowerLineBlock),
(ConvertFrom-Metadata @'
@{
ForegroundColor='#EBE7EE'
BackgroundColor='#707070'
Separator='‍'
Cap='‍'
Entities=1
Persist=1
Object=(ScriptBlock 'Get-Date -f "T"')
}
'@ -As PoshCode.PowerLine.PowerLineBlock),
(ConvertFrom-Metadata @'
@{
Separator='‍'
Cap='‍'
Entities=1
Persist=1
Object="`n"
}
'@ -As PoshCode.PowerLine.PowerLineBlock),
(ConvertFrom-Metadata @'
@{
ForegroundColor='#CCCCCC'
BackgroundColor='#666666'
Separator='‍'
Cap='‍'
Entities=1
Persist=1
Object='&ColorSeparator;'
}
'@ -As PoshCode.PowerLine.PowerLineBlock))
        PSReadLineContinuationPrompt = '[38;2;204;204;204m[49m [0m'
        PSReadLineContinuationPromptColor = '[38;2;0;232;198m'
        PSReadLinePromptText = @('[48;2;102;102;102m[38;2;204;204;204m[49m[38;2;102;102;102m[0m','[48;2;139;34;82m[38;2;204;204;204m[49m[38;2;139;34;82m[0m')
        Separator = ''
        SetCurrentDirectory = $True
    } -TypeName 'PowerLine.Theme','System.Management.Automation.PSCustomObject','System.Object'
}
