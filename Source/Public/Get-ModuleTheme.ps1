function Get-ModuleTheme {
    <#
        .Synopsis
            Get's the current theme information for a specific module
        .Description

        .Example
            Get-ModuleTheme | Set-MyModuleTheme

            This is how you should call it from the bottom of your MyModule module
        .Example
            Get-ModuleTheme MyModule | Set-MyModuleTheme

            You can set the theme
    #>
    [CmdletBinding(DefaultParameterSetName = '__CallStack')]
    param(
        # The Module you want to fetch theme data for
        [Parameter(ParameterSetName = "__ModuleInfo", ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.PSModuleInfo]$Module,

        # The callstack. You should not ever pass this.
        # It is used to calculate the defaults for all the other parameters.
        [Parameter(ParameterSetName = "__CallStack")]
        [System.Management.Automation.CallStackFrame[]]${_ _ CallStack} = $(Get-PSCallStack)
    )
    if (!$Module) {
        [System.Management.Automation.PSModuleInfo]$Module = . {
            $Command = (${_ _ CallStack})[0].InvocationInfo.MyCommand
            $mi = if ($Command.ScriptBlock -and $Command.ScriptBlock.Module) {
                $Command.ScriptBlock.Module
            } else {
                $Command.Module
            }

            if ($mi -and $mi.ExportedCommands.Count -eq 0) {
                if ($mi2 = Get-Module $mi.ModuleBase -ListAvailable | Where-Object { ($_.Name -eq $mi.Name) -and $_.ExportedCommands } | Select-Object -First 1) {
                    $mi = $mi2
                }
            }
            $mi
        }
    }

    if ($Module.Name) {
        $MyInvocation.MyCommand.Module.PrivateData["Theme"][$Module.Name]
    }
}