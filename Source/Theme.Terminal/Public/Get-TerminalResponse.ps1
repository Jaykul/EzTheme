function Get-TerminalResponse {
    <#
        .SYNOPSIS
            Write a VT ANSI escape sequence to the host and capture the response
        .EXAMPLE
            $Row, $Col = (Get-VtResponse "`e[6n") -split ';' -replace "[`e\[R]"
            Gets the current cursor position into $Row and $Col
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Sequence
    )
    [console]::write($sequence)
    @(while ([console]::KeyAvailable) {
            [console]::ReadKey($true).KeyChar
        }) -join ""
}