<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xsl fn xhtml">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"
	doctype-public="-//FormatData//DTD RecipeML 0.5//EN" doctype-system="http://www.formatdata.com/recipeml/recipeml.dtd" />

	<xsl:strip-space elements="*"/>

	<!-- Create an empty xml, if the data node m_content_recette_main cannot be found -->
	<xsl:template match="/">
		<xsl:apply-templates select="//xhtml:div[@id='af_tdContenu']/xhtml:div[fn:contains(@class, 'hrecipe')]/xhtml:div[@class = 'm_bloc_cadre']/xhtml:div[@class = 'm_content_recette_cadre']/xhtml:div[@class = 'm_content_recette_main']" />
	</xsl:template>

	<xsl:template match="//xhtml:div[@class = 'm_content_recette_main']">
		<recipeml version="0.5" xml:lang="fr">

			<head>
				<title><xsl:value-of select="../../xhtml:h1" /></title>

				<source>http://www.marmiton.org/</source>

				<xsl:apply-templates select="./xhtml:p[@class = 'm_content_recette_ingredients']/*[1]" mode="yield" />

				<xsl:apply-templates select="./xhtml:p[@class = 'm_content_recette_info']" mode="preptime" />
			</head>

			<ingredients>
				<xsl:apply-templates select="./xhtml:p[@class = 'm_content_recette_ingredients']" mode="ingredients" />
			</ingredients>

			<directions>
				<xsl:apply-templates select="./xhtml:div[@class = 'm_content_recette_todo']" mode="directions" />
			</directions>
		</recipeml>
	</xsl:template>

	<!-- recipeml/head/yield -->
	<xsl:template match="xhtml:p[@class = 'm_content_recette_ingredients']/*" mode="yield">
		<xsl:variable name="yield-tokens" select="fn:tokenize(., '\s+')" />
		<xsl:variable name="yield-token-idx-for" select="fn:index-of($yield-tokens, '(pour')" />
		<yield>
			<qty><xsl:value-of select="fn:subsequence($yield-tokens, $yield-token-idx-for + 1, 1)" /></qty>
			<unit><xsl:value-of select="fn:replace(fn:subsequence($yield-tokens, $yield-token-idx-for + 2, 1), '\)', '')" /></unit>
		</yield>
	</xsl:template>
	
	<!-- recipeml/head/preptime[all] -->
	<xsl:template match="xhtml:p[@class = 'm_content_recette_info']" mode="preptime">
		<xsl:call-template name="split-html-line">
			<xsl:with-param name="content" select="." />
			<xsl:with-param name="line-template" select="'extract-preparation-time'" />
		</xsl:call-template>
	</xsl:template>

	<!-- Convert a HTML line representing time info in Marmiton's recipe into corresponding RecipeML node
		recipeml/head/preptime[one by one] -->
	<xsl:template name="extract-preparation-time">
		<xsl:param name="content-line" />
		<xsl:param name="line-index" />

		<xsl:variable name="time" select="$content-line/self::xhtml:span[@class != 'value-title'] | $content-line/child::xhtml:span[@class != 'value-title']" />
		
		<preptime>
			<xsl:attribute name="type">
				<xsl:call-template name="convert-preparation-time-name">
					<xsl:with-param name="marmiton-name" select="$time/@class" />
				</xsl:call-template>
			</xsl:attribute>
			
			<time>
					<qty><xsl:value-of select="normalize-space($time)" /></qty>
					<timeunit><xsl:value-of select="normalize-space($time/following-sibling::text()[1])" /></timeunit>
			</time>
		</preptime>
	</xsl:template>

	<!-- map values from Marmiton's time class to RecipeML common values -->
	<xsl:template name="convert-preparation-time-name">
		<xsl:param name="marmiton-name" />
		<xsl:choose>
			<xsl:when test="$marmiton-name = 'preptime'">preparation</xsl:when>
			<xsl:when test="$marmiton-name = 'cooktime'">cooking</xsl:when>
			<xsl:when test="$marmiton-name = 'cooltime'">cooling</xsl:when>
			<!--xsl:when test="$marmiton-name = ''"></xsl:when-->
			<xsl:otherwise>
				<xsl:comment>Unable to convert preparation time name <xsl:value-of select="$marmiton-name" /></xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- recipeml/ingredients -->
	<xsl:template match="xhtml:p[@class = 'm_content_recette_ingredients']" mode="ingredients">
			<xsl:call-template name="split-html-line">
				<xsl:with-param name="content" select="." />
				<xsl:with-param name="line-template" select="'extract-ingredients'" />
			</xsl:call-template>
	</xsl:template>

	<!-- recipeml/ingredients/ing -->
	<xsl:template name="extract-ingredients">
		<xsl:param name="content-line" />
		<xsl:param name="line-index" />

		<!-- ensure the line have some non-blank content -->
		<xsl:if test="fn:string-length(fn:normalize-space(fn:string-join($content-line, ''))) > 0" >
			<ing>
				<!-- filter the first node of the first line, since it is about a title -->
				<xsl:choose>
					<xsl:when test="$line-index = 1" >
						<amt>
								<qty>0</qty>
								<unit>g</unit>
						</amt>
						<item><xsl:value-of select="normalize-space(fn:replace(fn:string-join($content-line[position() != 1], ' '), '^\s*-\s+', ''))" /></item>
					</xsl:when>
					<xsl:otherwise>
						<amt>
								<qty>0</qty>
								<unit>g</unit>
						</amt>
						<item><xsl:value-of select="fn:replace(fn:string-join($content-line, ' '), '^\s*-\s+', '')" /></item>
					</xsl:otherwise>
				</xsl:choose>
			</ing>
		</xsl:if>
	</xsl:template>

	<!-- recipeml/directions -->
	<xsl:template match="xhtml:div[@class = 'm_content_recette_todo']" mode="directions">
		<xsl:call-template name="split-html-line">
			<xsl:with-param name="content" select="." />
			<xsl:with-param name="line-template" select="'extract-directions'" />
		</xsl:call-template>
	</xsl:template>

	<!-- recipeml/directions/step -->
	<xsl:template name="extract-directions">
		<xsl:param name="content-line" />
		<xsl:param name="line-index" />

		<!-- ensure the line have some non-blank content -->
		<xsl:if test="fn:string-length(fn:normalize-space(fn:string-join($content-line, ''))) > 0" >
			<!-- skip h4 containing "title" and div containing "notes" -->
			<xsl:if test="fn:empty($content-line/(self::xhtml:h4 | self::xhtml:div))">
				<step><xsl:value-of select="$content-line" /></step>
			</xsl:if>
		</xsl:if>
	</xsl:template>

		<!--
		  -
			- utility methods
			-
			-->

	<!-- call template "line-template" on each node-set from "content" separeted by a br tag -->
	<xsl:template name="split-html-line">
		<xsl:param name="content" />
		<xsl:param name="line-template" />
		<xsl:param name="line-index" select="1" />
		<xsl:choose>
			<xsl:when test="count($content//xhtml:br) > 0">
				<xsl:call-template name="process-line-according-line-template">
					<xsl:with-param name="content-line" select="$content//xhtml:br[1]/(preceding-sibling::text() | preceding-sibling::node())" />
					<xsl:with-param name="line-template" select="$line-template"/>
					<xsl:with-param name="line-index" select="$line-index"/>
				</xsl:call-template>

				<xsl:call-template name="split-html-line">
					<xsl:with-param name="content">
						<xsl:copy-of select="$content//xhtml:br[1]/(following-sibling::text() | following-sibling::node())" />
					</xsl:with-param>
					<xsl:with-param name="line-template" select="$line-template"/>
					<xsl:with-param name="line-index" select="$line-index + 1"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:call-template name="process-line-according-line-template">
					<xsl:with-param name="content-line" select="$content" />
					<xsl:with-param name="line-template" select="$line-template"/>
					<xsl:with-param name="line-index" select="$line-index"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- call the template associated to "line-template" on node-set "content-line".
		it work around a technical limitation : call-template name must be a QName.
		it lists all values allowed for "line-template".
		-->
	<xsl:template name="process-line-according-line-template">
		<xsl:param name="content-line" />
		<xsl:param name="line-template" />
		<xsl:param name="line-index" />
		<xsl:choose>
			<xsl:when test="$line-template = 'display-my-line'">
				<xsl:call-template name='display-my-line'>
					<xsl:with-param name="content-line" select="$content-line" />
					<xsl:with-param name="line-index" select="$line-index" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$line-template = 'extract-preparation-time'">
				<xsl:call-template name='extract-preparation-time'>
					<xsl:with-param name="content-line" select="$content-line" />
					<xsl:with-param name="line-index" select="$line-index" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$line-template = 'extract-ingredients'">
				<xsl:call-template name='extract-ingredients'>
					<xsl:with-param name="content-line" select="$content-line" />
					<xsl:with-param name="line-index" select="$line-index" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$line-template = 'extract-directions'">
				<xsl:call-template name='extract-directions'>
					<xsl:with-param name="content-line" select="$content-line" />
					<xsl:with-param name="line-index" select="$line-index" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>Unable to find template <xsl:value-of select="$line-template" /> to process <xsl:copy-of select="$content-line" />.</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- displays a node-set between lines of dashes -->
	<xsl:template name="display-my-line">
		<xsl:param name="content-line" />
		<xsl:param name="line-index" />
		-- line <xsl:value-of select="$line-index" /> -----------------------------------
		<xsl:copy-of select="$content-line" />
		---------------------------------------------
	</xsl:template>
	
</xsl:stylesheet>
