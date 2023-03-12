> # Pre-Release

You've found EzTheme before it's finished. The core module is here, along with a few helpers, but there's no theme sharing yet, and virtually no modules outside of this repository have been updated to be configurable with EzTheme.

# EZ Theme

The **EzTheme** module is an easy way to add theme support to modules, PowerShell, Windows Terminal and more.

Out of the box, it collects color information for various different parts of your PowerShell environment into a single shareable theme file, and lets you apply them all at once to switch up the colors in your shell.

From the default dark mode to a light high contrast readable presentation theme! You can control everything from colors to fonts, whatever is supported by theme commands -- and if something doesn't already support themes, you can add your own support!

![PowerShell Themes](https://github.com/Jaykul/EzTheme/raw/master/resources/EzTheme.gif)

## Using Ez Theme

You can find modules which support EzTheme by searching for the EzTheme tag on the [PowerShell Gallery](https://www.powershellgallery.com/packages?q=Tags:EzTheme).

If you import those modules and configure them the way you want them using their Get/Set-*Theme commands, you can then export your current settings as a theme by calling `Export-Theme` and giving it a name.

```PowerShell
Export-Theme -Name Jaykul
```

If you want to switch to a different theme, you can switch by using `Import-Theme`. Any EzTheme-compatible modules which are already imported will be themed immediately, and any modules which are loaded later will pick up the theme when they're imported.

```PowerShell
Import-Theme Lightly
```

## Included Theme Modules

EzTheme ships with wrapper modules for Windows Terminal, PowerShell and the native console host, and the built-in PSReadLine module, which serves to make it immediately useful, and as examples of how you can add theme support for other modules:

<dl>
  <dt>Theme.PSReadLine</dt>
  <dd>PSReadLine Syntax Highlighting</dd>
  <dt>Theme.WindowsTerminal</dt>
  <dd>Windows Terminal colors schemes and font (the 16 ANSI colors plus default foreground, background, and font)</dd>
  <dt>Theme.PowerShell</dt>
  <dd>PowerShell PrivateData console colors (Error, Debug, Warning, Verbose, Progress, and the new FormatAccent and ErrorAccent)</dd>
</dl>

Still to come:

<dl>
  <dt>Theme.WindowsConsole</dt>
  <dd>Windows Console colors and font (the 16 ANSI colors plus default foreground, background, and font)</dd>
</dl>

# Writing a Themable Module

A themable module has to do three things:

1. Implement compatible `Get` and `Set` commands
2. Add the EzTheme annotation to your module's PrivateData
3. Call EzTheme on module load

## The EzTheme compatible `Get` and `Set` commands

The two commands work together as outlined below, but _they are not actually named `Get-Theme` or `Set-Theme`_. To avoid name collisions, you should prefix them with your module name or normal prefix (e.g. the PowerLine module will have a `Get-PowerLineTheme` and a `Set-PowerLineTheme`). The commands need to be _public_ to work properly:

- `Get-Theme`
    - should output a _object_ which can be piped to Set-Theme
    - should have no mandatory parameters
    - should return the actual _current_ configuration
- `Set-Theme`
    - should accept the output of `Get-Theme` on the pipeline
    - should have no mandatory parameters
    - should reset the default theme if run without parameters
    - may have any other parameter sets you wish to allow configuration

The bottom line is that the output of Get-Theme, piped to Set-Theme, should re-apply the "current" themable settings on your module, and Set-Theme without any parameters should completely reset your module to the default theme, even without needing `EzTheme` 😁

Note that although we have suggested command names, you can actually use whatever names you want to -- we simply recommend the module name as a prefix for consistency with other EzTheme modules. Also, for a third-party module which adds theme support to a different module, you normally name the module by adding a "Theme." prefix on the module name, like `Theme.PSReadLine` ... but the commands don't double-up the "Theme" so the commands are still `Get-PSReadLineTheme` and `Set-PSReadLineTheme` since they still theme PSReadLine.

## The EzTheme annotation for your PrivateData

Each EzTheme compatible module should add "EzTheme" to their module's tags in PrivateData.PSData. Additionally, you _must_ add an "EzTheme" section to the PrivateData, with "Get" and "Set" keys pointing at your get and set commands. For example, the relevant section of the PowerLine module would look like this:

```PowerShell
    PrivateData = @{
        PSData  = @{
            <#
              additional PowerShell Gallery information
              ...
            #>
            Tags = @('Prompt', 'ANSI', 'VirtualTerminal', 'EzTheme')
        }
        'EzTheme' = @{
            Get = 'Get-PowerLineTheme'
            Set = 'Set-PowerLineTheme'
        }
    }
```

## Call EzTheme on module load

At the bottom of your EzTheme compatible module, you need to check if EzTheme is already loaded, and import the current theme if there is one for you. To do that, you add code like this at the bottom of your module's psm1:

```PowerShell
if (Get-Module EzTheme -ErrorAction SilentlyContinue) {
    Get-ModuleTheme | Set-PowerLineTheme
}
```

## Custom Views for Themes

The recommended way to implement your `Get-Theme` output is to either create a strongly-typed theme class, or a PSCustomObject with a custom PSTypeName. Then you can implement a custom view for the type in a format file.

See [Theme.PSReadLineTheme](./Source/Theme.PSReadLine) and [Theme.WindowsTerminal](./Source/Theme.WindowsTerminal) for examples.