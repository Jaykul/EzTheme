@{
    'Theme.WindowsTerminal' = PSObject @{
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
        cursorColor  = RgbColor '#000000'
        cyan         = RgbColor '#008E81'
        foreground   = RgbColor '#000000'
        green        = RgbColor '#4A8100'
        purple       = RgbColor '#8F0057'
        red          = RgbColor '#BE0000'
        white        = RgbColor '#848388'
        yellow       = RgbColor '#BB6200'
    } -TypeName 'Terminal.ColorScheme'

    'Theme.WindowsConsole' = PSObject @{
        black            = RgbColor '#000000'
        blue             = RgbColor '#0073C3'
        brightBlack      = RgbColor '#454545'
        brightBlue       = RgbColor '#12A8CD'
        brightCyan       = RgbColor '#2BC2A7'
        brightGreen      = RgbColor '#81B600'
        brightPurple     = RgbColor '#C05478'
        brightRed        = RgbColor '#CA7073'
        brightWhite      = RgbColor '#FFFFFF'
        brightYellow     = RgbColor '#CC9800'
        cursorColor      = RgbColor '#000000'
        cyan             = RgbColor '#008E81'
        green            = RgbColor '#4A8100'
        purple           = RgbColor '#8F0057'
        red              = RgbColor '#BE0000'
        white            = RgbColor '#848388'
        yellow           = RgbColor '#BB6200'
        foreground       = RgbColor '#000000'
        background       = RgbColor '#FFFFFF'
        popupBackground  = RgbColor '#FFFFFF'
        popupForeground  = RgbColor '#008080'
    } -TypeName 'Terminal.ColorScheme'

    'Theme.PSReadLine'      = PSObject @{
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
        ParameterColor          = "$([char]27)[90m"
        InlinePredictionColor   = "$([char]27)[90m"
        SelectionColor          = "$([char]27)[48;2;148;198;247m"
        StringColor             = "$([char]27)[38;2;139;0;0m"
        TypeColor               = "$([char]27)[38;2;0;0;139m"
        VariableColor           = "$([char]27)[38;2;255;69;0m"
    } -TypeName 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions'

    PowerLine               = PSObject @{
        Colors              = @((RgbColor '#98F5FF'), (RgbColor '#6495ED'))
        FullColor           = $True
        PowerLineCharacters = @{
            ColorSeparator        = ''
            ReverseSeparator      = ''
            ReverseColorSeparator = ''
            Separator             = ''
        }
        PowerLineFont       = $True
        Prompt              = @(
            ScriptBlock 'New-PromptText -Fg Gray20 -Bg Gray100 -EBg VioletRed $MyInvocation.HistoryId'
            ScriptBlock 'New-PromptText -Fg Gray0 -Bg SkyBlue "I ${Fg:DodgerBlue3}&hearts;${Fg:Gray0} PS"'
        )
        PSReadLinePromptText = @(
            "$([char]27)[48;2;135;206;235m$([char]27)[38;2;0;0;0mI $([char]27)[38;2;24;116;205m♥$([char]27)[38;2;0;0;0m PS$([char]27)[38;2;135;206;235m$([char]27)[49m"
            "$([char]27)[48;2;135;206;235m$([char]27)[38;2;0;0;0mI $([char]27)[38;2;208;32;144m♥$([char]27)[38;2;0;0;0m PS$([char]27)[38;2;135;206;235m$([char]27)[49m"
        )
        SetCurrentDirectory = $True
    } -TypeName 'PowerLine.Theme'
}
