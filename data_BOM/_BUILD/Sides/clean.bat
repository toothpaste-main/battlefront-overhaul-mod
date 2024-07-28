@echo off
setlocal enabledelayedexpansion

set MUNGE_SIDE_DIRS=
if "%MUNGE_PLATFORM%"=="" set MUNGE_PLATFORM=PC

REM see if any of the parameters specify a platform, if so remove it
for %%A in (%*) do ( 
  if /i "%%A"=="PC" ( 
	set MUNGE_PLATFORM=PC
  ) else if /i "%%A"=="PS2" (
	set MUNGE_PLATFORM=PS2
  ) else if /i "%%A"=="XBOX" (
	set MUNGE_PLATFORM=XBOX
  ) else (
	set MUNGE_SIDE_DIRS=%%A !MUNGE_SIDE_DIRS!
  )
)

REM see if NOTHING was specified then just exit the script
set FOR_PARAMETER=
for %%A in (%*) do ( 
  if /i "%%A"=="NOTHING" ( 
    goto END 
  ) else if /i "%%A"=="EVERYTHING" (
	set MUNGE_SIDE_DIRS=*
	set FOR_PARAMETER=/D
  ) else if /i "%%A"=="GCW" (
  	set MUNGE_SIDE_DIRS=ALL IMP
  ) else if /i "%%A"=="CW" (
  	set MUNGE_SIDE_DIRS=CIS REP
  )
)

REM for each subdirectory
for %FOR_PARAMETER% %%A in (%MUNGE_SIDE_DIRS%) do (

	REM check to see if %%A is a directory
	set IS_DIRECTORY=%%~aA
	if /i "!IS_DIRECTORY:~0,1!" NEQ "d" ( 
		echo "
		echo "Error (Invalid Parameter): %%A
		echo "
		goto PRINT_USAGE_AND_EXIT
	)

	REM it is valid directory so clean it
	echo Sides\%%A\clean %MUNGE_PLATFORM%
	cd %%A
	call clean.bat %MUNGE_PLATFORM%
	cd ..
)

goto END

REM   --------------  PRINT SCRIPT USAGE AND EXIT  -----------------------
:PRINT_USAGE_AND_EXIT
echo "Usage: clean [PC|PS2|XBOX] [<side1> <side2> ...]

:END

endlocal

