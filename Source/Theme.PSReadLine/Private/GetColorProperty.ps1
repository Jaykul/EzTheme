function GetColorProperty{
    <#
        .SYNOPSIS
            Search the colors for a matching theme color name and returns the foreground
    #>
    param(
        # The array of colors
        [Array]$colors,

        # An array of (partial) scope names in priority order
        # The foreground color of the first matching scope in the tokens will be returned
        [string[]]$name,

        [switch]$background
    )
    # Since we loaded the themes in order of prescedence, we take the first match that has a foreground color
    foreach ($pattern in $name) {
        if ($foreground = @($colors.$pattern).Where{ $_ }[0]) {
            if ($pattern -match "Background(Color)?") {
                $background = $true
            }
            ConvertToCssColor $foreground -Background:$background
            return
        }
        if ($key, $property = $pattern -split "\.") {
            if ($foreground = @($colors.$key.$property).Where{ $_ }[0]) {
                if ($property -match "Background(Color)?") {
                    $background = $true
                }
                ConvertToCssColor $foreground -Background:$background
                return
            }
        }
        # Normalize color
    }
}
