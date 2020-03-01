@echo off
PUSHD %~dp0
set logfile=root.log
title Android 5.1 (UserDebug Version)Supersu takeover tool v160112 by xmanweb
echo Tool Description:
echo     This tool can takeover UserDebug ROOT to SuperSu.This batch currently applicable with UserDebug Version Android 5.1 only. After takeover by supersu, because su files have been replaced, your Android box CAN NOT OTA Update any more.If you want recover OTA Update Function,You must run the reverse batch file to undo the takeover. During the process of using this tool, Please observe the Xgimi display on TV,ROOT authorization window box may pops up, please give the authorization. 
echo *******************************************************
set /p ip=Please enter the IP address of Android box(WIFIADB required):
rem adb kill-server >nul 2>nul
echo *******************************************************
if "%ip%" == "" (
set /p=Start via usb data cable:<nul
adb start-server >nul 2>nul
) else (
set /p=Start via network:<nul
adb disconnect >nul 2>nul
ping %ip% -n 4 >nul 2>nul
adb connect %ip%  >nul 2>nul
ping %ip% -n 6 >nul 2>nul
)
adb devices >%logfile% 2>nul
adb shell echo "Connected!!!" 2>nul
if %ERRORLEVEL% NEQ 0 echo Connection ERROR!!! & echo Please Check the IP address / usb data cable is correct, and close any helper class software on your computer and adb.exe process! &goto end
echo Upload relevant files...
adb push .\Supersu\. /data/local/tmp/
adb shell chmod 777 /data/local/tmp/install-supersu.sh
echo Done!!!
set /p=Attempt to obtain ROOT authorization:<nul
set sucmd=
for /f %%i in ('adb shell "su -c busybox echo>/dev/null;echo $?"') do set sucmd=%%i
if "%sucmd%" == "0" (
echo Success!!!
) else (
echo Failed!!!
echo *******************************************************
echo This Failed appears,there are several reason possible:
echo 1.Your Android box does NOT get ROOTED
echo 2.In the pop up authorization window,you do not give an authorization
adb shell rm -rf /data/local/tmp/* >nul 2>nul
goto end
)
set /p=began to take over the ROOT program:<nul
adb shell "su -c /data/local/tmp/install-supersu.sh">>%logfile%
echo Done!!!
adb shell rm -rf /data/local/tmp/* >nul 2>nul
set /p=Rebooting Android box:<nul
if "%ip%" == "" (
adb reboot >nul 2>nul
) else ( 
start /min adb reboot
)
echo Done!!!
:end
echo *******************************************************
echo Press any key to exit ...
if "%ip%" == "" adb kill-server >nul 2>nul
pause > nul