function FindProfile {
    [CmdletBinding()]
    param(
        # A collection of profiles to search by GUID
        $Profiles = $((GetLayeredConfig -FlattenDefaultProfile).profiles.list),

        # If the only thing we care about is the color scheme, we can take shortcuts
        [Switch]$ColorSchemeReadOnly,

        # The profile guid. Default value from Env:WT_PROFILE_ID
        $ProfileId = $Env:WT_PROFILE_ID
    )

    if (!$ProfileId) {
        Write-Warning "ENV:WT_PROFILE_ID should always be set when you're in Windows Terminal. Without that, we cannot identify the current profile. Please ensure you're running Windows Terminal 0.11 or higher."
    } else {
        if (($P = $Profiles.Where({ $_.guid -eq $ProfileId }))) {
            $P
        } else {
            Write-Error "The ProfileId should be a guid set in ENV:WT_PROFILE_ID"
        }
    }
}