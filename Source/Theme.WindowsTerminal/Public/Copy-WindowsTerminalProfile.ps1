function Copy-WindowsTerminalProfile {
    <#
        .SYNOPSIS
            Creates a new WindowsTerminalProfile based on another
    #>
    [Alias("cptp")]
    [CmdletBinding(DefaultParameterSetName="SimpleCopy")]
    param(
        # The name of the profile to copy. By default, copies the current profile
        [Parameter()]
        [string]$SourceProfileName,

        # The name of the new profile. If it already exists, it will be overwritten
        [Parameter(Mandatory, Position = 0)]
        [string]$NewProfileName,

        # A command-line to override the one in the source profle
        [Parameter(Position = 1)]
        [string]$CommandLine,

        # If set, creates a new tab immediately from the profile
        [switch]$CreateTab,

        # If set, creates a new tab and immediately removes the profile
        [switch]$AutoDelete,

        # If set, this text is written to the bottom right corner of the background image
        [Parameter(Position = 2, ParameterSetName = "WithText")]
        [string]$TextForBackground,

        [Parameter(ParameterSetName = "WithText")]
        [System.Drawing.Size]$ImageSize,

        # Number of pixels of padding for the text on the left. By default, 20 pixels.
        [Parameter(ParameterSetName = "WithText")]
        [int]$LeftPadding = 20,

        # Number of pixels of padding for the text on the top. By default, 20 pixels.
        [Parameter(ParameterSetName = "WithText")]
        [int]$TopPadding = 20,

        # Number of pixels of padding for the text on the right. By default, 20 pixels.
        [Parameter(ParameterSetName = "WithText")]
        [int]$RightPadding = 20,

        # Number of pixels of padding for the text on the bottom. By default, 20 pixels.
        [Parameter(ParameterSetName = "WithText")]
        [int]$BottomPadding = 20,

        # The font name (defaults to "Cascadia Code")
        [Parameter(ParameterSetName = "WithText")]
        [string]$FontName = "Cascadia Code",

        # The font size (defaults to 28)
        [Parameter(ParameterSetName = "WithText")]
        [int]$FontSize = 28,

        # The font style defaults to bold
        [Parameter(ParameterSetName = "WithText")]
        [System.Drawing.FontStyle]$FontStyle = "Bold",

        # The alignment relative to the background + bounds.
        # In a left-to-right layout, the far position is bottom, and the near position is top.
        [Parameter(ParameterSetName = "WithText")]
        [System.Drawing.StringAlignment]$VerticalAlignment = "Far",

        # The alignment relative to the background + bounds.
        # In a left-to-right layout, the far position is right, and the near position is left.
        # However, in a right-to-left layout, the far position is left.
        [Parameter(ParameterSetName = "WithText")]
        [System.Drawing.StringAlignment]$HorizontalAlignment = "Far",

        # The stroke color defaults to [System.Drawing.Brushes]::Black
        [Parameter(ParameterSetName = "WithText")]
        [System.Drawing.Brush]$StrokeBrush = [System.Drawing.Brushes]::Black,

        # The fill color defaults to [System.Drawing.Brushes]::White
        [Parameter(ParameterSetName = "WithText")]
        [System.Drawing.Brush]$FillBrush = [System.Drawing.Brushes]::White
    )
    process {
        $LayeredConfig = GetLayeredConfig -FlattenDefaultProfile
        $Config = GetSimpleConfig

        if ($SourceProfileName) {
            $SourceProfile = @($LayeredConfig.profiles.list).Where({ $_.Name -eq $SourceProfileName }, "First", 1)[0] | Select-Object *
        }
        if (!$SourceProfile) {
            $SourceProfile = FindProfile $LayeredConfig.profiles.list
        }

        if (!($ActualProfile = @($Config.profiles.list).Where({ $_.Name -eq $SourceProfile.Name }, "First", 1)[0] | Select-Object * -ExcludeProperty "source", "hidden")) {
            $ActualProfile = $SourceProfile | Select-Object * -ExcludeProperty "source", "hidden"
        }

        $ActualProfile | Add-Member -NotePropertyName name $NewProfileName -force
        $ActualProfile | Add-Member -NotePropertyName guid ([guid]::NewGuid().ToString("b")) -force
        $ActualProfile | Add-Member -NotePropertyName commandline $CommandLine -force

        if ($TextForBackground) {
            # Make a copy of the PSBoundParameters that only has parameters from Write-TextOnImage
            $TextParameters = @{} + $PSBoundParameters
            $ParameterNames = (Get-Command Write-TextOnImage).Parameters.Keys
            @($PSBoundParameters.Keys.
                Where({ $_ -notin $ParameterNames })).
                ForEach({ $TextParameters.Remove($_) })

            try {
                $TerminalTempState = Join-Path $Env:LocalAppData "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/TempState"
                if ($SourceProfile.backgroundImage) {
                    $TerminalRoamingState = Join-Path $Env:LocalAppData "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/RoamingState/"
                    $TerminalLocalState = Join-Path $Env:LocalAppData "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/"
                    $Path = $SourceProfile.backgroundImage -replace "ms-appdata:///roaming/", $TerminalRoamingState -replace "ms-appdata:///local/", $TerminalLocalState
                    Write-Verbose "Existing Background Image: $Path"
                    $BackgroundFile = Write-TextOnImage -Path $Path -Text $TextForBackground @TextParameters
                    $ActualProfile | Add-Member -NotePropertyName backgroundImage $BackgroundFile.FullName -Force
                } else {
                    $Path = Join-Path $TerminalTempState (Get-Date -f "yyyyMMddhhmmss.pn\g")
                    $BackgroundFile = Write-TextOnImage -NewPath $Path -ImageSize ([System.Drawing.Size]::new(256,256)) -Text $TextForBackground @TextParameters
                    $ActualProfile | Add-Member -NotePropertyName backgroundImage $BackgroundFile.FullName -Force
                }
            } catch {
                Write-Error "Couldn't update the background image. You may need to use a full file path or ms-appdata:/// path." -ErrorAction Continue
            }
        }

        $Config.profiles.list += $ActualProfile

        Set-Content $UserConfigFile ($Config | ConvertTo-Json -Depth 10)

        if ($CreateTab -or $AutoDelete) {
            $DefaultProfile = $Config.defaultProfile
            $DefaultKeyBindings = $Config.keybindings

            $Config.defaultProfile = $ActualProfile.guid

            # Force the newTab hotkey to something
            $NewTab = @($LayeredConfig.keybindings).where({ $_.command -eq "newTab" }, "First", 1)[0]
            $NewTab.keys = @( "ctrl+t" )
            $Config.keybindings = @($NewTab)
            Set-Content $UserConfigFile ($Config | ConvertTo-Json -Depth 10)
            Start-Sleep 1 # you have to wait for the terminal to _notice_ the config change

            # Create a new tab and then set the old default back
            Add-Type -AssemblyName System.Windows.Forms
            [System.Windows.Forms.SendKeys]::SendWait("^t")

            $Config.defaultProfile = $DefaultProfile
            $Config.keybindings = $DefaultKeyBindings
            if ($AutoDelete) {
                $Config.profiles.list = @($Config.profiles.list).Where{ $_.guid -ne $ActualProfile.guid }
            }
            Set-Content $UserConfigFile ($Config | ConvertTo-Json -Depth 10)
        }
    }
}