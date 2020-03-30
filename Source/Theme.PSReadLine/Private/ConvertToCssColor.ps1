using namespace System.Collections.Generic

function ConvertToCssColor {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName="PListColorDictionary", Mandatory, Position = 0)]
        [Dictionary[string,object]]$colors,

        [Parameter(ParameterSetName="ColorValue", Mandatory, Position = 0)]
        [string]$color,

        [switch]$Background
    )
    end {
        if ($PSCmdlet.ParameterSetName -eq "PListColorDictionary") {
            [int]$r = 255 * $colors["Red Component"]
            [int]$g = 255 * $colors["Green Component"]
            [int]$b = 255 * $colors["Blue Component"]
            [PoshCode.Pansies.RgbColor]::new($r, $g, $b).ToVtEscapeSequence($Background)
        }
        if ($PSCmdlet.ParameterSetName -eq "ColorValue") {
            [PoshCode.Pansies.RgbColor]::new($color).ToVtEscapeSequence($Background)
        }
    }
}