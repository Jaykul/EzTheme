@{
    # Version number of this module.
    ModuleVersion        = '0.0.1'
    PrivateData          = @{
        PSData = @{
            # The prerelease portion of a semantic version. Blank for releases
            Prerelease   = ''
            ReleaseNotes = ''

            Tags         = @('Theme', 'Scheme', 'Colors', 'EzTheme')

            # LicenseUri = ''
            # ProjectUri = ''
            # IconUri = ''

            # Modules that aren't in the same PowerShellGallery
            # ExternalModuleDependencies = @()
        } # End of PSData hashtable
        'EzTheme' = @{
            Get = 'Get-PSReadLineTheme'
            Set = 'Set-PSReadLineTheme'
        }
    } # End of PrivateData hashtable

    Description          = 'EzTheme wrapper for PSReadline'
    FunctionsToExport    = @()
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    FormatsToProcess     = @('PSReadLine.format.ps1xml')
    RequiredModules      = @(
        @{ModuleName = "PSReadLine"; ModuleVersion = "2.0.0" }
    )
    # Script module or binary module file associated with this manifest.
    RootModule           = 'Theme.PSReadline.psm1'
    GUID                 = 'cfb819a6-eaf6-49e3-98e3-10d6244634cf'
    Author               = "Joel 'Jaykul' Bennett"
    CompanyName          = 'PoshCode.org'
    Copyright            = '(c) Joel Bennett 2020. All rights reserved.'
    CompatiblePSEditions = @('Desktop', 'Core')

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '5.1'
}

