function Write-TextOnImage {
    <#
        .SYNOPSIS
            Writes text to an image.
        .DESCRIPTION
            Writes one or more lines of text onto a rectangle on an image.

            By default, it writes the computer name on the bottom right corner, with an outline around so you can read it regardless of the picture.
        .EXAMPLE
            Write-OutlineText "$Env:UserName`n$Env:ComputerName`n$Env:UserDnsDomain" -Path "~\Wallpaper.png"
    #>
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = "OnExistingImageFile", Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateScript( {
                if (!(Test-Path "$_")) {
                    throw "The path must point to an existing image. Can't find '$_'"
                }
                $true
            })]
        [Alias("PSPath")]
        [string]$Path,

        [Parameter(ParameterSetName = "OnExistingImageFile")]
        [Parameter(ParameterSetName = "OnNewImageFile", Mandatory)]
        [Parameter(ParameterSetName = "OnExistingGraphics", ValueFromPipeline, Mandatory)]
        [string]$NewPath,

        [Parameter(ParameterSetName = "OnNewImageFile")]
        [System.Drawing.Size]$ImageSize,

        [Parameter(ParameterSetName = "OnExistingGraphics", ValueFromPipeline, Mandatory)]
        [System.Drawing.Graphics]$Graphics,

        # Number of pixels of padding on the left. By default, 20 pixels.
        [int]$LeftPadding = 20,
        # Number of pixels of padding on the top. By default, 20 pixels.
        [int]$TopPadding = 20,
        # Number of pixels of padding on the right. By default, 20 pixels.
        [int]$RightPadding = 20,
        # Number of pixels of padding on the bottom. By default, 60 pixels.
        [int]$BottomPadding = 60,

        [string]$Text = $Env:ComputerName,

        [string]$FontName = "Cascadia Code",

        [int]$FontSize = 38,

        [System.Drawing.FontStyle]$FontStyle = "Bold",

        # The alignment relative to the bounds. Note that in a left-to-right layout, the far position is bottom, and the near position is top.
        [System.Drawing.StringAlignment]$VerticalAlignment = "Far",

        # The alignment relative to the bounds. Note that in a left-to-right layout, the far position is right, and the near position is left. However, in a right-to-left layout, the far position is left.
        [System.Drawing.StringAlignment]$HorizontalAlignment = "Far",

        # The stroke color (defaults to [System.Drawing.Brushes]::Black)
        [System.Drawing.Brush]$StrokeBrush = [System.Drawing.Brushes]::Black,

        # The fill color (defaults to [System.Drawing.Brushes]::White)
        [System.Drawing.Brush]$FillBrush = [System.Drawing.Brushes]::White
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq "OnExistingImageFile") {
            $Source = [System.Drawing.Image]::FromFile((Convert-Path $Path))
            $Graphics = [System.Drawing.Graphics]::FromImage($Source)
            Write-Verbose "Adding text to existing $($Graphics.VisibleClipBounds.Width) x $($Graphics.VisibleClipBounds.Height) image"
        } elseif($PSCmdlet.ParameterSetName -eq "OnNewImageFile") {
            $Source = [System.Drawing.Bitmap]::new($ImageSize.Width, $imageSize.Height)
            $Graphics = [System.Drawing.Graphics]::FromImage($Source)
            # $Graphics.Clear($StrokeBrush.Color)
            Write-Verbose "Adding text to blank $($ImageSize.Width) x $($ImageSize.Height) image"
        } else {
            Write-Verbose "Adding text to image from '$Path'"
        }

        # Save as png to avoid asking them, and dealing with image format as a parameter
        if ($Path -and -not $NewPath) {
            $NewPath = "{0}\{1}{2}" -f [IO.Path]::GetDirectoryName($Path),
            ([IO.Path]::GetFileNameWithoutExtension($Path) + '-' + ($Text -replace ("[" + [regex]::escape([io.path]::GetInvalidFileNameChars()) +"]"))),
            [IO.Path]::GetExtension($Path)
        } elseif ($Path -and -not (Split-Path $NewPath)) {
            $NewPath = Join-Path ([IO.Path]::GetDirectoryName($Path)) $NewPath
            Write-Verbose "Adding text to image: '$Path'"
        }

        try {
            $Bounds = [System.Drawing.RectangleF]::new(
                        $Graphics.VisibleClipBounds.Location + [System.Drawing.SizeF]::new($LeftPadding, $TopPadding),
                        $Graphics.VisibleClipBounds.Size - [System.Drawing.SizeF]::new($RightPadding + $LeftPadding, $TopPadding + $BottomPadding))
            Write-Verbose "Using Bounds: $($Bounds.Top), $($Bounds.Left), $($Bounds.Bottom, $Bounds.Right)"

            $Font = try {
                [System.Drawing.FontFamily]::new($FontName)
            } catch {
                [System.Drawing.FontFamily]::GenericMonospace
            }
            Write-Verbose "Using FontFamily $Font"

            $StringFormat = [System.Drawing.StringFormat]::GenericTypographic
            $StringFormat.Alignment = $HorizontalAlignment
            $StringFormat.LineAlignment = $VerticalAlignment

            $GraphicsPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
            $GraphicsPath.AddString(
                $Text,
                $Font,
                $FontStyle,
                ($Graphics.DpiY * $FontSize / 72),
                $Bounds,
                $StringFormat);

            Write-Verbose "Adding '$Text' to the image in $($FillBrush.Color) on $($StrokeBrush.Color)"
            $Graphics.FillPath($FillBrush, $GraphicsPath);
            $Graphics.DrawPath($StrokeBrush, $GraphicsPath);
        } catch {
            Write-Warning "Unhandled Error: $_"
            Write-Warning "Unhandled Error: $($_.ScriptStackTrace)"
            throw
        } finally {
            if ($PSCmdlet.ParameterSetName -ne "OnExistingGraphics") {
                $Graphics.Dispose()
            }
            try {
                if ($NewPath -and $Source) {
                    $ImageFormat = switch ([IO.Path]::GetExtension($NewPath)) {
                        ".png" { [System.Drawing.Imaging.ImageFormat]::Png }
                        ".bmp" { [System.Drawing.Imaging.ImageFormat]::Bmp }
                        ".jpg" { [System.Drawing.Imaging.ImageFormat]::Jpeg }
                    }
                    Write-Verbose "Writing a $([IO.Path]::GetExtension($NewPath)) to $NewPath"
                    $Source.Save($NewPath, $ImageFormat)
                }
                Get-Item $NewPath
            } finally {
                if ($PSCmdlet.ParameterSetName -ne "OnExistingGraphics") {
                    $Source.Dispose()
                }
            }
        }
    }
}
