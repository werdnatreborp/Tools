ECHO OFF
ECHO.-----------------------------------------------------------------
ECHO. Skim MBAMService.log
ECHO.-----------------------------------------------------------------
SETLOCAL EnableDelayedExpansion
SET/P INPUTSTR=Input a string to find:

::---------------------------------------------------------------------
:: List logfile if in current directory, otherwise pickup from default
::---------------------------------------------------------------------
IF EXIST MBAMService.log (
   SET MBLOG=.\MBAMService.log
   SET MBLOG
) ELSE (
   SET MBLOG=%ProgramData\Malwarebytes\MBAMService\logs\MBAMService.log
   SET MBLOG
)
   
ECHO.---------------------------------------
ECHO.Rules Updates
ECHO.---------------------------------------
SET FINDSTR=Successfully updated DB
CALL :FINDSTR

ECHO.---------------------------------------
ECHO.STARTS
ECHO.---------------------------------------
SET FINDSTR=Started
CALL :FINDSTR

ECHO.---------------------------------------
ECHO.STOPS
ECHO.---------------------------------------
SET FINDSTR=Stopped
CALL :FINDSTR

ECHO.---------------------------------------
ECHO.SCAN STARTS
ECHO.---------------------------------------
SET FINDSTR=Starting a threat scan
CALL :FINDSTR

ECHO.---------------------------------------
ECHO.SCAN COMPLETES
ECHO.---------------------------------------
SET FINDSTR=Scan completed
CALL :FINDSTR

ECHO.---------------------------------------
ECHO.Metadata
ECHO.---------------------------------------
SET FINDSTR=metadata
CALL :FINDSTR

ECHO.---------------------------------------
ECHO.INPUTSTRING
ECHO.---------------------------------------
SET FINDSTR=!INPUTSTR!
CALL :FINDSTR

GOTO :END

:FINDSTR
TYPE !MBLOG! | FIND /I "!FINDSTR!" > %homepath%\desktop\MBLog.txt
FOR /F "usebackq TOKENS=1-12*" %%a IN (`TYPE %homepath%\desktop\MBLog.txt`) DO (
  ECHO %%a %%c %%g %%l %%m 
)

GOTO :EOF

:end
PAUSE