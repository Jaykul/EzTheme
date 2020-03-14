@{
    # Version number of this module.
    ModuleVersion        = '0.0.1'
    PrivateData          = @{
        PSData = @{
            # The prerelease portion of a semantic version. Blank for releases
            Prerelease   = ''
            ReleaseNotes = ''

            Tags         = @('Theme', 'Scheme', 'Colors', 'Theme.Everything')

            # LicenseUri = ''
            # ProjectUri = ''
            # IconUri = ''

            # Modules that aren't in the same PowerShellGallery
            # ExternalModuleDependencies = @()
        } # End of PSData hashtable
        'Theme.Everything' = @{
            Get = 'Get-PowerShellTheme'
            Set = 'Set-PowerShellTheme'
        }
    } # End of PrivateData hashtable

    Description          = 'Theme module for PowerShell PrivateData+ConsoleColors'
    FunctionsToExport    = @()
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    FormatsToProcess     = @('PowerShell.format.ps1xml')
    RequiredModules      = @("Pansies")

    # Script module or binary module file associated with this manifest.
    RootModule           = 'Theme.PowerShell.psm1'
    GUID                 = '402dd612-fa1b-46a9-b22f-2ab5d803714f'
    Author               = "Joel 'Jaykul' Bennett"
    CompanyName          = 'PoshCode.org'
    Copyright            = '(c) Joel Bennett 2020. All rights reserved.'
    CompatiblePSEditions = @('Desktop', 'Core')

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # HelpInfoURI = ''
}

