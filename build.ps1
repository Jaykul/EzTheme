#requires -Module ModuleBuilder
[CmdletBinding(SupportsShouldProcess)]
param(
    # A specific folder to build into
    $OutputDirectory = "Output",

    # The version of the output module
    [Alias("ModuleVersion")]
    [string]$SemVer
)
# Sanitize parameters to pass to Build-Module
$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot -StackName BuildModuleScript
$OutputDirectory = Join-Path $Pwd $OutputDirectory

if (-not $Semver -and (Get-Command gitversion -ErrorAction Ignore)) {
    if ($semver = gitversion -showvariable SemVer) {
        $null = $PSBoundParameters.Add("SemVer", $SemVer)
    }
}

try {
    # Call any nested build.ps1 scripts (I have one binary module in here)
    foreach ($BuildScript in Get-ChildItem Source -Recurse -File -Filter build.ps1) {
        Write-Host $BuildScript -ForegroundColor Yellow
        & $BuildScript
    }

    # We have a bunch of submodules:
    foreach ($Module in Get-ChildItem Source -Directory) {
        $ThemeOutput = Join-Path $OutputDirectory $Module.Name
        Write-Host " - Build $($Module.Name)" -ForegroundColor Cyan
        Build-Module ".\Source\$($Module.Name)\build.psd1" @PSBoundParameters -Target CleanBuild -OutputDirectory $ThemeOutput
    }
} finally {
    Pop-Location -StackName BuildModuleScript
}
