function Set-PSReadLineTheme {
    <#
        .SYNOPSIS
            Set the theme for PSReadLine
            Has parameters for each thing that's themeable
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $CommandColor            = "$([char]27)[93m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $CommentColor            = "$([char]27)[32m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $ContinuationPromptColor = "$([char]27)[97m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $DefaultTokenColor       = "$([char]27)[97m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $EmphasisColor           = "$([char]27)[96m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $ErrorColor              = "$([char]27)[91m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $KeywordColor            = "$([char]27)[92m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $MemberColor             = "$([char]27)[97m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $NumberColor             = "$([char]27)[97m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $OperatorColor           = "$([char]27)[90m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $ParameterColor          = "$([char]27)[90m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $PredictionColor         = "$([char]27)[90m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $SelectionColor          = "$([char]27)[30;107m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $StringColor             = "$([char]27)[36m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $TypeColor               = "$([char]27)[37m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $VariableColor           = "$([char]27)[92m"
    )
    process {
        $ParameterNames = $MyInvocation.MyCommand.Parameters.Keys.Where{
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
        #$global:PsReadlineColors = $Colors
        Set-PSReadLineOption -Colors $Colors
    }
}