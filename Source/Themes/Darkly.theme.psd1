@{
  'Theme.PSReadLine' = (PSObject @{
    DefaultTokenColor = 'White'
    CommandColor = 'DarkCyan'
    CommentColor = 'Gray'
    ContinuationPromptColor = 'Yellow'
    ErrorColor = 'Red'
    KeywordColor = 'Yellow'
    MemberColor = 'Magenta'
    NumberColor = 'DarkRed'
    OperatorColor = 'Red'
    ParameterColor = 'Cyan'
    StringColor = 'Green'
    TypeColor = 'DarkBlue'
    VariableColor = 'DarkMagenta'
    EmphasisColor = "`e[38;2;199;21;133m"
    SelectionColor = "`e[100;96m"
  } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions','System.Management.Automation.PSCustomObject','System.Object')

  'Theme.PowerShell' = (PSObject @{
    Background = ConsoleColor Black
    Foreground = ConsoleColor Gray
    DebugBackgroundColor = ConsoleColor Black
    DebugForegroundColor = ConsoleColor Green
    ErrorAccentColor = ConsoleColor Cyan
    ErrorBackgroundColor = ConsoleColor Black
    ErrorForegroundColor = ConsoleColor Red
    FormatAccentColor = ConsoleColor Green
    ProgressBackgroundColor = ConsoleColor DarkMagenta
    ProgressForegroundColor = ConsoleColor Yellow
    VerboseBackgroundColor = ConsoleColor Black
    VerboseForegroundColor = ConsoleColor Cyan
    WarningBackgroundColor = ConsoleColor Black
    WarningForegroundColor = ConsoleColor Yellow
  } -TypeName 'Selected.Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy','System.Management.Automation.PSCustomObject','System.Object')

  'Theme.WindowsTerminal' = (PSObject @{
    name = 'Darkly'
    background = RgbColor '#212021'
    foreground = RgbColor '#FFFCFF'
    brightBlack = RgbColor '#493F3F'
    brightBlue = RgbColor '#6ECEFF'
    brightCyan = RgbColor '#95F2FF'
    brightGreen = RgbColor '#6CD18E'
    brightPurple = RgbColor '#D29BC6'
    brightRed = RgbColor '#FF6E6D'
    brightWhite = RgbColor '#FFFCFF'
    brightYellow = RgbColor '#FFFF85'
    black = RgbColor '#212021'
    blue = RgbColor '#01A0E4'
    cyan = RgbColor '#55C4CF'
    green = RgbColor '#01A252'
    purple = RgbColor '#A16A94'
    red = RgbColor '#D92D20'
    white = RgbColor '#A5A2A2'
    yellow = RgbColor '#FBED02'
  } -TypeName 'WindowsTerminal.ColorScheme','System.Management.Automation.PSCustomObject','System.Object')
}