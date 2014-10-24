@ECHO OFF
ECHO Making ressources file.
DEL GPS.rc
DEL RessourcesList.txt
FOR %%F IN (*.bmp) DO (
  ECHO %%~nF BITMAP %%~nF.bmp >> GPS.rc
)
ECHO Compiling ressources file.
BRCC32 -v GPS.rc
COPY GPS.res ..\..\GPS.dcr
DEL GPS.rc GPS.res