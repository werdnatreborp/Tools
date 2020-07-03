ECHO OFF
ECHO.-----------------------------------------------------------------
ECHO. Skim ScanResults and xxxDetections - JSON logs
ECHO. A. Probert
ECHO. Version 1.0
ECHO.-----------------------------------------------------------------
CALL :LISTFILES ScanResults
CALL :LISTFILES AeDetections
CALL :LISTFILES ArwDetections
CALL :LISTFILES RtpDetections   
GOTO :END

:LISTFILES
FOR /F "usebackq" %%a IN (`DIR /B %ProgramData%\Malwarebytes\MBAMService\%1\????????-????-????-????-????????????.json`) DO (
   ECHO.
   ECHO.--------------------------------------------------------------------------
   ECHO.%1
   ECHO.--------------------------------------------------------------------------
   ECHO %%a
   TYPE %ProgramData%\Malwarebytes\MBAMService\%1\%%a | FIND/I "threatName"
   TYPE %ProgramData%\Malwarebytes\MBAMService\%1\%%a | FIND/I "Object"
   TYPE %ProgramData%\Malwarebytes\MBAMService\%1\%%a | FIND/I "threatsDetected"
)

GOTO:EOF

:END
PAUSE