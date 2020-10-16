class ThemeId : IPathInfo {
    [string]$Name
    [string]$Path

    ThemeId ([string]$Path) {
        $this.Path = Convert-Path $Path
        $this.Name = [IO.Path]::GetFileName($this.Path) -replace "\.theme\.psd1$"
    }

    [string]ToString() {
        return $this.Name
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