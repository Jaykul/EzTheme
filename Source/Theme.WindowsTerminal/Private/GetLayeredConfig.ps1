function GetLayeredConfig {
    [CmdletBinding()]
    param(
        # If set, update the profiles with values from profiles.defaults
        [switch]$FlattenDefaultProfile
    )

    # Hypothetically the file is in the first location, but if you're using a dev copy instead, it might be elsewhere:
    if (!$script:UserConfigFile -or !$script:DefaultConfig) {
        $wt = @(Get-Process WindowsTerminal -ErrorAction Ignore)
        if ($wt.count -eq 1) {
            $wtExecutable = $wt.Path
        } else {
            $ps = Get-Process -Id $Pid
            while ($ps.ProcessName -ne "WindowsTerminal" -and $ps.Parent) {
                $ps = $ps.Parent
            }
            if ($ps.ProcessName -eq "WindowsTerminal") {
                $wtExecutable = $ps.Path
            }
        }

        if ($wtExecutable) {
            $DefaultConfigFile = Get-ChildItem ($wtExecutable | Split-Path) -Filter defaults.json | Convert-Path

            if (!$DefaultConfigFile) {
                Write-Warning "Unable to locate Windows Terminal's default.json"
            } else {
                $script:DefaultConfig = if ($PSVersionTable.PSVersion.Major -gt 5) {
                    ConvertFrom-Json (Get-Content $DefaultConfigFile -Raw)
                } else {
                    # WindowsPowerShell's JSON can't handle comments
                    ConvertFrom-Json (((Get-Content $DefaultConfigFile) -replace "^\s*//.*") -join "`n")
                }
            }
        }

        $ProductKey = switch -regex ($wtExecutable) {
            "Microsoft\.WindowsTerminalPreview_" { "Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe" }
            "WindowsTerminalDev" { "WindowsTerminalDev_8wekyb3d8bbwe" }
            # "Microsoft\.WindowsTerminal_" { "Microsoft.WindowsTerminal_8wekyb3d8bbwe" }
            default { "Microsoft.WindowsTerminal_8wekyb3d8bbwe" }
        }

        $script:UserConfigFile = Get-ChildItem @(
            "$Env:LocalAppData/packages/$ProductKey/LocalState/settings.json"
            "$Env:AppData/Microsoft/Windows Terminal/settings.json"
        ) -ErrorAction Ignore | Select-Object -First 1
    }

    if (!$UserConfigFile) {
        Write-Warning "Unable to locate Windows Terminal's settings.json"
    } else {
        $UserConfig = if ($PSVersionTable.PSVersion.Major -gt 5) {
                ConvertFrom-Json (Get-Content $UserConfigFile -Raw)
            } else { # WindowsPowerShell's JSON can't handle comments
                ConvertFrom-Json (((Get-Content $UserConfigFile) -replace "^\s*//.*") -join "`n")
            }
    }

    # The profiles are different in default, so we normalize that first ...
    # The only way to normalize it is to add the `default`:
    if (!(Get-Member Defaults -Input $UserConfig.Profiles)) {
        $UserConfig.profiles = [PSCustomObject]@{
            defaults = [PSCustomObject]@{ }
            list     = $UserConfig.profiles
        }
    }
    if (!(Get-Member Defaults -input $DefaultConfig.Profiles)) {
        $DefaultConfig.profiles = [PSCustomObject]@{
            defaults = [PSCustomObject]@{ }
            list     = $DefaultConfig.profiles
        }
    }

    # Update-Object doesn't handle arrays at all, so we need to deal with those manually
    for ($u = 0; $u -lt $UserConfig.profiles.list.Count; $u++) {
        if (($d = $DefaultConfig.profiles.list.guid.IndexOf($UserConfig.profiles.list[$u].guid)) -ge 0) {
            # Which is fine, because maybe we need to start with the default profile
            if ($FlattenDefaultProfile -and $UserConfig.profiles.defaults) {
                $UserConfig.profiles.list[$u] = $DefaultConfig.profiles.list[$d] |
                    Update-Object ($UserConfig.profiles.defaults | Select-Object *) |
                    Update-Object $UserConfig.profiles.list[$u]
            } else {
                $UserConfig.profiles.list[$u] = $DefaultConfig.profiles.list[$d] |
                    Update-Object $UserConfig.profiles.list[$u]
            }
        } elseif ($FlattenDefaultProfile -and $UserConfig.profiles.defaults) {
            $UserConfig.profiles.list[$u] = $UserConfig.profiles.defaults | Select-Object * |
                    Update-Object $UserConfig.profiles.list[$u]
        }
    }
    for ($u = 0; $u -lt $UserConfig.schemes.Count; $u++) {
        if (($d = $DefaultConfig.schemes.name.IndexOf($UserConfig.schemes[$u].name)) -ge 0) {
            $UserConfig.schemes[$u] = $DefaultConfig.schemes[$d] | Update-Object $UserConfig.schemes[$u]
        }
    }
    # Let's be honest, schemes that are in the default probably aren't in UserConfig, so copy them:
    $existing = $UserConfig.schemes.name
    $UserConfig.schemes += @($DefaultConfig.schemes).where{$_.name -notin $existing}

    # Finally, copy over everything else
    Update-Object -InputObject ($DefaultConfig | Select-Object *) -UpdateObject $UserConfig
}