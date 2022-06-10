function SelectCapturedString {
    <#
        .Synopsis
            Collect named capture groups from regular expression matches
            (I still don't like the name of this function, and it should be in some other module)
        .Description
            Takes string data and a regular expression containing named captures,
            and outputs all of the resulting captures in one (or more) hashtable(s)
        .Example
            netstat | Select-CapturedString "(?<Protocol>\w{3})\s+(?<LocalIP>(\d{1,3}\.){3}\d{1,3}):(?<LocalPort>\d+)\s+(?<ForeignIP>.*):(?<ForeignPort>\d+)\s+(?<State>\w+)?"
            This is an example of how to use it for parsing when all the values are on one line
        .Example
            "Revoked Certificates:
                Serial Number: 011F63068E6BCD8CABF644026B80A903
                    Revocation Date: Jul  8 06:22:01 2012 GMT
                Serial Number: 01205F0018B6758D741B3DB43CFB26C2
                    Revocation Date: Feb 18 06:11:14 2013 GMT
                Serial Number: 012607175D820413ED0750E96B833A8F
                    Revocation Date: Jun 11 03:12:11 2015 GMT
            " | Select-CapturedString "(?m)Serial Number:\s+(?<SerialNumber>.*)\s*$|Revocation Date:\s+(?<RevocationDate>.*)\s*$" -Auto
            SerialNumber                     RevocationDate
            ------------                     --------------
            011F63068E6BCD8CABF644026B80A903 Jul  8 06:22:01 2012 GMT
            01205F0018B6758D741B3DB43CFB26C2 Feb 18 06:11:14 2013 GMT
            012607175D820413ED0750E96B833A8F Jun 11 03:12:11 2015 GMT
            When your values are on multiple lines, you can use the -AutoGroup switch to automatically collect sets of matches.
    #>
    param(
        # The text to search for captures
        [Parameter(ValueFromPipeline = $true)]
        [string]$text,

        # A regular expression containing named capture groups (see examples)
        [Parameter(Position = 1)]
        [regex]$re,

        # By default, each match is returned as a single object.
        # When set, empty captures are ignored, and properties are collected until the capture groups repeat, allowing the collection of many lines using an OR regex (see Example 2)
        [switch]$AutoGroup,

        # If set, hide properties with empty values (default to the same as $AutoGroup)
        [switch]$HideEmpty = $AutoGroup
    )
    begin {
        [string[]]$FullData = $text
    }
    process {
        [string[]]$FullData += $text
    }
    end {
        $text = $FullData -join "`n"
        if ($VerbosePreference -eq "Continue") {
            Write-Verbose "Regex $re"
            Write-Verbose "Data $(-join $text.GetEnumerator().ForEach{ if (27 -ge $_) { [char](0x2400 + $_) } else { "$_" } })"
        }
        $names = $re.GetGroupNames().Where{ $_ -ne 0 }
        $result = [ordered]@{}
        foreach ($match in $re.Matches($text).Where{ $_.Success }) {
            Write-Verbose (-join $match.Value.GetEnumerator().ForEach{ if (27 -ge $_) { [char](0x2400 + $_) } else { "$_" } })
            foreach ($name in $names) {
                if (-not $HideEmpty -or $match.Groups[$name].Value) {
                    if ($AutoGroup -and $result.ContainsKey($name)) {
                        [PSCustomObject]$result
                        $result = [ordered]@{}
                    }
                    $result.$name = $match.Groups[$name].Value
                }
            }
            if (!$AutoGroup) {
                [PSCustomObject]$result
                $result = [ordered]@{}
            }
        }
        if ($result) {
            [PSCustomObject]$result
        }
    }
}