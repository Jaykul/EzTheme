function Get-VSCodeTheme {
    <#
        .SYNOPSIS
            Get a PSReadline theme from a VSCode Theme
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "ByName")]
    param(
        # The name of (or full path to) a vscode json theme which you have installed
        # E.g. 'Dark+' or 'Monokai'
        [ArgumentCompleter({
            Get-VSCodeTheme -List | ForEach-Object {
                if ($_.Name -match "[\s'`"]") {
                    "'{0}'" -f ($_.Name -replace "'", "''")
                } else {
                    $_.Name
                }
            }
        })]
        [Alias("PSPath", "Name")]
        [Parameter(ParameterSetName = "ByName", ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [string]$Theme,

        # List the VSCode themes available
        [Parameter(ParameterSetName = "ListOnly", Mandatory)]
        [switch]$List
    )
    process {
        if ($List) {
            FindVsCodeTheme -List
            return
        } else {
            $VsCodeTheme = FindVsCodeTheme $Theme -ErrorAction Stop
        }

        Write-Verbose "Importing $($VsCodeTheme.Path)"
        if ($PSCmdlet.ShouldProcess($VsCodeTheme.Path, "Convert to $($VsCodeTheme.Name).theme.psd1")) {
            # Load the theme file and split the output into colors and tokencolors
            if ($VsCodeTheme.Path.endswith(".json")) {
                $colors, $tokens = (ImportJsonIncludeLast $VsCodeTheme.Path).Where({!$_.scope}, 'Split', 2)
            } else {
                $colors, $tokens = (Import-PList $VsCodeTheme.Path).settings.Where({!$_.scope}, 'Split', 2)
                $colors = $colors.settings
            }

            $ThemeOutput = [Ordered]@{
                PSTypeName = 'Selected.Microsoft.PowerShell.PSConsoleReadLineOptions'
                # These should come from the base colors, rather than token scopes
                BackgroundColor         = GetColorProperty $colors 'editor.background', 'background', 'settings.background', 'terminal.background'
                DefaultTokenColor       = GetColorProperty $colors 'editor.foreground', 'foreground', 'settings.foreground', 'terminal.foreground'
                SelectionColor          = GetColorProperty $colors 'editor.selectionBackground', 'editor.selectionHighlightBackground', 'selection' -Background
                ErrorColor              = @(@(GetColorProperty $colors 'errorForeground', 'editorError.foreground') + @(GetColorScopeForeground $tokens 'invalid'))[0]
                # The rest of these come from token scopes
                CommandColor            = GetColorScopeForeground $tokens 'support.function'
                CommentColor            = GetColorScopeForeground $tokens 'comment'
                ContinuationPromptColor = GetColorScopeForeground $tokens 'constant.character'
                EmphasisColor           = GetColorScopeForeground $tokens 'markup.bold', 'markup.italic', 'emphasis', 'strong', 'constant.other.color', 'markup.heading'
                KeywordColor            = GetColorScopeForeground $tokens '^keyword.control$', '^keyword$', 'keyword.control', 'keyword'
                MemberColor             = GetColorScopeForeground $tokens 'variable.other.object.property', 'member', 'type.property', 'support.function.any-method', 'entity.name.function'
                NumberColor             = GetColorScopeForeground $tokens 'constant.numeric', 'constant'
                OperatorColor           = GetColorScopeForeground $tokens 'keyword.operator$', 'keyword'
                ParameterColor          = GetColorScopeForeground $tokens 'parameter'
                StringColor             = GetColorScopeForeground $tokens '^string$'
                TypeColor               = GetColorScopeForeground $tokens '^storage.type$', '^support.class$', '^entity.name.type.class$', '^entity.name.type$'
                VariableColor           = GetColorScopeForeground $tokens '^variable$', '^entity.name.variable$', '^variable.other$'
            }

            <# ###### We *COULD* map some colors to other themable modules #####
            # If the VSCode Theme has terminal colors, and you had Theme.WindowsTerminal or Theme.WindowsConsole
            if ($colors.'terminal.ansiBrightYellow') {
                Write-Verbose "Exporting Theme.WindowsTerminal"
                $ThemeOutput['Theme.WindowsTerminal'] = @(
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
                    $ThemeOutput['Theme.WindowsTerminal']['background'] = GetColorProperty $colors "terminal.background"
                }
                if ($colors."terminal.foreground") {
                    $ThemeOutput['Theme.WindowsTerminal']['foreground'] = GetColorProperty $colors "terminal.foreground"
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
                $global:colors = $colors
                $global:tokens = $tokens
                $global:Theme = $ThemeOutput
                ${function:global:Get-VSColorScope} = ${function:GetColorScopeForeground}
                ${function:global:Get-VSColor} = ${function:GetColorProperty}
                Write-Debug "For debugging, `$Theme, `$Colors, `$Tokens were copied to global variables, and Get-VSColor and Get-VSColorScope exported."
            }

            if ($ThemeOutput.Values -contains $null) {
                [string[]]$missing = @()
                foreach ($kv in @($ThemeOutput.GetEnumerator())) {
                    if ($null -eq $kv.Value) {
                        $missing += $kv.Key
                        $ThemeOutput[$kv.Key] = $ThemeOutput["DefaultToken"]
                    }
                }
                Write-Warning "Some PSReadLine color values not set in '$($VsCodeTheme.Path)'. Used DefaultToken for $($missing -join ', ')"
            }

            [PSCustomObject]$ThemeOutput
        }
    }
}