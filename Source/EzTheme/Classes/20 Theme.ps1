using module @{ModuleName = "Configuration";    ModuleVersion = "1.4.0"}
using namespace System.Collections.Generic

class Theme : ITheme, IPsMetadataSerializable {
    [string]$Name
    [string]$Path
    [Dictionary[string, PSObject]]$Settings = [Dictionary[string, PSObject]]::new()

    [System.Management.Automation.HiddenAttribute()]
    [void] LoadTheme() {
        $Theme = Import-Metadata $this.Path -ErrorAction Stop
        foreach ($key in $Theme.Keys) {
            $null = $this.Settings.Add($key, $Theme[$key])
        }
    }

    Theme ([string]$Path) {
        $this.Path = Convert-Path $Path
        $this.Name = [IO.Path]::GetFileName($this.Path) -replace "\.theme\.psd1$"
        $this.LoadTheme()
    }

    Theme ([ThemeId]$Path) {
        $this.Path = $Path.Path
        $this.Name = $Path.Name
        $this.LoadTheme()
    }

    [string[]] get_Modules() {
        return @($this.Settings.Keys)
    }
    [string[]] FindModules([string]$Module) {
        return $this.Settings.Keys.Where({
            ($_ -eq $Module) -or ($_ -like $Module) -or $_ -eq "Theme.$Module" -or $_ -eq "$Module.Theme"
        })
    }

    [object] get_Item([string]$Module) {
        if (!$this.Settings.ContainsKey($Module)) {
            [string[]]$Module = $this.Settings.Keys.Where({
                        ($_ -like $Module) -or $_ -eq "Theme.$Module" -or $_ -eq "$Module.Theme"
                      })
        }
        return $this.Settings[$Module]
    }

    [void] set_Item([string]$Module, [object]$Value) {
        $this.Settings[$Module] = $Value
    }

    [void] Remove([string]$ModuleName) {
        $this.Settings.Remove($ModuleName)
    }

    [string]ToString() {
        return $this.Name
    }

    # Serialization constructor
    Theme() {}

    [string]ToPsMetadata() {
        return ConvertTo-Metadata -InputObject @{
            Name = $this.Name
            Settings = $this.Settings
        }
    }
    [void] FromPsMetadata([string]$Metadata) {
        $Theme = ConvertFrom-Metadata -InputObject $Metadata
        $this.Name = $Theme.Name
        foreach ($key in $Theme.Setting.Keys) {
            $null = $this.Settings.Add($key, $Theme.Settings[$key])
        }
    }


    # Explicitly implement interface for PS5x
    [string] get_Name() {
        return $this.Name
    }
    [void] set_Name([string]$value) {
        $this.Name = $value
    }
    [string] get_Path() {
        return $this.Path
    }
    [void] set_Path([string]$value) {
        $this.Path = $value
    }
}

# Add-MetadataConverter @{ [Theme] = { "'$_'" } }