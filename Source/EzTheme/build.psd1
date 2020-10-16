# Use this file to override the default parameter values used by the `Build-Module`
# command when building the module (see `Get-Help Build-Module -Full` for details).
@{
    ModuleManifest           = "EzTheme.psd1"
    VersionedOutputDirectory = $false
    CopyDirectories          = @('Themes', "Interfaces.ps1")
    Postfix                  = "postfix.ps1"
}
