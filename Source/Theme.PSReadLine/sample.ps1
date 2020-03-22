
Update-FormatData

$PSRLO = Get-PSReadLineOption
$e = "`e"
$(
"$($PSRLO.KeywordColor)function $($PSRLO.DefaultTokenColor)Test-Syntax $($PSRLO.DefaultTokenColor){"
"    $($PSRLO.CommentColor)# Demo Syntax Highlighting"
"    $($PSRLO.DefaultTokenColor)[$($PSRLO.TypeColor)CmdletBinding$($PSRLO.DefaultTokenColor)()]"
"    $($PSRLO.KeywordColor)param$($PSRLO.DefaultTokenColor)( [$($PSRLO.TypeColor)IO.FileInfo$($PSRLO.DefaultTokenColor)]$($PSRLO.VariableColor)`$Path $($PSRLO.DefaultTokenColor))"
""
"    $($PSRLO.CommandColor)Write-Verbose $($PSRLO.StringColor)`"Testing in $($PSRLO.VariableColor)`$($($PSRLO.CommandColor)Split-Path $($PSRLO.VariableColor)`$PSScriptRoot $($PSRLO.ParameterColor)-Leaf$($PSRLO.VariableColor))$($PSRLO.StringColor)`" $($PSRLO.ParameterColor)-Verbose"
"    $($PSRLO.VariableColor)`$Env:PSModulePath $($PSRLO.OperatorColor)-split $($PSRLO.StringColor)';' $($PSRLO.OperatorColor)-notcontains $($PSRLO.VariableColor)`$Path$($PSRLO.DefaultTokenColor).$($PSRLO.MemberColor)FullName"
"$($PSRLO.DefaultTokenColor)}$e[39m"
)