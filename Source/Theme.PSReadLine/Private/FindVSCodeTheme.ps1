function FindVsCodeTheme {
    [CmdletBinding(DefaultParameterSetName = "Specific")]
    param(
        [Parameter(ParameterSetName = "List")]
        [Parameter(ParameterSetName = "Specific", Mandatory, Position = 0)]
        [string]$Name,

        [Parameter(ParameterSetName = "List", Mandatory)]
        [switch]$List,

        [ValidateSet("dark", "light", "highcontrast")]
        [string[]]$Style
    )

    $VSCodeExtensions = @(
        # VS Code themes are in one of two places: in the app, or in your profile folder:
        Convert-Path "~\.vscode*\extensions\"
        # If `code` is in your path, we can guess where that is...
        Get-Command Code-Insiders, Code -ErrorAction Ignore |
            Split-Path | Split-Path | Join-Path -ChildPath "resources\app\extensions\"
    )
    $Warnings = @()

    $Themes = @(
        # If they passed a file path that exists, use just that one file
        if (-not $List -and ($Specific = Test-Path -LiteralPath $Name)) {
            $File = Convert-Path $Name
            $(
                if ($File.EndsWith(".json")) {
                    try {
                        # Write-Debug "Parsing json file: $File"
                        ConvertFrom-Json (Get-Content -Path $File -Raw -Encoding utf8) -ErrorAction SilentlyContinue
                    } catch {
                        Write-Error "Couldn't parse '$File'. $(
                        if($PSVersionTable.PSVersion.Major -lt 6) {
                            'You could try again with PowerShell Core, the JSON parser there works much better!'
                        })"
                    }
                } else {
                    # Write-Debug "Parsing PList file: $File"
                    Import-PList -Path $File
                }
            ) | Select-Object @{ Name = "Name"
                Expr                  = {
                    if ($_.name) {
                        $_.name
                    } else {
                        [IO.Path]::GetFileNameWithoutExtension($File)
                    }
                }
            }, @{ Name = "Path"
                Expr   = { $File }
            }
        } else {
            $VSCodeExtensions = $VSCodeExtensions | Join-Path -ChildPath "\*\package.json" -Resolve
            foreach ($File in $VSCodeExtensions) {
                # Write-Debug "Considering VSCode Extension $([IO.Path]::GetFileName([IO.Path]::GetDirectoryName($File)))"
                $JSON = Get-Content -Path $File -Raw -Encoding utf8
                try {
                    $Extension = ConvertFrom-Json $JSON -ErrorAction Stop
                    # if ($Extension.contributes.themes) {
                    #     Write-Debug "Found $($Extension.contributes.themes.Count) themes"
                    # }
                    $Extension.contributes.themes |
                        Select-Object @{Name = "Name" ; Expr = { if ($_.id) { $_.id } else { $_.label } } },
                        @{Name = "Style"; Expr = { $_.uiTheme } },
                        @{Name = "Path" ; Expr = { Join-Path (Split-Path $File) $_.path -Resolve } }
                } catch {
                    $Warning = "Couldn't parse some VSCode extensions."
                }
            }
        }
    )

    if ($Themes.Count -eq 0) {
        throw "Could not find any VSCode themes. Please use a full path."
    }

    if ($Specific -and $Themes.Count -eq 1) {
        $Themes
    }
    if ($Style) {
        if ($Style -contains "light") {
            $Themes = $Themes.Where{ $_.Style -notmatch "dark|black" }
        } elseif ($Style -contains "dark") {
            $Themes = $Themes.Where{ $_.Style -match "dark|black" }
        }
        if ($Style -contains "highcontrast") {
            $Themes = $Themes.Where{ $_.Style -match "^hc" }
        }
        if ($Themes.Count -eq 0) {
            throw "Couldn't find any themes with the style '$($Style -join '|')'. Try again without -Style."
        }
    }

    $Themes = $Themes | Sort-Object Name

    if ($List) {
        Write-Verbose "Found $($Themes.Count) Themes"
        $Themes
        return
    }

    # Make sure we're comparing the name to a name
    $Name = [IO.Path]::GetFileName(($Name -replace "\.json$|\.tmtheme$"))
    Write-Debug "Testing theme names for '$Name'"

    # increasingly fuzzy search: (eq -> like -> match)
    if (!($Theme = $Themes.Where{ $_.name -eq $Name })) {
        if (!($Theme = $Themes.Where{ $_.name -like $Name })) {
            if (!($Theme = $Themes.Where{ $_.name -like "*$Name*" })) {
                foreach ($Warning in $Warnings) {
                    Write-Warning $Warning
                }
                Write-Error "Couldn't find the theme '$Name', please try another: $(($Themes.name | Select-Object -Unique) -join ', ')"
            }
        }
    }
    if (@($Theme).Count -gt 1) {
        $Dupes = $(if (@($Theme.Name | Sort-Object -Unique).Count -gt 1) { $Theme.Name } else { $Theme.Path }) -join ", "
        Write-Warning "Found more than one theme for '$Name'. Using '$(@($Theme)[0].Path)', but you could try again for one of: $Dupes)"
    }

    @($Theme)[0]
}
