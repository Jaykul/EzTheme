function Get-TerminalColorMode {
    <#
        .SYNOPSIS
            Tests for FullColor (RGB) mode and X11/XTerm (XColor) modes by writing SGR and verifying it with a DECRQSS
            Returns "Uknown" if there's no DECRQSS support, or "FullColor" and/or "XColor" otherwise
    #>
    [CmdletBinding()]
    param()

    $ColorMode = @{
        '48:2:255:0:255' = 'FullColor'
        '48:5:254'       = 'XColor'
        '48;2;255;0;255' = 'FullColorCompatible'
        '48;5;254'       = 'XColorCompatible'
    }

    $SupportedModes = @(foreach ($SGR in $ColorMode.Keys) {
            $DECRQSS = -join @(
                # Set the background color
                "`e[0m`e[$($SGR)m"
                # Output the DECRQSS query
                "`eP`$qm`e`\"
                # Reset the background
                "`e[49m"
            )

            # strip the DCS and ST from the ends of the response and return just the SGR value as the Response
            $Result = Get-TerminalResponse $DECRQSS | SelectCapturedString '(?:\u001BP|\u0090)(?<Result>\d+)\$r(?:0;)?(?<Code>.*)m(?:\u001B[\\\t])'
            Write-Verbose "$($Result.Result)r$($Result.Code)m"

            # the result code is supposed to be 1 no matter what, no idea what other values represent, really
            if ($Result.Result -ne 1) {
                Write-Verbose "Request Status String (DECRQSS) not supported (returned $($Result.Result))"
                continue
            }
            if ($Result.Code -ne $SGR) {
                Write-Verbose "Received unexpected result, our '$($SGR)' color mode wasn't supported (returned $($Result.Result))"
                continue
            }
            $SGR
        })
    $ColorMode[$SupportedModes]
}