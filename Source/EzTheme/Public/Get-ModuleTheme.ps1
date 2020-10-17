using namespace System.Management.Automation
function Get-ModuleTheme {
    <#
        .Synopsis
            Get's the current theme information for a specific module
        .Description

        .Example
            Get-ModuleTheme | Set-MyModuleTheme

            This is how you should call it from the bottom of your MyModule module
        .Example
            Get-Module MyModule | Get-ModuleTheme

            You can see the current theme configuration for a particular module
        .Example
            Get-ModuleTheme Darkly -Module MyModule

            You can see the current theme configuration for a particular module
    #>
    [Alias("gmth")]
    [CmdletBinding(DefaultParameterSetName = '__CallStack')]
    param(
        [Parameter(Position = 0)]
        [string]$Name,

        # The name of the module you want to fetch theme data for
        [Parameter(ParameterSetName = "__ModuleName", Mandatory, ValueFromPipelineByPropertyName = $true)]
        [string]$Module,

        # The Module you want to fetch theme data for
        [Parameter(ParameterSetName = "__ModuleInfo", Mandatory, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.PSModuleInfo]$InputObject,

        # The callstack. You should not ever pass this.
        # It is used to calculate the defaults for all the other parameters.
        [Parameter(ParameterSetName = "__CallStack")][Hidden()]
        [System.Management.Automation.CallStackFrame[]]${_ _ CallStack} = $(Get-PSCallStack)
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq "__CallStack") {
            [System.Management.Automation.PSModuleInfo]$InputObject = . {
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
        if ($InputObject) {
            $Module = $InputObject.Name
        }
        if ($Module) {
            $Theme = if ($Name) {
                ImportTheme $Name
            } else {
                $MyInvocation.MyCommand.Module.PrivateData["Theme"]
            }
            if ($Theme) {
                $Theme.Item($Module)
            }
        }
    }
}