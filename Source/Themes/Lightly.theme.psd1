@{
  'Theme.PSReadLine' = (PSObject @{
    DefaultTokenColor = 'DarkGray'
    CommandColor = 'Black'
    CommentColor = 'Gray'
    ContinuationPromptColor = 'Yellow'
    ErrorColor = 'Red'
    KeywordColor = 'DarkYellow'
    MemberColor = 'Magenta'
    NumberColor = 'DarkRed'
    OperatorColor = 'Red'
    ParameterColor = 'DarkGray'
    StringColor = 'DarkCyan'
    TypeColor = 'DarkBlue'
    VariableColor = 'DarkMagenta'
    EmphasisColor = "`e[38;2;199;21;134m"
    SelectionColor = "`e[100;96m"
  } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions','System.Management.Automation.PSCustomObject','System.Object')

  'Theme.PowerShell' = (PSObject @{
    Background = ConsoleColor White
    Foreground = ConsoleColor Gray
    FormatAccentColor = ConsoleColor Green
    ErrorAccentColor = ConsoleColor Cyan
    DebugBackgroundColor = ConsoleColor White
    DebugForegroundColor = ConsoleColor DarkGreen
    ErrorBackgroundColor = ConsoleColor White
    ErrorForegroundColor = ConsoleColor DarkRed
    ProgressBackgroundColor = ConsoleColor DarkMagenta
    ProgressForegroundColor = ConsoleColor Yellow
    VerboseBackgroundColor = ConsoleColor White
    VerboseForegroundColor = ConsoleColor DarkBlue
    WarningBackgroundColor = ConsoleColor White
    WarningForegroundColor = ConsoleColor DarkMagenta
  } -TypeName 'Selected.Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy','System.Management.Automation.PSCustomObject','System.Object')

  'Theme.WindowsTerminal' = (PSObject @{
    name = 'Lightly'
    foreground = RgbColor '#000000'
    background = RgbColor '#FFFFFF'
    black = RgbColor '#000000'
    blue = RgbColor '#0073C3'
    brightBlack = RgbColor '#454545'
    brightBlue = RgbColor '#12A8CD'
    brightCyan = RgbColor '#2BC2A7'
    brightGreen = RgbColor '#81B600'
    brightPurple = RgbColor '#C05478'
    brightRed = RgbColor '#CA7073'
    brightWhite = RgbColor '#FFFFFF'
    brightYellow = RgbColor '#CC9800'
    cyan = RgbColor '#008E81'
    green = RgbColor '#4A8100'
    purple = RgbColor '#8F0057'
    red = RgbColor '#BE0000'
    white = RgbColor '#848388'
    yellow = RgbColor '#BB6200'
  } -TypeName 'WindowsTerminal.ColorScheme','System.Management.Automation.PSCustomObject','System.Object')
}