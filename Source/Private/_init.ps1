function InitializeTheme {
    [CmdletBinding()]
    param()
    if (!$Host.PrivateData.Theme -and  !$MyInvocation.MyCommand.Module.Theme) {
        if ($ThemeName = (Import-Configuration).Theme) {
            Import-Theme $ThemeName
        }
    }
}

InitializeTheme