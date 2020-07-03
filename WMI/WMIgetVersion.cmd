echo off
REM FOR /F "tokens=2 delims==" %%I in ('"wmic datafile where^(name^="C:\\Program Files (x86)\\Common Files\\Company\\Product\\Version12\\Product.exe" get version /format:list"') DO (SET "RESULT=%%I")
ECHO %RESULT%


wmic datafile where name='C:\\Program Files\\Malwarebytes\\Anti-Malware\\MBAMService.exe' get version /format:list
rem "C:\Program Files\Malwarebytes\Anti-Malware\MBAMService.exe"


wmic datafile where name='C:\\Program Files\\Malwarebytes\\Anti-Malware\\SDK\\MBAM.SYS' get version /format:list
rem "C:\Program Files\Malwarebytes\Anti-Malware\RTPController.dll"


wmic datafile where "name LIKE 'C:\\Program Files\\Malwarebytes\\Anti-Malware\\SDK\\*.*'" get version /format:list
rem "C:\Program Files\Malwarebytes\Anti-Malware\RTPController.dll"



pause