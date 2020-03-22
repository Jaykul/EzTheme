function GetSimpleConfig {
    [CmdletBinding()]
    param()

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
        Write-Verbose $UserConfigFile
        $UserConfig = ConvertFrom-Json (Get-Content $UserConfigFile -Raw)
    }

    # The profiles exist two different ways, so we have to normalize that first ...
    # The only way to normalize it is to add the `default`:
    if (!(Get-Member Defaults -Input $UserConfig.Profiles)) {
        $UserConfig.profiles = [PSCustomObject]@{
            default = [PSCustomObject]@{}
            list    = $UserConfig.profiles
        }
    }

    $UserConfig
}