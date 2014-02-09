------------------------------------------------------------------------------
                        ImageFileLibBCB for Delphi/BCB
------------------------------------------------------------------------------
                        Version 1.16, 2007-02-24
                        
        Michael Vinther  |  mv@logicnet·dk  |  http://logicnet.dk/lib


With this library, Delphi programs can read and write BMP, ICO, CUR, PNG, MNG, 
PCX, TIFF and JPEG 2000 bitmaps. RAS, PNM, PGM, PPM, HIPS images can be loaded, 
but not created.
This version was tested with Delphi 7 but should also work with 5, 6 and 2005. 
It has been used and tested in many different projects, but please notify me 
of any bugs.

License:
  This source code may be used in freeware products and free source distribu-
  tions either in the original or modified form. I only require that my name 
  is mentioned in the program (e.g. in the about box) or documentation. The 
  library may not be used in commercial products without permission from the 
  author (send an e-mail with short description of the application). 
  See JasPerLib\jasper-1.700.2\license for license information regarding the 
  included JasPer library. 
    
This library is a collection of units from different projects I have been 
working on. There is no documentation except for the comments in the source 
files and the following few lines. All I can say is look at the example 
program in the "Demo" directory. 

Thanks to Markus Oberhumer and Laszlo Molnar for their brilliant EXE compres-
sor UPX. (See http://upx.sourceforge.net/)

Thanks to Darius Babrauskas for making the lib comtatible with BCB. 

BMP:
Delphi's BMP reader implementation has some bugs, so ImageFileLib includes an 
alternative BMP reader created by Vit Kovalcik. I just added stream-support to
his code and created an interface compatible with the other image readers.
(Thanks to Massimo Magnano for finding this problem.)

JPEG2000:
Default is lossless compression. To get smaller image files, the desired 
comprerssion ratio can be directly. Example: Compressing the picture to 5% of
the raw bitmap size is achieved by setting 
ImageDLLLoader.Default.CompOptions:='rate=0.05';
before calling SaveToFile (see TForm1.Button2Click in the demo project).
A complete list of supported options can be found in the JasPer documentation
"JasPerLib\jasper-1.700.2\jasper.pdf", section 5.0.3.

JPEG2000, PNM, PGM, PPM and RAS is supported in the JasPer library by Michael 
David Adams. Version 1.700.2 of the JasPer source is included in the 
directory "JasPerLib\jasper-1.700.2". To be able to use the C-source in 
Delphi, I put the library in a DLL file (JasPerLib.dll), which is loaded with
the command ImageDLLLoader.Default.FindDLLs(Path), see TForm1.FormCreate in 
the demo project. A compiled DLL can be found in the "Demo" directory.
The latest version of JasPer can be downloaded from:
http://www.ece.uvic.ca/~mdadams/jasper/

PNG and MNG:
Gamma, alpha channel, transparency and bits per pixel for the last image loaded 
can be accessed by the properties in PNGLoader.Default, see PNGLoader.pas. 
Some PNG images contain gamma information, and without proper gamma correction
the images might appear too dark or too bright when displayed on the monitor.
If PNGLoader.Default.Gamma is different from zero the correction should be done. 
The TColorMap object in the ColorMapper unit will do it for you:

        ColorMap.SetGamma(2.2*PNGLoader.Default.Gamma);
        if Image.PixelFormat=pf8bit then ColorMap.Apply(Image.Palette)
        else ColorMap.Apply(Image);

where Image is the TLinearBitmap just loaded. The value 2.2 is standard monitor 
gamma.
MNG is an extended version of the PNG format, and only a very small part of the
extensions are implemented in ImageFileLib. This means that only single-image 
MNGs are supported, not animations.

ICO and CUR:
In addition to the icons supported by TIcon in Delphi, ICOLoader.pas in this 
library also supports 24 bit and 256 color palette icons and cursors. Trans-
parent color and cursor hot spot can be set in ICOLoader.Default. If
ICOLoader.Default.AllwaysLoadFirst is set true, the first icon in a multi
icon/cursor file is always loaded, else a dialog is shown where the user can
select the desired image.

TIFF:
The TIFFRead DLL is based on the work of Nick Chislin. My aditions to his code
was CMYK image support, reading of TIFF files in Windows 95/98/Me and a few
other improvements and bugfixes. 

JPEG:
Note that both Delphi 5 and Delphi 6 have bugs in their JPEG handling, but not
the same bug: The JPEG unit supplied with Delphi 5 cannot save JPEG images to 
a file size greater than about 1 MB. Delphi 6 cannot read JPEG images if the 
image height is only one pixel. 
Gabriel Corneanu has created a unit that replaces Delphi's JPEG unit which 
solves the problems, and also adds support for CMYK files and lossless JPEG 
rotation.
Unfortunately this is not open-source, but the DCU files for Delphi 5, 6, 7 and
2005 are included in ImageFileLib in the JPEG directory. 



Version history:
----------------
Note that this version history is incomplete. It does not include all changes
in all versions. 

Version 1.00  (2003-01-05)
  First release
Changes in version 1.01  (2003-03-08):
  TLinearBitmap.AssignToTBitmap replaced by AssignTo
  TLinearBitmap.GetFromTBitmap replaced by Assign
  JPEG desired file size specification
  PNG gamma, transparency, and alpha channel handling improved
Changes in version 1.10  (2003-04-14):
  TIFF support
  File format list sorted
Changes in version 1.11  (2003-05-18):
  PNG compression ratio improved
  WMF/EMF support for TLinearBitmap
Changes in version 1.12  (2003-07-20):
  LoadFromStream/SaveToStream now supported for all image formats
Changes in version 1.13  (2003-10-05):
  16 bit grayscale TIFF read to bitmap with pf16bit
  16 bit grayscale PNG read to bitmap with pf16bit  
  Lossy PNG compression option
  JPEG 2000 temporary files not deleted bug fixed
  Integrated JasPer 1.700.2
Changes in version 1.14  (2003-12-29):
  MNG image support added to the PNGLoader unit
Changes in version 1.15  (2005-02-06):
  Improved TIFF support
  Improved JPEG2000 support
Changes in version 1.15.2  (2005-02-15):
  Faster version JasPerLib.dll in Demo folder (compiled with other compiler)
Changes in version 1.16  (2005-10-09):
  CMYK support in JPEG loading Gabriel Corneanu
  YCbCR and Lab color space support in JPEG-2000 reading
  Improved BMP reader by Vit Kovalcik  (fixes some bugs in Delphi's)
