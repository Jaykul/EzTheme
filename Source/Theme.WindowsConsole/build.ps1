Push-Location $PSScriptRoot\Assembly

dotnet build -c Release -o $PSScriptRoot\lib
Get-ChildItem $PSScriptRoot\lib -Exclude Theme.WindowsConsole.dll |
    Remove-Item

Pop-Location