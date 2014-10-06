@echo off
set recipeurllistinfile=..\..\data\fr\marmiton\recettes_marmiton_verifiees.txt
rem do not forget the trailing directory separator
set recipeoutdir=..\..\data\fr\marmiton\aspx\
set curl=..\..\bin\curl-7.38.0\bin\curl.exe

echo Downloading URLs in "%recipeurllistinfile%"
for /f "tokens=*" %%u in (%recipeurllistinfile%) do (
	rem could improve the test to check that it is about an URL
	if not "%%u" == "" (
		call :DOWNLOAD_RECIPE_FROM_URL "%%u"
	) else (
		echo Skip download of "%%u"
	)
)
echo End of processing
goto :EOF

:DOWNLOAD_RECIPE_FROM_URL
	for %%A in (%1) do set recipefile=%%~nxA
	echo Downloading %1
	%curl% %1 > "%recipeoutdir%%recipefile%"
	goto :EOF