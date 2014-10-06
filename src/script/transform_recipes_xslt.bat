@echo off
set lang=pl
rem do not forget the trailing directory separator
set recipedirxml=..\..\..\src\%lang%\xml\new\
rem do not forget the trailing directory separator
set recipedirhtml=..\..\..\src\%lang%\html\
set recipexslt="recipeml2html.xsl"

echo Processing *.xml in %recipedirxml%
for /f "delims=" %%i in ('dir /b /s %recipedirxml%*.xml') do call :TRANSFORM_RECIPE_AND_NAMES "%%i"
echo End of processing
goto :EOF

:TRANSFORM_RECIPE_AND_NAMES
	set recipefilename=""
	rem for /f "delims=" %%a in ("%1") do set "recipefilename=%%~na"
	for %%A in (%1) do set recipefilename=%%~nxA
	if not "%recipefilename%" == "" goto :TRANSFORM_RECIPE
	goto :EOF

:TRANSFORM_RECIPE
	set recipehtml="%recipedirhtml%%recipefilename%.html"
	echo msxsl %1 %recipexslt% -o %recipehtml% lang=%lang%
	msxsl %1 %recipexslt% -o %recipehtml% lang=%lang%
	set recipefile=""
	goto :EOF