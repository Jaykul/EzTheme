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
            Get = 'Get-TerminalTheme'
            Set = 'Set-TerminalTheme'
        }
    } # End of PrivateData hashtable

    Description          = 'Theme module for VT Terminal'
    FunctionsToExport    = @()
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    FormatsToProcess     = @('Terminal.format.ps1xml')
    RequiredModules      = @("Pansies")

    # Script module or binary module file associated with this manifest.
    RootModule           = 'Theme.Terminal.psm1'
    GUID                 = 'fa577939-3799-4a07-b6f3-5173bc711c25'
    Author               = "Joel 'Jaykul' Bennett"
    CompanyName          = 'PoshCode.org'
    Copyright            = '(c) Joel Bennett 2020. All rights reserved.'
    CompatiblePSEditions = @('Desktop', 'Core')

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # HelpInfoURI = ''
}

