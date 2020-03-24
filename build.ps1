#requires -Module ModuleBuilder
[CmdletBinding()]
param(
    # A specific folder to build into
    $OutputDirectory,

    # The version of the output module
    [Alias("ModuleVersion")]
    [string]$SemVer
)
# Sanitize parameters to pass to Build-Module
$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot -StackName BuildModuleScript

if (-not $Semver -and (Get-Command gitversion)) {
    if ($semver = gitversion -showvariable SemVer) {
        $null = $PSBoundParameters.Add("SemVer", $SemVer)
    }
}

try {
    # Build new output
    $ParameterString = $PSBoundParameters.GetEnumerator().ForEach{ '-' + $_.Key + " '" + $_.Value + "'" } -join " "
    Write-Host "Build-Module Source\build.psd1 $($ParameterString) -Target CleanBuild" -ForegroundColor Cyan
    Build-Module .\Source\build.psd1 @PSBoundParameters -Target CleanBuild -Passthru -OutVariable BuildOutput | Split-Path
    Write-Verbose "Module build output in $(Split-Path $BuildOutput.Path)"

    # We have a bunch of submodules:
    $SubModules = foreach ($SubModule in Get-ChildItem Source -Directory | Where-Object Name -Match "Theme\.") {
        $ThemeOutput = Join-Path (Split-Path $BuildOutput.Path) $SubModule.Name
        Write-Host " - Build $($SubModule.Name)" -ForegroundColor Cyan
        Build-Module ".\Source\$($SubModule.Name)\build.psd1" @PSBoundParameters -Target CleanBuild -OutputDirectory $ThemeOutput
        $SubModule.Name
    }
    <#
    Update-Metadata -Path $BuildOutput.Path -PropertyName NestedModules -Value $SubModules
    #>
} finally {
    Pop-Location -StackName BuildModuleScript
}
