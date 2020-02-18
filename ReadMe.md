# Theme Everything

Collect theme information for various different themeable parts of your PowerShell environment into a single shareable theme file, and apply them all at once to switch the look of your shell.

From the default dark mode to a light high contrast readable presentation theme! You can control everything from colors to fonts, whatever is supported by theme commands -- and if something doesn't already support themes, you can add your own support!

# Included Theme Modules

Theme.Everything ships with wrapper modules for some common Windows terminals and consoles, and some popular PowerShell modules, which serve both to make it immediately useful, and as an example of how you can add theme support for other modules:

- PSReadLine Syntax Highlighting
- Windows Terminal (16 + 2 colors + Font)

Still to come:

- PowerShell Colors (Error, Debug, Warning, Verbose, Progress)
- Windows Console (16 + 2 colors + Font, Popup Colors)
- PowerLine Prompt Colors

# Writing a Themable Module

A themable module simply exports `Get` and `Set` commands with a noun based on the module name + "Theme".

For example, for the module `PSReadline`, we would expect `Get-PSReadlineTheme` and `Set-PSReadlineTheme` commands.

For a third-party module adding theme support to a different module, you would normally name the module by adding a "Theme." prefix on the module name, like `Theme.PSReadLine` ... but the commands don't double-up the "Theme" so the commands are still be `Get-PSReadlineTheme` and `Set-PSReadlineTheme` as if they were in the original module.

The specification for the commands is quite simple:

- `Get-Theme`
    - should output a _object_ which can be piped to Set-Theme
    - should have no mandatory parameters
    - should return the actual _current_ configuration
- `Set-Theme`
    - should accept the output of `Get-Theme` on the pipeline
    - should have no mandatory parameters
    - should reset the default theme if run without parameters
    - may have any other parameter sets you wish to allow configuration

That is, the output of Get-Theme, piped to Set-Theme, should re-apply the "current" themable settings on your module, and Set-Theme should have whatever parameters you want to enable theming of your module, even without needing `Theme.Everything` 😁

See [Theme.PSReadlineTheme](./Source/Theme.PSReadline) and [Theme.WindowsTerminal](./Source/Theme.WindowsTerminal) for examples.