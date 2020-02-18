
@{
  'Theme.WindowsTerminal' = (PSObject @{
    name = 'Lightly'
    foreground = (RgbColor '#000000')
    background = (RgbColor '#FFFFFF')
    black = (RgbColor '#000000')
    blue = (RgbColor '#0073C3')
    brightBlack = (RgbColor '#454545')
    brightBlue = (RgbColor '#12A8CD')
    brightCyan = (RgbColor '#2BC2A7')
    brightGreen = (RgbColor '#81B600')
    brightPurple = (RgbColor '#C05478')
    brightRed = (RgbColor '#CA7073')
    brightWhite = (RgbColor '#FFFFFF')
    brightYellow = (RgbColor '#CC9800')
    cyan = (RgbColor '#008E81')
    green = (RgbColor '#4A8100')
    purple = (RgbColor '#8F0057')
    red = (RgbColor '#BE0000')
    white = (RgbColor '#848388')
    yellow = (RgbColor '#BB6200')
  } -TypeName 'WindowsTerminal.ColorScheme','System.Management.Automation.PSCustomObject','System.Object')

  'Theme.PSReadLine' = (PSObject @{
    CommandColor = '[30m'
    CommentColor = '[37m'
    ContinuationPromptColor = '[93m'
    DefaultTokenColor = '[90m'
    EmphasisColor = '[38;2;199;21;133m'
    ErrorColor = '[91m'
    KeywordColor = '[33m'
    MemberColor = '[95m'
    NumberColor = '[31m'
    OperatorColor = '[91m'
    ParameterColor = '[90m'
    SelectionColor = '[100m[96m'
    StringColor = '[36m'
    TypeColor = '[34m'
    VariableColor = '[35m'
  } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions','System.Management.Automation.PSCustomObject','System.Object')
}
