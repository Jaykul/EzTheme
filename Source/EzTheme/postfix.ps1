function InitializeTheme {
    [CmdletBinding()]
    param()
    if (($script:Configuration = Import-Configuration).Theme) {
        Import-Theme $Configuration.Theme
    }
}

# InitializeTheme