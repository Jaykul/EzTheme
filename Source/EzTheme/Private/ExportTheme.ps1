function ExportTheme {
    <#
        .SYNOPSIS
            Exports a theme to a file
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The name of the theme
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(ValueFromPipeline, Position = 1)]
        $InputObject,

        [switch]$Force,

        [switch]$PassThru
    )
    process {
        $Name = $Name -replace "((\.theme)?\.psd1)?$"
        $NativeThemePath = Join-Path $(Get-ConfigurationPath -Scope "User") "$Name.theme.psd1"

        if (Test-Path -LiteralPath $NativeThemePath) {
            if($Force -or $PSCmdlet.ShouldContinue("Overwrite $($NativeThemePath)?", "$Name Theme exists")) {
                Write-Verbose "Exporting to $NativeThemePath"
                $InputObject | Export-Metadata $NativeThemePath
            }
        } else {
            Write-Verbose "Exporting to $NativeThemePath"
            $InputObject | Export-Metadata $NativeThemePath
        }

        if($PassThru) {
            $InputObject | Add-Member NoteProperty Name $Name -Passthru |
                           Add-Member NoteProperty Path $NativeThemePath -Passthru
        }

        $Configuration = Import-Configuration
        $Configuration.Theme = $Name
        $Configuration | Export-Configuration
    }
}