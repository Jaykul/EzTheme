function Unregister-Themable {
    <#
        .Synopsis
            Unregister a themable module.

        .Description
            Removes a module from theming.
        .Example
            Unregister-Themeable Theme.PSReadline

            Prevents the Theme.PSReadline module from being automatically themed by the Theme-Everything module
    #>
    [CmdletBinding()]
    param(
        # The name of the module you want to register as themable
        [Alias("Name")]
        $ModuleName
    )

    $Configuration = Import-Configuration
    $Configuration.Modules = $Configuration.Modules -ne $ModuleName
    $Configuration | Export-Configuration
}