@ECHO ON
SET _CAB=MBLogs-%COMPUTERNAME%.cab
SET _DIR=%HOMEDRIVE%%HOMEPATH%\DESKTOP
ECHO.-------------------------------------------------------------------------
ECHO.Compress Logfiles into a CABinet file for Sales Engineers, trial support
ECHO.for easy emailing.   %_CAB% will be created on desktop
ECHO.-------------------------------------------------------------------------
SETLOCAL EnableDelayedExpansion

SET _DIRECTIVE="%HOMEDRIVE%%homepath%\desktop\_DIRECTIVE-DTF.TXT"
SET _GETFILES="%HOMEDRIVE%%homepath%\desktop\_GETFILES.TXT"

CALL :CREATEDTF    && REM Initialise MAKECAB directives
CALL :SETFILES     && REM Create list of folders and files to search
CALL :SEARCHFILES  && REM Run search and append all file names into CAB directives file
PAUSE
CALL :MAKECAB
CALL :CLEANUP

ECHO.
ECHO.%_CAB% has been created on your desktop
ECHO.
ECHO.
PAUSE

GOTO :EOF

::----------------------------------------------------------------------------
:CREATEDTF
::----------------------------------------------------------------------------
>  !_DIRECTIVE! ECHO.; MAKECAB Directive file                                                           
>> !_DIRECTIVE! ECHO .OPTION EXPLICIT                    ; Generate errors on variable typos
>> !_DIRECTIVE! ECHO..set Cabinet=On                     ; Default On
>> !_DIRECTIVE! ECHO..set CabinetNameTemplate=!_CAB!     ; Template for multi-disk sets MBCab*.cab
>> !_DIRECTIVE! ECHO..set Compress=ON
>> !_DIRECTIVE! ECHO..set CompressedFileExtensionChar=_  ; Default
>> !_DIRECTIVE! ECHO..set CompressionType=MSZIP          ; Compression alternatives are MSZIP or LZX
REM >> !_DIRECTIVE! ECHO..set DiskDirectory=!_DIR!           ; Output Dir
>> !_DIRECTIVE! ECHO..set DiskDirectoryTemplate=!_DIR!   ; Create single output disk
>> !_DIRECTIVE! ECHO..set MaxCabinetSize=0               ; Default no limit
>> !_DIRECTIVE! ECHO..set MaxDiskSize=CDROM              ; Put a sensible limit
>> !_DIRECTIVE! ECHO..set RptFileName=!HOMEDRIVE!!HOMEPATH!\DESKTOP\MBGetLogsRpt.txt   ; Name of report file
>> !_DIRECTIVE! ECHO..set InfFileName=!HOMEDRIVE!!HOMEPATH!\DESKTOP\MBGetLogs.inf      ;  Input File List 
GOTO :EOF





::---------------------------------------------------------
:SETFILES
::---- Create list of searches ----------------------------
SETLOCAL EnableDelayedExpansion
>  !_GETFILES! ECHO.# ******** LIST OF FILE SEARCHES, WITH FILENAMES FOUND *************************
>> !_GETFILES! ECHO.%HOMEDRIVE%%homepath%\desktop\mb-events\*.*
PAUSE
GOTO :EOF

::-----------------------------------------------------------------------------
:MAKECAB
::-----------------------------------------------------------------------------
ECHO Instructions for CAB compress are written into !_DIRECTIVE!
MAKECAB /V1 /F !_DIRECTIVE! 
GOTO :EOF


::---------------------------------------------------------------------------------
:SEARCHFILES
::-------------------------------------------------------------------------------- 
SETLOCAL EnableDelayedExpansion
:: Read list of searches from GETFILES, for each, do a directory search
FOR /F "usebackq tokens=*" %%a IN (`TYPE !_GETFILES!`) DO ( 
   REM --- If first character is #, output as a comment. Note: Do not add any chars to next line
   SET _LINE=%%a
   REM Strip variable
   SET _LINE=!_LINE:~0,1!
   
   IF [!_LINE!] EQU [#] (
      >> !_DIRECTIVE! ECHO.;%%a
   ) ELSE (          
      REM Write comment containing search string
      ECHO.;--- SEARCH %%a  >> !_DIRECTIVE!
      REM Do directory search and write each filename to DIRECTIVE file
      FOR /F "usebackq tokens=*" %%a IN (`DIR /B /S "%%a" 2^> nul`) DO (
        >> !_DIRECTIVE! ECHO."%%a"
      )
   ) 
)
REM --- include the DIRECTIVE.DTF itself into package, so receiver can check file sources
>> !_DIRECTIVE! ECHO.%_DIRECTIVE% 
GOTO :EOF


::-------- CLEANUP -----------------------------------
:CLEANUP
DEL /Q !_DIRECTIVE!                                              > nul 2>&1
DEL /Q !_GETFILES!                                               > nul 2>&1
DEL !HOMEDRIVE!!HOMEPATH!\DESKTOP\MBGetLogsRpt.txt               > nul 2>&1
DEL !HOMEDRIVE!!HOMEPATH!\DESKTOP\MBGetLogs.inf                  > nul 2>&1
GOTO :EOF




:END
