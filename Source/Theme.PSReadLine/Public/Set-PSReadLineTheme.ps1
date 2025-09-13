function Set-PSReadLineTheme {
    <#
        .SYNOPSIS
            Set the theme for PSReadLine as escape sequences.
        .DESCRIPTION
            Set the theme for PSReadLine. Supports setting all the properties that are formatting related.
            Takes colors and other formatting options (bold, underline, etc.) as escape sequences.
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $CommandColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $CommentColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $ContinuationPromptColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $DefaultTokenColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $EmphasisColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $ErrorColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $KeywordColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $MemberColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $NumberColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $OperatorColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $ParameterColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $InlinePredictionColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $SelectionColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $StringColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $TypeColor,
        [Parameter(ValueFromPipelineByPropertyName)]
        $VariableColor
    )
    process {
        $ParameterNames = $PSBoundParameters.Keys.Where{
            $_ -notin [System.Management.Automation.PSCmdlet]::CommonParameters
        }

        $Colors = @{}
        foreach ($ParameterName in $ParameterNames) {
            if (($Value = Get-Variable -Scope Local -Name $ParameterName -ValueOnly)) {
                $ColorName = $ParameterName -replace "(token)?color"
                # This is only working when I use the AsEscapeSequence, but the input values are already escape sequences!
                $Colors[$ColorName] = [Microsoft.PowerShell.VTColorUtils]::AsEscapeSequence( $Value )
            }
        }
        Set-PSReadLineOption -Colors $Colors
    }
}