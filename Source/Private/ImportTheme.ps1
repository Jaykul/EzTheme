function ImportTheme {
    <#
        .SYNOPSIS
            Imports themes by name
    #>
    [CmdletBinding()]
    param(
        # The name of the theme
        [Parameter(Position=0)]
        [string]$Name
    )

    $FileName = $Name -replace "((\.theme)?\.psd1)?$" -replace '$', ".theme.psd1"

    $Path = if (!(Test-Path -LiteralPath $FileName)) {
        Get-Theme $Name | Select-Object -First 1 -ExpandProperty PSPath
    } else {
        Convert-Path $FileName
    }
    if(!$Path) {
        $Themes = @(Get-Theme "$Name*")
        if($Themes.Count -gt 1) {
            Write-Warning "No exact match for $Name. Using $($Themes[0]), but also found $($Themes[1..$($Themes.Count-1)] -join ', ')"
            $Path = $Themes[0].PSPath
        } elseif($Themes) {
            Write-Warning "No exact match for $Name. Using $($Themes[0])"
            $Path = $Themes[0].PSPath
        } else {
            $Themes = @(Get-Theme "*$Name*")
            if($Themes.Count -gt 1) {
                Write-Warning "No exact match for $Name. Using $($Themes[0]), but also found $($Themes[1..$($Themes.Count-1)] -join ', ')"
                $Path = $Themes[0].PSPath
            } elseif($Themes) {
                Write-Warning "No exact match for $Name. Using $($Themes[0])"
                $Path = $Themes[0].PSPath
            }
        }
        if(!$Path) {
            Write-Error "No theme '$Name' found. Try Get-Theme to see available themes."
            return
        }
    }

    Write-Verbose "Importing $Name theme from $Path"
    Import-Metadata $Path -ErrorAction Stop
}