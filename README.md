around-recipeml
===============

Repository of various recipes in [FormatData RecipeML](http://www.formatdata.com/recipeml/). It also provides non-binary tools around [RecipeML](http://www.formatdata.com/recipeml/) to generate recipes in [RecipeML](http://www.formatdata.com/recipeml/) from a common source in HTML or to generate ready to print XHTML recipes for instance.

## Directory structure

- data: Repository of recipes in various formats ordered by language and origin.
  - en, fr, pl... : Recipe language. 2-digit ISO code (ISO 3166-1 alpha-2).
    - scan, marmiton... : Recipe origin like scanned paper documents or website name.
      - aspx, html, img+txt, recipeml, xhtml... : Recipe format.
- src: Home made code.
  - css: CSS used by generated XHTML recipes.
  - script: Windows Shell scripts to 
    1. Dowload a list of files referenced by their URL in a single file.
    2. Convert HTML files in a directory to XHTML into another directory.
    3. Transform XML files in a directory into another directory with an XSLT.
  - xml_template: Templates for manual digitisation of recipes.
  - xsd_dtd_schema: XSD and DTD for validation of recipes.
  - xslt: XSLT around [RecipeML](http://www.formatdata.com/recipeml/)

## Binaries

In order to fetch and manipulate HTML, XHTML or [RecipeML](http://www.formatdata.com/recipeml/) files, scripts use the following binaries:

- [cURL](http://curl.haxx.se/download.html) ([on github](https://github.com/bagder/curl))
- [html2xhtml](http://www.it.uc3m.es/jaf/html2xhtml/) ([on github](https://github.com/jfisteus/html2xhtml))
- [Saxon HE](http://saxon.sourceforge.net/#F9.6HE) ([Saxon CE on github](https://github.com/Saxonica/Saxon-CE))
- [Microsoft® XSL processor](http://www.microsoft.com/en-us/download/details.aspx?id=21714)
