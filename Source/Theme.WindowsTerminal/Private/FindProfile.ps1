function FindProfile {
    [CmdletBinding()]
    param(
        # A copllection of profiles to search
        $Profiles = $((GetLayeredConfig -FlattenDefaultProfile).profiles.list),

        # If the only thing we care about is the color scheme, we can take shortcuts
        [Switch]$ColorSchemeReadOnly,

        # The profile guid. Should be read from Env:WT_Profile if that's set
        $ProfileId = $Env:WT_Profile
    )

    # If Env:WT_Profile is not set, we have no way to determine which profile is "this" one in Windows Terminal, so we guess:
    if ($ProfileId) {
        $P = $Profiles.Where({ $_.guid -eq $ProfileId})
        if ($P.Count -eq 1) {
            $P
            return
        } else {
            Write-Warning "'$ProfileId' matches $($P.Count) profiles. Set Env:WT_Profile to the guid of the active profile"
            Remove-Item Env:WT_Profile
        }
    }

    # This must be a PowerShell profile ...
    $Profiles = $Profiles.Where({ $_.commandline -match "pwsh|powershell" -or $_.source -match "PowerShell" })
    Write-Debug "$($Profiles.Count) powershell profiles of $($Profiles.Count)"

    if ($Profiles.Count -eq 0) {
        $Profiles
        $Env:WT_Profile = $Profiles.guid
        return
    }

    if ($ColorSchemeReadOnly -and ($Profiles.colorScheme | Sort-Object -Unique).Count -eq 1) {
        Write-Debug "All $($Profiles.Count) profiles share the color scheme: $colorScheme, returning the first one: $($Profiles[0].name)"
        $Env:WT_Profile = $Profiles[0].guid
        $Profiles[0]
        return

    } else {
        if ($PSVersionTable.PSVersion -lt "6.0") {
            $Profiles = $Profiles.Where({ $_.commandline -match "powershell" })
            Write-Debug "$($Profiles.Count) Windows PowerShell profiles of $($Profiles.Count)"
        } else {
            $Profiles = $Profiles.Where({ $_.commandline -match "pwsh" -or $_.source -match "PowerShell" })
            Write-Debug "$($Profiles.Count) pwsh profiles of $($Profiles.Count)"
        }

        if ($Profiles.Count -eq 0) {
            $Env:WT_Profile = $Profiles[0].guid
            $Profiles
            return
        }

        # Try narrowing down PowerShell Core profiles by major version number:
        # We'll take either an exact match (currently, pwsh 6 will match this way)
        $MatchingProfile = $Profiles.Where({ $_.name -match $PSVersionTable.PSVersion.Major })
        if ($MatchingProfile.Count -eq 1) {
            Write-Debug "Found PowerShell profile matching $($PSVersionTable.PSVersion.Major)"
            $Env:WT_Profile = $MatchingProfile.guid
            $MatchingProfile
            return
        } else {
            Write-Debug "$($MatchingProfile.Count) profiles matching version $($PSVersionTable.PSVersion.Major)"
        }

        # Or the only profile without a match to a different version (currently, pwsh 7 will match this way)
        $MatchingProfile = $Profiles.Where({
            -not $_.hidden -and ($_.name -notmatch ($PSVersionTable.PSVersion.Major - 1)) -and ($_.name -notmatch ($PSVersionTable.PSVersion.Major + 1))
        })
        if ($MatchingProfile.Count -eq 1) {
            Write-Debug "Found PowerShell profile not matching $($PSVersionTable.PSVersion.Major - 1) or $($PSVersionTable.PSVersion.Major + 1)"
            $Env:WT_Profile = $MatchingProfile.guid
            $MatchingProfile
            return
        } else {
            Write-Debug "$($MatchingProfile.Count) profiles not matching version $($PSVersionTable.PSVersion.Major - 1) or $($PSVersionTable.PSVersion.Major + 1)"
        }
        Write-Warning "Unable to determine profile. $($Profiles.Count) profiles matched: '$($Profiles.name -join "', '")'.`nTo resolve, set `$Env:WT_Profile to the guid of the active profile."
   }
}