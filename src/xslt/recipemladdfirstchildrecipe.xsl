<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xsl fn xhtml">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"
	doctype-public="-//FormatData//DTD RecipeML 0.5//EN" doctype-system="http://www.formatdata.com/recipeml/recipeml.dtd" />

	<xsl:strip-space elements="*"/>

  <xsl:template match="/recipeml">
			<xsl:copy>
				<xsl:copy-of select="@*" />
				<recipe>
					<xsl:apply-templates select="node()"/>
				</recipe>
			</xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
