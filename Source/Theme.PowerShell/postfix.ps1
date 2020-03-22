if (!($Theme = $Host.PrivateData.Theme)) {
    $Theme = (Get-Module 'Theme.Everything' -ErrorAction SilentlyContinue).PrivateData.Theme
}
if ($Theme = $Theme.'Theme.PowerShell') {
    $Theme | Set-PowerShellTheme
}