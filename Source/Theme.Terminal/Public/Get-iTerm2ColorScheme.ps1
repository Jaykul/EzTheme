function Get-iTerm2ColorScheme {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Name
    )
    process {
        $Name = [System.Text.Encodings.Web.UrlEncoder]::Default.Encode($Name) + ".json"
        $ColorScheme = Invoke-RestMethod https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/windowsterminal/$Name

        $ColorScheme.PSTypeNames.Insert(0, "Terminal.ColorScheme")
        $ColorScheme
    }
}