@echo off

@if not "%ECHO%" == ""  echo %ECHO%
@if "%OS%" == "Windows_NT"  setlocal

set DIRNAME=.\
if "%OS%" == "Windows_NT" set DIRNAME=%~dp0
set DIRNAME=%DIRNAME%..
set DEFAULT_DIR=%DIRNAME%\server\default

set RUN_PROPERTIES=
if exist "%DIRNAME%\bin\run.properties" (
	set RUN_PROPERTIES=%DIRNAME%\bin\run.properties
) ELSE (
	echo Missing %DIRNAME%\bin\run.properties; using defaults.
)

set CLASSPATH=%DIRNAME%\bin\pf-consoleutils.jar
set CLASSPATH=%CLASSPATH%;%DEFAULT_DIR%\lib\*
set CLASSPATH=%CLASSPATH%;%DEFAULT_DIR%\deploy\*
set CLASSPATH=%CLASSPATH%;%DEFAULT_DIR%\conf\"

if not exist log mkdir log

if "%JAVA_HOME%" == "" (
	set JAVA=java
	echo JAVA_HOME is not set.  Unexpected results may occur.
	echo Set JAVA_HOME to the directory of your local JDK to avoid this message.
) ELSE (
	set JAVA=%JAVA_HOME%\bin\java
)

"%JAVA%" -cp "%CLASSPATH%" -Dlog4j.configurationFile="file:///%DIRNAME%/bin/clusterkey.log4j2.xml" -Drun.properties="%RUN_PROPERTIES%" -Dpf.server.default.dir="%DEFAULT_DIR%" com.pingidentity.console.GenerateClusterKey %*

goto :eof
