@echo off
set html2xhtml=..\..\bin\html2xhtml-1.1.2\html2xhtml.exe
rem do not forget the trailing directory separator
set recipehtmlindir=.\aspx\
rem do not forget the trailing directory separator
set recipexhtmloutdir=.\xhtml\
set recipexhtmloutfileext=.xhtml

echo Processing files in %recipehtmlindir%
for /f "delims=" %%i in ('dir /b /s %recipehtmlindir%') do call :CONVERT_RECIPE "%%i"
echo End of processing
goto :EOF

:CONVERT_RECIPE
	for %%A in (%1) do set recipefilename=%%~nA
	if not "%recipefilename%" == "" (
		echo %html2xhtml% --ics UTF-8 --ocs UTF-8 -l 512 %1 -o "%recipexhtmloutdir%%recipefilename%%recipexhtmloutfileext%"
		%html2xhtml% --ics UTF-8 --ocs UTF-8 -l 512 %1 -o "%recipexhtmloutdir%%recipefilename%%recipexhtmloutfileext%"
	) else (
		echo Skip convertion from HTML to XHTML of %1
	)
	goto :EOF