
@{
  'Theme.WindowsTerminal' = (PSObject @{
    name = 'Darkly'
    foreground = (RgbColor '#FFFCFF')
    background = (RgbColor '#212021')
    black = (RgbColor '#212021')
    blue = (RgbColor '#01A0E4')
    brightBlack = (RgbColor '#493F3F')
    brightBlue = (RgbColor '#6ECEFF')
    brightCyan = (RgbColor '#95F2FF')
    brightGreen = (RgbColor '#6CD18E')
    brightPurple = (RgbColor '#D29BC6')
    brightRed = (RgbColor '#FF6E6D')
    brightWhite = (RgbColor '#FFFCFF')
    brightYellow = (RgbColor '#FFFF85')
    cyan = (RgbColor '#55C4CF')
    green = (RgbColor '#01A252')
    purple = (RgbColor '#A16A94')
    red = (RgbColor '#D92D20')
    white = (RgbColor '#A5A2A2')
    yellow = (RgbColor '#FBED02')
  } -TypeName 'WindowsTerminal.ColorScheme','System.Management.Automation.PSCustomObject','System.Object')

  'Theme.PSReadLine' = (PSObject @{
    CommandColor = '[36m'
    CommentColor = '[37m'
    ContinuationPromptColor = '[93m'
    DefaultTokenColor = '[97m'
    EmphasisColor = '[38;2;199;21;133m'
    ErrorColor = '[91m'
    KeywordColor = '[93m'
    MemberColor = '[95m'
    NumberColor = '[31m'
    OperatorColor = '[91m'
    ParameterColor = '[96m'
    SelectionColor = '[100m[96m'
    StringColor = '[92m'
    TypeColor = '[34m'
    VariableColor = '[35m'
  } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions','System.Management.Automation.PSCustomObject','System.Object')
}
