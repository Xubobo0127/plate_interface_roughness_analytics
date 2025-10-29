REM 批处理获取文件目录和文件名
@echo off
for /f "delims=" %%i in ('dir /b/s *.*') do echo %%i >> list

REM REM REM 批处理获取文件名
REM @echo off
REM for /f "delims=" %%i in ('dir /b/a-d/oN *.*') do echo %%~ni >> list.txt

REM REM REM 批处理获取文件名和后缀
REM @echo off
REM for /f "delims=" %%i in ('dir /b/a-d/oN *.*') do echo %%i >> list.txt

REM REM 批处理获取文件名和后缀
REM dir *.* /B > list.txt