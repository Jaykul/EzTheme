$SelectedThemes = @(
    $Matches = (Invoke-RestMethod https://iterm2colorschemes.com/ | Select-String "(?<=schemes/)(?<name>[^/]*)(?=\.itermcolors)").Matches
    do {
    $Matches.value -replace "%20", " "
    } while (($Matches = $Matches.NextMatch()).Length)
)


$path = "$Env:LocalAppData/packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/profiles.json"
$Conf = Get-Content $path | ConvertFrom-Json
$Conf.schemes += Invoke-RestMethod https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/windowsterminal/$Theme.json
$Conf | ConvertTo-json -Depth 10 | Set-Content $path


$Profile = Get-ChildItem @(
    "$Env:LocalAppData/packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/profiles.json"
    "$Env:LocalAppData/packages/WindowsTerminalDev_8wekyb3d8bbwe/LocalState/profiles.json"
    "$Env:AppData/Microsoft/Windows Terminal/profiles.json"
) -ErrorAction Ignore | Select-Object -First 1

$Config = Get-Content $Profile | ConvertFrom-Json
$Config.schemes += Invoke-RestMethod https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/windowsterminal/DimmedMonokai.json
$Config | ConvertTo-json -Depth 10 | Set-Content $profile