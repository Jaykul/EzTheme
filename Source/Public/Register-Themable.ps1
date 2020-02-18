function Register-Themable {
    <#
        .Synopsis
            Register a themable module.

        .Description
            Registers a themable module. Themable modules implement `Set` and `Get` commands for the `ModuleNameTheme` noun.

        .Example
            Register-Themeable PSReadlineTheme

            Registers the PSReadLineTheme module which must have the commands:
            - Get-PSReadlineTheme
            - Set-PSReadlineTheme
    #>
    [CmdletBinding()]
    param(
        # The name of the module you want to register as themable
        [Alias("Name")]
        $ModuleName
    )
    $Noun = ($ModuleName -replace "^Theme\.?|\.?Theme$") + "Theme"

    $null = Get-Command "Set-$Noun", "Get-$Noun" -Module $ModuleName -ErrorAction SilentlyContinue -ErrorVariable cnf

    # If we found no commands, it might have been a module problem ...
    if ($cnf.Count -eq 2 -and -not (Get-Module $ModuleName)) {
        # Let's try importing the module explicitly and try again
        Import-Module $ModuleName -Scope Global
        $null = Get-Command "Set-$Noun", "Get-$Noun" -Module $ModuleName -ErrorAction SilentlyContinue -ErrorVariable cnf
    }

    if ($cnf) {
        Write-Error "Unable to register $ModuleName. '$($cfn.TargetObject -join "', '")' not found" -ErrorAction Stop
    }

    $Configuration = Import-Configuration
    $Configuration.Modules = $Configuration.Modules + $ModuleName | Sort-Object -Unique
    $Configuration | Export-Configuration
}