REM �������ȡ�ļ�Ŀ¼���ļ���
@echo off
for /f "delims=" %%i in ('dir /b/s *.*') do echo %%i >> list

REM REM REM �������ȡ�ļ���
REM @echo off
REM for /f "delims=" %%i in ('dir /b/a-d/oN *.*') do echo %%~ni >> list.txt

REM REM REM �������ȡ�ļ����ͺ�׺
REM @echo off
REM for /f "delims=" %%i in ('dir /b/a-d/oN *.*') do echo %%i >> list.txt

REM REM �������ȡ�ļ����ͺ�׺
REM dir *.* /B > list.txt