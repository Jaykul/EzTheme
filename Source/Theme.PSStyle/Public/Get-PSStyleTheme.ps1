using namespace PoshCode.Pansies
using namespace System.Management.Automation

function Get-PSStyleTheme {
    <#
        .SYNOPSIS
            Returns a hashtable of the _current_ values that can be splatted to Set-Theme
    #>
    [CmdletBinding()]
    param(
        # If specified, returns the named color scheme instead of the one associated with the current profile
        [Parameter(ValueFromPipeline)]
        [string]$ColorScheme
    )
    process {
        if ($null -ne 'System.Management.Automation.PSStyle' -as [type]) {
            $ErrorMessage = 'PSStyle is not supported by this version of PowerShell.'
            $Exception = [PSInvalidOperationException]::new($ErrorMessage)
            $PSCmdlet.ThrowTerminatingError([ErrorRecord]::new($Exception, "PSStyle Unsupported", "InvalidData", $Host.PrivateData))
        }
        $Result = [Ordered]@{
            PSTypeName       = "Theme.PSStyle"
        }

        $Simple, $Container = ($PSStyle | Get-Member -MemberType Property).Where({ $_.Definition -Match "^string|^int|^bool|OutputRendering" }, "Split")
        foreach($Property in $Simple) {
            $Result[$Property.Name] = $PSStyle.$($Property.Name)
        }

        foreach($Nested in $Container) {
            $Simple, $NestedFurther = ($PSStyle.$($Nested.Name) | Get-Member -MemberType Property).Where({ $_.Definition -Match "^string|^int|^bool|ProgressView" }, "Split")
            # $Result[$Nested.Name] = @{}
            foreach ($Property in $Simple) {
                #$Result[$Nested.Name][$Property.Name] = $PSStyle.$($Nested.Name).$($Property.Name)
                $Result[$Nested.Name + '_' + $Property.Name] = $PSStyle.$($Nested.Name).$($Property.Name)
            }

            foreach ($Furthest in $NestedFurther) {
                $Simple, $NestedFurthest = ($PSStyle.$($Nested.Name).$($Furthest.Name) | Get-Member -MemberType Property).Where({ $_.Definition -Match "^string|^int|^bool" }, "Split")
                # $Result[$Nested.Name][$Furthest.Name] = @{}
                foreach ($Property in $Simple) {
                    # $Result[$Nested.Name][$Furthest.Name][$Property.Name] = $PSStyle.$($Nested.Name).$($Furthest.Name).$($Property.Name)
                    $Result[$Nested.Name + '_' + $Furthest.Name + '_' + $Property.Name] = $PSStyle.$($Nested.Name).$($Furthest.Name).$($Property.Name)
                }

                if ("PSStyle.$($Nested.Name).$($Furthest.Name).$($NestedFurthest.Name)" -ne "PSStyle.FileInfo.Extension.Keys") {
                    Write-Warning "Unsupported PSStyle: PSStyle.$($Nested.Name).$($Furthest.Name).$($NestedFurthest.Name)`nPlease file an issue to let me know https://github.com/Jaykul/EzTheme/issues"
                }
            }
        }
        # Special case for the FileInfo
        $Result["FileInfo_Extension"] = @{}
        foreach ($ext in $PSStyle.FileInfo.Extension.Keys) {
            #$Result.FileInfo.Extension[$ext] = $PSStyle.FileInfo.Extension[$ext]
            $Result["FileInfo_Extension"][$ext] = $PSStyle.FileInfo.Extension[$ext]
        }

        [PSCustomObject]$Result
    }
}

