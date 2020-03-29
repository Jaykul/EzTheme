function Show-Theme {
    <#
        .SYNOPSIS
            Import a theme and output the custom PSObjects
    #>
    [OutputType([string])]
    [CmdletBinding(DefaultParameterSetName="CurrentTheme")]
    param(
        # The name of the theme to export the current settings
        [Alias("Theme","PSPath")]
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter({Get-Theme})]
        [string]$Name,

        # One or more modules to export the theme from (ignores registered modules)
        [Parameter()]
        [Alias("Module")]
        [string[]]$IncludeModule
    )
    process {
        if(!$Name) {
            if (!$IncludeModule) {
                $IncludeModule = (Import-Configuration).Modules
            }

            foreach ($module in $IncludeModule) {
                $Noun = ($module -replace "^Theme\.?|\.?Theme$") + "Theme"
                Write-Host "`n$module theme:`n"
                & "$module\Get-$Noun"
            }

        } else {
            foreach($Theme in Get-Theme $Name) {
                $Theme = ImportTheme $Theme.PSPath | Add-Member -Type NoteProperty -Name Name -Value $Theme.Name -Passthru -Force
                foreach ($module in $Theme.Keys.Where({Get-Module $_})) {
                    Write-Host "`n$module theme:`n`n"
                    $Theme[$module] | Out-Default
                }
            }
        }
    }
}