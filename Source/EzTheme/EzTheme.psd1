@{
    # Version number of this module.
    ModuleVersion = '0.0.1'
    PrivateData      = @{
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
    } # End of PrivateData hashtable

    Description          = 'Theme Windows Terminal, PowerShell, PSReadLine, your prompt, and anything you like!'
    ScriptsToProcess     = @("Interfaces.ps1")
    FunctionsToExport    = @()
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    NestedModules        = @()
    RequiredModules      = @(
        @{ModuleName = "Theme.PowerShell"; ModuleVersion = "0.0.1" }
        @{ModuleName = "Theme.PSReadLine"; ModuleVersion = "0.0.1" }
        @{ModuleName = "Configuration";    ModuleVersion = "1.4.0"}
        @{ModuleName = "PANSIES";          ModuleVersion = "2.1.0"}
    )
    TypesToProcess       = @('EzTheme.types.ps1xml')
    FormatsToProcess     = @('EzTheme.format.ps1xml')

    # Script module or binary module file associated with this manifest.
    RootModule           = 'EzTheme.psm1'
    GUID                 = 'e1561aca-d9fe-4282-9f97-ba7899c8dfc1'
    Author               = "Joel 'Jaykul' Bennett"
    CompanyName          = 'PoshCode.org'
    Copyright            = '(c) Joel Bennett 2020. All rights reserved.'
    CompatiblePSEditions = @('Desktop', 'Core')

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '5.1'
}

