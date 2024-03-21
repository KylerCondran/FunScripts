@ECHO OFF
REM Program: Log Archiver - Date: 01/17/2013 
REM Author: Kyler Condran

REM Calculate the numbers of the Day/Month/Year
FOR /F "tokens=2-4 delims=/-/ " %%A IN ("%date%") DO (
SET cwMonth=%%A
SET cwDay=%%B
SET cwYear=%%C
)

REM Find out what day of the week it is.
FOR /F %%D IN ('date /t') DO SET DAY=%%D

REM Wait 20 minutes before executing this part of the script.
REM The script must be started 10 minutes before midnight, to get current day/date.
REM After 20 minute wait, it is the next day, and script does its actual work.
ECHO Log Archiver Script Starting in 20 minutes.
ECHO Do Not Close This Window Or Press Any Key.
timeout 1200

REM This part compresses the file in an archive then deletes the original.
"C:\Program Files\WinRAR\rar.exe" a -ep "C:\Program Files\Logs\Syslog-%DAY%-%cwMonth%-%cwDay%-%cwYear%.rar" "C:\Program Files\Logs\Syslog%DAY%.txt"
DEL "C:\Program Files\Logs\Syslog%DAY%.txt"

forfiles /p "C:\Program Files\Logs" /s /m *.rar /d -14 /c "cmd /c DEL @PATH"
ECHO Script Completed.
timeout 10