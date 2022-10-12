using namespace PoshCode.Pansies

function Set-PSStyleTheme {
    <#
        .SYNOPSIS
            Set the PSStyle for PowerShell output
            Has parameters for all the current PSStyle options
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $OutputRendering,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Formatting.Debug")]
        $Formatting_Debug,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Formatting.Error")]
        $Formatting_Error,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Formatting.ErrorAccent")]
        $Formatting_ErrorAccent,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Formatting.FormatAccent")]
        $Formatting_FormatAccent,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Formatting.TableHeader")]
        $Formatting_TableHeader,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Formatting.Verbose")]
        $Formatting_Verbose,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Formatting.Warning")]
        $Formatting_Warning,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("FileInfo.Directory")]
        $FileInfo_Directory,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("FileInfo.Executable")]
        $FileInfo_Executable,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("FileInfo.Extension")]
        $FileInfo_Extension,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("FileInfo.SymbolicLink")]
        $FileInfo_SymbolicLink,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Progress.MaxWidth")]
        $Progress_MaxWidth,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Progress.Style")]
        $Progress_Style,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Progress.UseOSCIndicator")]
        $Progress_UseOSCIndicator,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Progress.View")]
        $Progress_View
    )
    process {
        if (!('System.Management.Automation.PSStyle' -as [type])) {
            Write-Warning '$PSStyle is not used by this version of PowerShell. These theme settings may not work as intended.'
        }
        if ($PSBoundParameters.ContainsKey("OutputRendering")) {
            $PSStyle.OutputRendering = $OutputRendering
        }

        if ($PSBoundParameters.ContainsKey("Formatting_FormatAccent")) {
            $PSStyle.Formatting.FormatAccent = $Formatting_FormatAccent
        }
        if ($PSBoundParameters.ContainsKey("Formatting_TableHeader")) {
            $PSStyle.Formatting.TableHeader = $Formatting_TableHeader
        }
        if ($PSBoundParameters.ContainsKey("Formatting_ErrorAccent")) {
            $PSStyle.Formatting.ErrorAccent = $Formatting_ErrorAccent
        }
        if ($PSBoundParameters.ContainsKey("Formatting_Error")) {
            $PSStyle.Formatting.Error = $Formatting_Error
        }
        if ($PSBoundParameters.ContainsKey("Formatting_Warning")) {
            $PSStyle.Formatting.Warning = $Formatting_Warning
        }
        if ($PSBoundParameters.ContainsKey("Formatting_Verbose")) {
            $PSStyle.Formatting.Verbose = $Formatting_Verbose
        }
        if ($PSBoundParameters.ContainsKey("Formatting_Debug")) {
            $PSStyle.Formatting.Debug = $Formatting_Debug
        }

        if ($PSBoundParameters.ContainsKey("Progress_Style")) {
            $PSStyle.Progress.Style = $Progress_Style
        }
        if ($PSBoundParameters.ContainsKey("Progress_MaxWidth")) {
            $PSStyle.Progress.MaxWidth = $Progress_MaxWidth
        }
        if ($PSBoundParameters.ContainsKey("Progress_View")) {
            $PSStyle.Progress.View = $Progress_View
        }
        if ($PSBoundParameters.ContainsKey("Progress_UseOSCIndicator")) {
            $PSStyle.Progress.UseOSCIndicator = $Progress_UseOSCIndicator
        }

        if ($PSBoundParameters.ContainsKey("FileInfo_Directory")) {
            $PSStyle.FileInfo.Directory = $FileInfo_Directory
        }
        if ($PSBoundParameters.ContainsKey("FileInfo_SymbolicLink")) {
            $PSStyle.FileInfo.SymbolicLink = $FileInfo_SymbolicLink
        }
        if ($PSBoundParameters.ContainsKey("FileInfo_Executable")) {
            $PSStyle.FileInfo.Executable = $FileInfo_Executable
        }
        if ($PSBoundParameters.ContainsKey("FileInfo_Extension")) {
            foreach($key in $FileInfo_Extension.Keys) {
                $PSStyle.FileInfo.Extension[$key] = $FileInfo_Extension[$key]
            }
        }

    }
}