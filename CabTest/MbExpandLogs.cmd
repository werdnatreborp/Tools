IF [%1] EQU [] (
   ECHO.Usage: %1 inputfile.cab
   ECHO.       file can be dropped onto this script, to run
   ECHO.       output folder name will be requested
   PAUSE
   EXIT /B 1
) ELSE (
   SET _CAB=%1
)
 
SETLOCAL EnableDelayedExpansion
SET _EXPANDPATH=%HOMEDRIVE%%HOMEPATH%\DESKTOP\
SET/P _FOLDER=Type new foldername for output %_EXPANDPATH%
MKDIR %_EXPANDPATH%%_FOLDER%
expand %_CAB%  -F:* !_EXPANDPATH!!_FOLDER!

