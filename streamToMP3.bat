::
:: Audio stream
:: Author: Frédéric Gervais
:: Date: 2017/11/12
::


@echo off
@SETLOCAL enableextensions enabledelayedexpansion

set IP_Addr4=


IF NOT exist "C:\Program Files (x86)\Screen Capturer Recorder\unins000.exe" call :install

echo: Starting the stream ...
start /B .\vlc\vlc dshow:// :dshow-adev=virtual-audio-capturer :sout=#transcode{vcodec=none,acodec=mp3,ab=128,channels=5.1,samplerate=44100}:http{dst=:8080/stream.mp3} :sout-keep -I dummy --dummy-quiet
echo:
for /F "tokens=1 delims={, skip=1" %%A in ('wmic NICCONFIG WHERE IPEnabled^=true GET IPAddress') do (
    set IP_Addr4=%%A & goto :endLOOP
)
:endLOOP
set IP_Addr4=%IP_Addr4:~1,-2%
echo:
echo:*************************************
echo:
echo: Stream available at:
echo: http://%IP_Addr4%:8080/stream.mp3
echo:
echo:*************************************
echo:
echo: Press a key to close the stream
pause>nul

taskkill /f /im vlc.exe
GOTO:EOF



:install
    echo: Installing the virtual-video-capturer
    cmd /c install.exe /verysilent
GOTO:EOF
