@echo off
rem CONFIG
set lang=fr
set recipeoutfileext=.xml

rem DATA
rem do not forget the trailing directory separator
set recipeindir=..\..\data\%lang%\marmiton\xhtml\
rem do not forget the trailing directory separator
set recipeoutdir=..\..\data\%lang%\marmiton\recipeml\
set recipexslt="..\xslt\marmiton2recipeml.xsl"
rem set recipexslt="..\xslt\recipeml2html.xsl"

rem PROCESSORS
rem enum accepting values SAXON, HTML2XHTML and MSXSL. Mind upper case.
set processorenum=SAXON
rem relative path to processor code (executable or jar file)
set msxsl="..\..\bin\xslt_transformer\msxsl.exe"
set html2xhtml=..\..\bin\html2xhtml-1.1.2\html2xhtml.exe
set saxon="..\..\bin\xslt_transformer\SaxonHE9-4-0-9J\saxon9he.jar"


echo Processing files in %recipeindir%
for /f "delims=" %%i in ('dir /b /s %recipeindir%*') do call :TRANSFORM_RECIPE "%%i"
echo End of processing
goto :EOF

:TRANSFORM_RECIPE
	set recipeinfilename=""
	for %%A in (%1) do set recipeinfilename=%%~nA
	for %%A in (%1) do set recipeinfileext=%%~xA
	if not "%recipeinfilename%" == "" (
		echo Transforming %recipeinfilename%%recipeinfileext%
		call :TRANSFORM_WITH_%processorenum% %1 %recipeoutdir%%recipeinfilename%%recipeoutfileext% %recipexslt% "%lang%"
	) else (
		echo Skip transformation of %1 - Wrong file name
	)
	goto :EOF

:TRANSFORM_WITH_HTML2XHTML
	%html2xhtml% --ics UTF-8 --ocs UTF-8 -l 512 %1 -o %2
	goto :EOF

:TRANSFORM_WITH_MSXSL
	%msxsl% %1 %3 -o %2 lang=%4
	goto :EOF

:TRANSFORM_WITH_SAXON
	echo -s:%1 -xsl:%3 -o:%2 lang=%4
	java -cp %saxon% net.sf.saxon.Transform -t -s:%1 -xsl:%3 -o:%2 lang=%4
	goto :EOF
