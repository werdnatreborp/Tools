@ECHO OFF
SET _CAB=MBLogs-%COMPUTERNAME%.cab
SET _DIR=%HOMEDRIVE%%HOMEPATH%\DESKTOP
ECHO.-------------------------------------------------------------------------
ECHO.Compress Logfiles into a CABinet file for Sales Engineers, trial support
ECHO.for easy emailing.   %_CAB% will be created on desktop
ECHO.Note: Use the MBCloudEA.exe - diag technique for formal Cases
ECHO.-------------------------------------------------------------------------
SETLOCAL EnableDelayedExpansion

SET _DIRECTIVE="%HOMEDRIVE%%homepath%\desktop\_DIRECTIVE-DTF.TXT"
SET _GETFILES="%HOMEDRIVE%%homepath%\desktop\_GETFILES.TXT"

CALL :CREATEDTF    && REM Initialise MAKECAB directives
CALL :SPECIAL      && REM Setup some custom variables   
CALL :SETFILES     && REM Create list of folders and files to search
CALL :SEARCHFILES  && REM Run search and append all file names into CAB directives file
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

::----------------------------------------------------------------------------------
:SPECIAL
:: Handle some special setups

::--- Discovery and Deploy Tool Logs - See EAInstall.bat contents
if not defined LOCALAPPDATA (set LOCALAPPDATA="%USERPROFILE%\Local Settings")
if not exist %LOCALAPPDATA%\Temp ( 
	set _logDirectory=%WINDIR%\Temp
) else ( 
	set _logDirectory=%LOCALAPPDATA%\Temp
)

::---- Copy this file file as it is locked ----
MKDIR "%HOMEDRIVE%%HOMEPATH%\DESKTOP\__MBAMSERVICE-LOGS"
MKDIR "%HOMEDRIVE%%HOMEPATH%\DESKTOP\__MBAGENT-LOGS"
XCOPY /S /E /Y "%ProgramData%\Malwarebytes\MBAMService\logs\*.*"      "%HOMEDRIVE%%HOMEPATH%\DESKTOP\__MBAMSERVICE-LOGS"
XCOPY /S /E /Y "%ProgramData%\Malwarebytes Endpoint Agent\logs\*.*"   "%HOMEDRIVE%%HOMEPATH%\DESKTOP\__MBAGENT-LOGS"


GOTO :EOF

::---------------------------------------------------------
:SETFILES
::---- Create list of searches ----------------------------
SETLOCAL EnableDelayedExpansion
>  !_GETFILES! ECHO.# ******** LIST OF FILE SEARCHES, WITH FILENAMES FOUND *************************
>> !_GETFILES! ECHO.# ******** Endpoint Agent
>> !_GETFILES! ECHO.%Windir%\EndpointMsi.txt
>> !_GETFILES! ECHO.%ProgramData%\Malwarebytes Endpoint Agent\*.installlog
>> !_GETFILES! ECHO.# --Malwarebytes Endpoint Agent\logs\*.* copied from temp file, due to locks
>> !_GETFILES! ECHO.%HOMEDRIVE%%HOMEPATH%\DESKTOP\__MBAGENT-LOGS

>> !_GETFILES! ECHO.# ******** MBAM Service
>> !_GETFILES! ECHO.# --MBAMSERVICE\logs\*.* copied from a temp file, due to locks on originals
>> !_GETFILES! ECHO.%HOMEDRIVE%%HOMEPATH%\DESKTOP\__MBAMSERVICE-LOGS

>> !_GETFILES! ECHO.%ProgramData%\Malwarebytes\MBAMService\aeDetections
>> !_GETFILES! ECHO.%ProgramData%\Malwarebytes\MBAMService\arwDetections
>> !_GETFILES! ECHO.%ProgramData%\Malwarebytes\MBAMService\arwDetections
>> !_GETFILES! ECHO.%ProgramData%\Malwarebytes\MBAMService\MwacDetections
>> !_GETFILES! ECHO.%ProgramData%\Malwarebytes\MBAMService\RtpDetections
>> !_GETFILES! ECHO.%ProgramData%\Malwarebytes\MBAMService\ScanResults
>> !_GETFILES! ECHO.%ProgramData%\Malwarebytes\MBAMService\config

>>  !_GETFILES! ECHO.# ******** D and D Tool - Bootstrapper                                                            
>> !_GETFILES! ECHO.%_logDirectory%\Malwarebytes_Endpoint_Agent_Bootstrapper_??????????????.log
>> !_GETFILES! ECHO.%_logDirectory%\Malwarebytes_Endpoint_Agent_and_.NET_system_prerequisites_installer_??????????????.log

>> !_GETFILES! ECHO.# ******** D and D Tool - MSI
>> !_GETFILES! ECHO.%_logDirectory%\Malwarebytes_Endpoint_Agent_Bootstrapper_??????????????_???_*.log
>> !_GETFILES! ECHO.%_logDirectory%\Malwarebytes_Endpoint_Agent_and_.NET_system_prerequisites_installer_??????????????_???_*.log

>> !_GETFILES! ECHO.# ******** MSI in %WINDIR%
>> !_GETFILES! ECHO.%Windir%\Temp\MSI?????.log
>> !_GETFILES! ECHO.%Windir%\Temp\MSI?????.log



GOTO :EOF

::-----------------------------------------------------------------------------
:MAKECAB
::-----------------------------------------------------------------------------
ECHO Instructions for CAB compress are written into !_DIRECTIVE!
MAKECAB /V1 /F !_DIRECTIVE! 
GOTO :EOF

::-------- CLEANUP -----------------------------------
:CLEANUP
DEL /Q !_DIRECTIVE!                                              > nul 2>&1
DEL /Q !_GETFILES!                                               > nul 2>&1
DEL !HOMEDRIVE!!HOMEPATH!\DESKTOP\MBGetLogsRpt.txt               > nul 2>&1
DEL !HOMEDRIVE!!HOMEPATH!\DESKTOP\MBGetLogs.inf                  > nul 2>&1
DEL /S /Q "!HOMEDRIVE!!HOMEPATH!\DESKTOP\__MBAMSERVICE-LOGS\*.*" > nul 2>&1
DEL /S /Q "!HOMEDRIVE!!HOMEPATH!\DESKTOP\__MBAGENT-LOGS\*.*"     > nul 2>&1
RMDIR "!HOMEDRIVE!!HOMEPATH!\DESKTOP\__MBAMSERVICE-LOGS"         > nul 2>&1
RMDIR "!HOMEDRIVE!!HOMEPATH!\DESKTOP\__MBAGENT-LOGS"             > nul 2>&1
GOTO :EOF




:END
