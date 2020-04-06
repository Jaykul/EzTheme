using PoshCode.Pansies.Console;
using System.Linq;
using System.Management.Automation;

namespace PoshCode.Pansies.Commands
{
    [Cmdlet("Get", "WindowsConsoleTheme")]
    public class GetWindowsConsoleTheme : Cmdlet
    {
        /// <summary>
        /// Determines whether the returned palette is the current console palette or the default console palette
        /// </summary>
        [Parameter()]
        public SwitchParameter Default { get; set; }

        /// <summary>
        /// Determines whether the returned palette includes the default foreground and background colors (if supported)
        /// </summary>
        [Parameter()]
        public SwitchParameter AddScreenAndPopup { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();
            Palettes.ConsolePalette palette;

            if (Default)
            {
                palette = WindowsHelper.GetDefaultConsolePalette(AddScreenAndPopup);
            }
            else
            {
                palette = WindowsHelper.GetCurrentConsolePalette(AddScreenAndPopup);
            }
            var colorTheme = new PSObject(palette);
            colorTheme.TypeNames.Insert(0, "Terminal.ColorScheme");
            WriteObject(colorTheme);
        }
    }
}
