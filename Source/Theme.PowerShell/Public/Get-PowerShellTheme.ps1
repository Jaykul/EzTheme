using namespace PoshCode.Pansies
using namespace System.Management.Automation

function Get-PowerShellTheme {
    <#
        .SYNOPSIS
            Returns a hashtable of the _current_ values that can be splatted to Set-Theme
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$ColorScheme
    )
    process {
        if ($Host.PrivateData.PSTypeNames[0] -ne 'Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy') {
            $ErrorMessage = 'PowerShell $Host.PrivateData is not the ConsoleHost+ConsoleColorProxy'
            $Exception = [PSInvalidOperationException]::new($ErrorMessage)
            $PSCmdlet.ThrowTerminatingError([ErrorRecord]::new($Exception, "Unsupported Host PrivateData", "InvalidData", $Host.PrivateData))
        }
        if ($RawUI = $Host.UI.RawUI) {
            $Result = $Host.PrivateData |
                Select-Object *AccentColor, *BackgroundColor, *ForegroundColor |
                Add-Member -NotePropertyName Foreground -NotePropertyValue $RawUI.ForegroundColor -PassThru |
                Add-Member -NotePropertyName Background -NotePropertyValue $RawUI.BackgroundColor -PassThru

        } else {
            $Result = $Host.PrivateData |
                Select-Object *AccentColor, *BackgroundColor, *ForegroundColor
        }
        $Result.PSTypeNames.Insert(0, "Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy")
        $Result
    }
}

