@ECHO OFF
C:
CD\
CLS

:Menu
CLS

ECHO 1.  Lookup Ethernet Adapter MAC Address
ECHO 2.  Lookup Wireless Adapter MAC Address
ECHO 3.  Cache Windows Credentials ForUser
ECHO ------------ OR ---------------
ECHO  PRESS 'Q' or 'q' TO QUIT
ECHO.

SET INPUT=
SET /P INPUT=Please select a number:

IF /I '%INPUT%'=='1' GOTO Find_Ethernet_MAC_ADDRESS
IF /I '%INPUT%'=='2' GOTO Find_Wireless_MAC_ADDRESS
IF /I '%INPUT%'=='3' GOTO Run_command_as
IF /I '%INPUT%'=='Q' GOTO EOF
IF /I '%INPUT%'=='q' GOTO EOF

CLS

GOTO Menu

:Find_Ethernet_MAC_ADDRESS
for /f "tokens=2,3 delims=," %%a in ('"getmac /v /fo csv | findstr /C:"Local Area Connection""') do echo %%a: %%b
GOTO EOF

:Find_Wireless_MAC_ADDRESS
ECHO Ethernet Adapter(s) List
for /f "tokens=2,3 delims=," %%a in ('"getmac /v /fo csv | findstr /C:"Wireless Area Connection""') do echo %%a: %%b
GOTO EOF

:Run_command_as
SET USR=
SET /P USR=Please enter you U-M uniqname:

ECHO Windows has cached your U-M uniqname credentials for %USR%. Please log off and log on with U-M uniqname: %USR% on this machine. > %WINDIR%\TEMP\winBatchTools.txt
icacls %WINDIR%\TEMP\winBatchTools.txt /grant Everyone:f
REM CALL RUNAS /USER:UMROOT\%USR% "NOTEPAD.EXE %TEMP%\winBatchTools.txt"
CALL RUNAS /USER:UMROOT\%USR% "NOTEPAD.EXE %WINDIR%\TEMP\winBatchTools.txt"
GOTO EOF

:EOF
ECHO ====== PRESS ANY KEY TO EXIT ======
PAUSE > NUL
EXIT