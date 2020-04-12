function Get-PSReadLineTheme {
    <#
        .SYNOPSIS
            Returns a hashtable of the _current_ values that can be splatted to Set-Theme
    #>
    [CmdletBinding()]
    param()
    Get-PSReadLineOption | Select-Object *Color
}