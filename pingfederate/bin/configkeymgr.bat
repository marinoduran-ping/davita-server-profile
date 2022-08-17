@echo off

@if not "%ECHO%" == ""  echo %ECHO%
@if "%OS%" == "Windows_NT"  setlocal

set DIRNAME=.\
if "%OS%" == "Windows_NT" set DIRNAME=%~dp0

set PF_ROOT=%DIRNAME%..

set DEFAULT_DIR=%PF_ROOT%\server\default
set SERVER_LIB=%DEFAULT_DIR%\lib

set CLASSPATH=%PF_ROOT%\bin\pf-consoleutils.jar
set CLASSPATH=%CLASSPATH%;%SERVER_LIB%\*
set CLASSPATH=%CLASSPATH%;%PF_ROOT%\lib\*
set CLASSPATH=%CLASSPATH%;%PF_ROOT%\deploy\*
set CLASSPATH=%CLASSPATH%;%DEFAULT_DIR%\conf\"

if "%JAVA_HOME%" == "" (
	set JAVA=java
	echo JAVA_HOME is not set.  Unexpected results may occur.
	echo Set JAVA_HOME to the directory of your local JDK to avoid this message.
) ELSE (
	set JAVA=%JAVA_HOME%\bin\java
)

set RUN_PROPERTIES=
if exist "%PF_ROOT%\bin\run.properties" (
	set RUN_PROPERTIES=%PF_ROOT%\bin\run.properties
) ELSE (
	echo Missing %PF_ROOT%\bin\run.properties; using defaults.
)

"%JAVA%" -Dpingfederate.log.dir="%PF_ROOT%\log" -Dlog4j.configurationFile="file:///%PF_ROOT%\bin\configkeymgr.log4j2.xml" -Drun.properties="%RUN_PROPERTIES%" -Dpf.home="%PF_ROOT%" -Dpf.server.default.dir="%DEFAULT_DIR%" -classpath "%CLASSPATH%" com.pingidentity.console.configkeymgr.ConfigKeyManager %*