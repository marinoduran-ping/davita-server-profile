@echo off

@if not "%ECHO%" == ""  echo %ECHO%
@if "%OS%" == "Windows_NT"  setlocal

set DIRNAME=.\
if "%OS%" == "Windows_NT" set DIRNAME=%~dp0

set ROOT=%DIRNAME%..
set ROOT_LIB=%ROOT%\lib
set DEFAULT_DIR=%ROOT%\server\default

REM Read an optional running configuration file
@if ["%RUN_CONF%"] == [""] (
    set RUN_CONF=%DIRNAME%\conf.bat
)
@if exist "%RUN_CONF%" (
    call "%RUN_CONF%"
)


set PASSWORD_FILE=%ROOT%\server\default\data\hsmpasswd.txt

set CLASSPATH=%ROOT_LIB%\*;%DIRNAME%\*;%DEFAULT_DIR%\lib\*;%DEFAULT_DIR%\conf\"

if "%JAVA_HOME%" == "" (
	set JAVA=java
	echo JAVA_HOME is not set.  Unexpected results may occur.
	echo Set JAVA_HOME to the directory of your local JDK to avoid this message.
) ELSE (
	set JAVA=%JAVA_HOME%\bin\java
)

"%JAVA%" -Dlog4j.configurationFile="file:///%DIRNAME%\hsmpass.log4j2.xml" -Dpf.server.default.dir="%DEFAULT_DIR%" -classpath "%CLASSPATH%" -Dpassword.file="%PASSWORD_FILE%" com.pingidentity.console.PasswordChanger HSM %*

