using namespace PoshCode.Pansies

function Convert-ColorScheme {
    [CmdletBinding(DefaultParameterSetName = "Dark")]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSTypeName("Terminal.ColorScheme")]
        [Alias("ColorScheme")]
        $InputObject,

        # If set, change the dark colors (use negative values to make them darker)
        [Parameter(Mandatory, ParameterSetName = "Dark", Position = 0)]
        [int]$DarkShift,

        # If set, change the bright colors (use positive values to make them brighter)
        [Parameter(Mandatory, ParameterSetName = "Bright")]
        [int]$BrightShift
    )
    begin {
        $comparer = [PoshCode.Pansies.ColorSpaces.Comparisons.CieDe2000Comparison]::new()
    }
    end {
        if (@($InputObject.PSTypeName) -eq "Terminal.ColorScheme") {
            # brightBlack, brightRed, brightGreen, brightYellow, brightBlue, brightPurple, brightCyan, brightWhite,
            $background = @{
                color    = ([RgbColor]$InputObject.Background).ToHunterLab()
                distance = 360
                closest  = $null
                bright   = $false
            }
            $foreground = @{
                color    = ([RgbColor]$InputObject.Foreground).ToHunterLab()
                distance = 360
                closest  = $null
                bright   = $false
            }

            foreach ($color in "black", "red", "green", "yellow", "blue", "purple", "cyan", "white") {
                $brightColor = "bright$color"
                $Dark  = ([RgbColor]$InputObject.$color).ToHunterLab()
                $Light = ([RgbColor]$InputObject.$brightColor).ToHunterLab()

                if (($distance = $background.color.Compare($Dark, $comparer)) -lt $background.distance) {
                    $background.distance = $distance
                    $background.closest = $Dark
                    $background.bright = $false
                }
                if (($distance = $background.color.Compare($Light, $comparer)) -lt $background.distance) {
                    $background.distance = $distance
                    $background.closest = $Light
                    $background.bright = $true
                }
                if (($distance = $foreground.color.Compare($Dark, $comparer)) -lt $foreground.distance) {
                    $foreground.distance = $distance
                    $foreground.closest = $Dark
                    $foreground.bright = $false
                }
                if (($distance = $foreground.color.Compare($Light, $comparer)) -lt $foreground.distance) {
                    $foreground.distance = $distance
                    $foreground.closest = $Light
                    $foreground.bright = $true
                }

                if ($BrightShift) {
                    if (100 -ge ($Light.L + $BrightShift)) {
                        $Light.L += $BrightShift
                    } else {
                        $Light.L = 100
                    }
                }

                if ($DarkShift) {
                    if (0 -le ($Dark.L - $DarkShift)) {
                        $Dark.L -= $DarkShift
                    } else {
                        $Dark.L = 0
                    }
                }

                $InputObject.$color = [RgbColor]$Dark.ToRgb()
                $InputObject.$brightColor = [RgbColor]$Light.ToRgb()
            }

            if ($BrightShift) {
                if ($background.bright) {
                    $background.Color.L += $BrightShift
                    $InputObject.Background = [RgbColor]$background.Color.ToRgb()
                }
                if ($foreground.bright) {
                    $foreground.Color.L += $BrightShift
                    $InputObject.Foreground = [RgbColor]$foreground.Color.ToRgb()
                }
            }

            if ($DarkShift) {
                if (!$background.bright) {
                    $background.Color.L -= $DarkShift
                    $InputObject.Background = [RgbColor]$background.Color.ToRgb()
                }
                if (!$foreground.bright) {
                    $foreground.Color.L -= $DarkShift
                    $InputObject.Foreground = [RgbColor]$foreground.Color.ToRgb()
                }
            }

            $InputObject
        }
    }
}