function GetLayeredConfig {
    [CmdletBinding()]
    param(
        # If set, update the profiles with values from profiles.defaults
        [switch]$FlattenDefaultProfile
    )

    # Hypothetically the file is in the first location, but if you're using a dev copy instead, it might be elsewhere:
    if (!$script:UserConfigFile) {
        $script:UserConfigFile = Get-ChildItem @(
            "$Env:LocalAppData/packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/profiles.json"
            "$Env:LocalAppData/packages/WindowsTerminalDev_8wekyb3d8bbwe/LocalState/profiles.json"
            "$Env:AppData/Microsoft/Windows Terminal/profiles.json"
            ) -ErrorAction Ignore | Select-Object -First 1
    }

    if (!$UserConfigFile) {
        Write-Warning "Unable to locate Windows Terminal's profiles.json"
    } else {
        $UserConfig = ConvertFrom-Json (Get-Content $UserConfigFile -Raw)
    }

    if (!$script:DefaultConfig) {
        if (($wtExecutable = (Get-Process WindowsTerminal -ErrorAction Ignore).Path)) {
            $DefaultConfigFile = Get-ChildItem ($wtExecutable | Split-Path) -Filter defaults.json
        }

        if (!$DefaultConfigFile) {
            Write-Warning "Unable to locate Windows Terminal's default.json"
        } else {
            $script:DefaultConfig = ConvertFrom-Json (Get-Content $DefaultConfigFile -Raw)
        }
    }

    # The profiles exist two different ways, so we have to normalize that first ...
    # The only way to normalize it is to add the `default`:
    if (!(Get-Member Defaults -Input $UserConfig.Profiles)) {
        $UserConfig.profiles = [PSCustomObject]@{
            default = [PSCustomObject]@{}
            list    = $UserConfig.profiles
        }
    }
    if (!(Get-Member Defaults -input $DefaultConfig.Profiles)) {
        $DefaultConfig.profiles = [PSCustomObject]@{
            default = [PSCustomObject]@{}
            list    = $DefaultConfig.profiles
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
    $UserConfig.schemes += $DefaultConfig.schemes.where{$_.name -notin $existing}

    # Finally, copy over everything else
    Update-Object -InputObject ($DefaultConfig | Select-Object *) -UpdateObject $UserConfig
}