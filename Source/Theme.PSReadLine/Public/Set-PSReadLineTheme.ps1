function Set-PSReadLineTheme {
    <#
        .SYNOPSIS
            Set the theme for PSReadLine
            Has parameters for each thing that's themeable
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $CommandColor            = "`e[93m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $CommentColor            = "`e[32m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $ContinuationPromptColor = "`e[97m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $DefaultTokenColor       = "`e[97m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $EmphasisColor           = "`e[96m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $ErrorColor              = "`e[91m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $KeywordColor            = "`e[92m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $MemberColor             = "`e[97m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $NumberColor             = "`e[97m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $OperatorColor           = "`e[90m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $ParameterColor          = "`e[90m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $SelectionColor          = "`e[30;107m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $StringColor             = "`e[36m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $TypeColor               = "`e[37m",
        [Parameter(ValueFromPipelineByPropertyName)]
        $VariableColor           = "`e[92m"
    )
    process {
        $ParameterNames = $MyInvocation.MyCommand.Parameters.Keys.Where{
             $_ -notin [System.Management.Automation.PSCmdlet]::CommonParameters
        }

        $Colors = @{}
        foreach ($ParameterName in $ParameterNames) {
            if (($Value = Get-Variable -Scope Local -Name $ParameterName -ValueOnly)) {
                $Colors[($ParameterName -replace "(token)?color")] = $Value
            }
        }

        Set-PSReadLineOption -Colors $Colors
    }
}