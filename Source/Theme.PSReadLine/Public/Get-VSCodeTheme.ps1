function Get-VSCodeTheme {
    <#
        .SYNOPSIS
            Get a PSReadLine theme from a VS Code Theme that you have installed locally.
        .DESCRIPTION
            Gets PSReadLine colors from a Visual Studio Code Theme. Only works with locally installed Themes, but includes tab-completion for theme names so you can Ctrl+Space to list the ones you have available.

            The default output will show a little preview of what PSReadLine will look like. Note that the PSReadLine theme will _not_ set the background color.

            You can pipe the output to Set-PSReadLineTheme to import the theme for the PSReadLine module.

            Note that you may want to use -Verbose to see details of the import. In some cases, Get-VSCodeTheme will not be able to determine values for all PSReadLine colors, and there is a verbose output showing the colors that get the default value.
        .Example
            Get-VSCodeTheme 'Light+ (default light)'

            Gets the default "Dark+" theme from Code and shows you a preview. Note that to use this theme effectively, you need to have your terminal background color set to a light color like the white in the preview.
        .Example
            Get-VSCodeTheme 'Dark+ (default dark)' | Set-PSReadLineTheme

            Imports the "Dark+" theme from Code and sets it as your PSReadLine color theme.
        .Link
            Set-PSReadLineTheme
            Get-PSReadLineTheme
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "ByName")]
    param(
        # The name of (or full path to) a vscode json theme which you have installed
        # E.g. 'Dark+' or 'Monokai'
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            Get-VSCodeTheme -List | ForEach-Object {
                if ($_.Name -match "[\s'`"]") {
                    "'{0}'" -f ($_.Name -replace "'", "''")
                } else {
                    $_.Name
                }
            } | Where-Object { $_.StartsWith($wordToComplete) }
        })]
        [Alias("PSPath", "Theme")]
        [Parameter(ParameterSetName = "ByName", ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [string]$Name,

        # List the VSCode themes available
        [Parameter(ParameterSetName = "ListOnly", Mandatory)]
        [switch]$List,

        [Parameter(ParameterSetName = "ListOnly")]
        [ValidateSet("dark", "light", "highcontrast")]
        [string]$Style
    )
    process {
        $VSCodeTheme = FindVsCodeTheme @PSBoundParameters
        if ($List) {
            $VsCodeTheme
            return
        }

        if ($PSCmdlet.ShouldProcess($VsCodeTheme.Path, "Read colors from theme")) {
            # Load the theme file and split the output into colors and tokencolors
            if ($VsCodeTheme.Path.endswith(".json")) {
                $colors, $tokens = (ImportJsonIncludeLast $VsCodeTheme.Path).Where({ !$_.scope }, 'Split', 2)
            } else {
                $colors, $tokens = (Import-PList $VsCodeTheme.Path).settings.Where({ !$_.scope }, 'Split', 2)
                $colors = $colors.settings
            }

            $ThemeOutput = [Ordered]@{
                PSTypeName              = 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions'
                ThemeName               = $VsCodeTheme.Name
                # These should come from the base colors, rather than token scopes
                BackgroundColor         = if ($BackgroundColor = GetColorProperty $colors 'editor.background', 'background', 'settings.background', 'terminal.background') { $BackgroundColor } else { $VSCodeTheme.Style -match 'dark|black' ? "`e[40m" : "`e[48;2;255;255;255m" }
                DefaultTokenColor       = if ($ForegroundColor = GetColorProperty $colors 'editor.foreground', 'foreground', 'settings.foreground', 'terminal.foreground') { $ForegroundColor } else { $VSCodeTheme.Style -match 'dark|black' ? "`e[37m" : "`e[30m" }
                SelectionColor          = GetColorProperty $colors 'editor.selectionBackground', 'editor.selectionHighlightBackground', 'selection' -Background
                ErrorColor              = @(@(GetColorProperty $colors 'errorForeground', 'editorError.foreground') + @(GetColorScopeForeground $tokens 'invalid'))[0]
                # The rest of these come from token scopes
                CommandColor            = if ($color = GetColorScopeForeground $tokens 'support.function') { $color } else { $ForegroundColor }
                CommentColor            = if ($color = GetColorScopeForeground $tokens 'comment') { $color } else { $ForegroundColor }
                ContinuationPromptColor = if ($color = GetColorScopeForeground $tokens 'constant.character') { $color } else { $ForegroundColor }
                EmphasisColor           = if ($color = GetColorScopeForeground $tokens 'markup.bold', 'markup.italic', 'emphasis', 'strong', 'constant.other.color', 'markup.heading') { $color } else { $ForegroundColor }
                InlinePredictionColor   = if ($color = GetColorScopeForeground $tokens 'markup.underline') { $color } else { $ForegroundColor }
                KeywordColor            = if ($color = GetColorScopeForeground $tokens '^keyword.control$', '^keyword$', 'keyword.control', 'keyword') { $color } else { $ForegroundColor }
                MemberColor             = if ($color = GetColorScopeForeground $tokens 'variable.other.object.property', 'member', 'type.property', 'support.function.any-method', 'entity.name.function') { $color } else { $ForegroundColor }
                NumberColor             = if ($color = GetColorScopeForeground $tokens 'constant.numeric', 'constant') { $color } else { $ForegroundColor }
                OperatorColor           = if ($color = GetColorScopeForeground $tokens 'keyword.operator$', 'keyword') { $color } else { $ForegroundColor }
                ParameterColor          = if ($color = GetColorScopeForeground $tokens 'parameter') { $color } else { $ForegroundColor }
                StringColor             = if ($color = GetColorScopeForeground $tokens '^string$') { $color } else { $ForegroundColor }
                TypeColor               = if ($color = GetColorScopeForeground $tokens '^storage.type$', '^support.class$', '^entity.name.type.class$', '^entity.name.type$') { $color } else { $ForegroundColor }
                VariableColor           = if ($color = GetColorScopeForeground $tokens '^variable$', '^entity.name.variable$', '^variable.other$') { $color } else { $ForegroundColor }
            }

            <# ###### We *COULD* map some colors to other themable modules #####
            # If the VSCode Theme has terminal colors, and you had Theme.Terminal or Theme.WindowsTerminal or Theme.WindowsConsole
            if ($colors.'terminal.ansiBrightYellow') {
                Write-Verbose "Exporting Theme.Terminal"
                $ThemeOutput['Theme.Terminal'] = @(
                        GetColorProperty $colors "terminal.ansiBlack"
                        GetColorProperty $colors "terminal.ansiRed"
                        GetColorProperty $colors "terminal.ansiGreen"
                        GetColorProperty $colors "terminal.ansiYellow"
                        GetColorProperty $colors "terminal.ansiBlue"
                        GetColorProperty $colors "terminal.ansiMagenta"
                        GetColorProperty $colors "terminal.ansiCyan"
                        GetColorProperty $colors "terminal.ansiWhite"
                        GetColorProperty $colors "terminal.ansiBrightBlack"
                        GetColorProperty $colors "terminal.ansiBrightRed"
                        GetColorProperty $colors "terminal.ansiBrightGreen"
                        GetColorProperty $colors "terminal.ansiBrightYellow"
                        GetColorProperty $colors "terminal.ansiBrightBlue"
                        GetColorProperty $colors "terminal.ansiBrightMagenta"
                        GetColorProperty $colors "terminal.ansiBrightCyan"
                        GetColorProperty $colors "terminal.ansiBrightWhite"
                    )
                if ($colors."terminal.background") {
                    $ThemeOutput['Theme.Terminal']['background'] = GetColorProperty $colors "terminal.background"
                }
                if ($colors."terminal.foreground") {
                    $ThemeOutput['Theme.Terminal']['foreground'] = GetColorProperty $colors "terminal.foreground"
                }
            }

            # If the VSCode Theme has warning/info colors, and you had Theme.PowerShell
            if (GetColorProperty $colors 'editorWarning.foreground') {
                $ThemeOutput['Theme.PowerShell'] = @{
                    WarningForegroundColor  = GetColorProperty $colors 'editorWarning.foreground'
                    ErrorForegroundColor = GetColorProperty $Colors 'editorError.foreground'
                    VerboseForegroundColor = GetColorProperty $Colors 'editorInfo.foreground'
                    ProgressForegroundColor = GetColorProperty $Colors 'notifications.foreground'
                    ProgressBackgroundColor = GetColorProperty $Colors 'notifications.background'
                }
            } #>

            if ($DebugPreference -in "Continue", "Inquire") {
                $global:ThemeColors = $colors
                $global:ThemeTokens = $tokens
                $global:Theme = $ThemeOutput
                ${function:global:Get-VSColorScope} = ${function:GetColorScopeForeground}
                ${function:global:Get-VSColor} = ${function:GetColorProperty}
                Write-Debug "For debugging, `$Theme, `$ThemeColors, `$ThemeTokens were set as global variables, and Get-VSColor and Get-VSColorScope exported."
            }

            [PSCustomObject]$ThemeOutput
        }
    }
}