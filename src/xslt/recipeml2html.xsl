<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xsl">

	<!--+ RecipeML is the default namespace in input, since it has no namespace.
	    + XHTML is the default prefix in output to be compatible with browsers and CSS
	    +-->
	<xsl:namespace-alias stylesheet-prefix="xhtml" result-prefix="#default" />
	
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

  <xsl:strip-space elements="*"/>

	<xsl:param name="lang">en</xsl:param>

	<!-- XML/HTML recipe tree -->
  <xsl:template match="/recipeml">
    <xhtml:html>
      <xhtml:head>
        <xhtml:title><xsl:value-of select="//recipe/head/title" /></xhtml:title>
        <xhtml:link rel="stylesheet" type="text/css" href="../../../../src/css/recipe-html.css" />
      </xhtml:head>

      <xhtml:body>
        <xsl:apply-templates select="./recipe"/>
      </xhtml:body>

    </xhtml:html>
  </xsl:template>

  <xsl:template match="recipe">
    <xhtml:div class="recipe">
      <xhtml:h1 class="title"><xsl:value-of select="./head/title" /></xhtml:h1>

      <xsl:apply-templates select="./head" />
			<xsl:apply-templates select="./equipment" />

      <xsl:apply-templates select="./ingredients">
        <xsl:with-param name="yield" select="./head/yield" />
      </xsl:apply-templates>

      <xsl:apply-templates select="./directions" />
    </xhtml:div>
  </xsl:template>

  <xsl:template match="head">
		<xsl:if test="./preptime">
	    <xhtml:div class="preptime">
	      <xhtml:h4><xsl:call-template name="preptime" /></xhtml:h4>
	      <xhtml:ul>
	        <xsl:for-each select="./preptime">
	          <xhtml:li>
	            <xsl:apply-templates select="@type" /><xsl:text> : </xsl:text>
							<xsl:choose>
									<xsl:when test="count(./time) > 1">
											<xsl:for-each select="./*">
													<xsl:apply-templates select="." />
											</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="./time" />
									</xsl:otherwise>
							</xsl:choose>
	          </xhtml:li>
	        </xsl:for-each>
	      </xhtml:ul>
	    </xhtml:div>
		</xsl:if>
  </xsl:template>

	<xsl:template match="time">
			<xsl:call-template name="range_or_qty">
				<xsl:with-param name="parent" select="." />
			</xsl:call-template>
			<xsl:text> </xsl:text>
			<xsl:value-of select="./timeunit" />
	</xsl:template>

	<xsl:template match="sep">
			<xsl:text> </xsl:text>
			<xsl:value-of select="." />
			<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="equipment">
	  <xhtml:div class="equipment">
      <xhtml:h4><xsl:call-template name="equipment" /></xhtml:h4>
      <xhtml:ul>
			  <xsl:for-each select="./tool">
				  <xhtml:li>
						<xsl:call-template name="range_or_qty">
							<xsl:with-param name="parent" select="." />
						</xsl:call-template>
						<xsl:text> </xsl:text>
					  <xsl:value-of select="./brandname/mfr" />
						<xsl:text> </xsl:text>
					  <xsl:value-of select="./brandname/product" />
					</xhtml:li>
				</xsl:for-each>
			</xhtml:ul>
		</xhtml:div>
  </xsl:template>
  
  <xsl:template match="ingredients">
    <xsl:param name="yield" />
    <xhtml:div class="ingredients">
      <xhtml:h3>
				<xsl:call-template name="ingredients" />
				<xsl:if test="$yield">
					<xsl:call-template name="for" />
					<xsl:call-template name="range_or_qty">
						<xsl:with-param name="parent" select="$yield" />
					</xsl:call-template>
					<xsl:text> </xsl:text><xsl:value-of select="$yield/unit" />
				</xsl:if>
			</xhtml:h3>
			<xsl:choose>
				<xsl:when test="./ing-div">
					<xsl:for-each select="./ing-div">
						<xhtml:div class="ing-div">
							<h4><xsl:value-of select="./title" /></h4>
				      <xhtml:ul>
				        <xsl:for-each select="./ing">
									<xsl:apply-templates select="." />
				        </xsl:for-each>
				      </xhtml:ul>
						</xhtml:div>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="./ing">
		      <xhtml:ul>
		        <xsl:for-each select="./ing">
							<xsl:apply-templates select="." />
		        </xsl:for-each>
		      </xhtml:ul>
				</xsl:when>
			</xsl:choose>
    </xhtml:div>
  </xsl:template>
	
	<xsl:template match="ing">
		<xhtml:li>
			<xsl:call-template name="range_or_qty">
				<xsl:with-param name="parent" select="./amt" />
			</xsl:call-template>
			<xsl:text> </xsl:text><xsl:value-of select="./amt/unit" />
			<xsl:text> </xsl:text><xsl:value-of select="./item" />
		</xhtml:li>
	</xsl:template>

	<xsl:template name="range_or_qty">
    <xsl:param name="parent" />

		<xsl:choose>
			<xsl:when test="$parent/qty">
				<xsl:value-of select="$parent/qty"/>
			</xsl:when>
			<xsl:when test="$parent/range">
				<xsl:value-of select="$parent/range/q1"/>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="$parent/range/sep">
						<xsl:value-of select="$parent/range/sep" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$parent/range/q2"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

  <xsl:template match="directions">
    <xhtml:div class="directions">
      <xhtml:h3><xsl:call-template name="directions" /></xhtml:h3>
			<xsl:choose>
				<xsl:when test="./dir-div">
					<xsl:for-each select="./dir-div">
						<xhtml:div class="dir-div">
							<xhtml:h4><xsl:value-of select="./title" /></xhtml:h4>
				      <xhtml:ol>
				        <xsl:for-each select="./step">
									<xsl:apply-templates select="." />
				        </xsl:for-each>
				      </xhtml:ol>
						</xhtml:div>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="step">
		      <xhtml:ol>
		        <xsl:for-each select="./step">
							<xsl:apply-templates select="." />
		        </xsl:for-each>
		      </xhtml:ol>
				</xsl:when>
			</xsl:choose>
    </xhtml:div>
  </xsl:template>

  <xsl:template match="step">
		<xhtml:li class="step">
			<xsl:value-of select="." />
		</xhtml:li>
  </xsl:template>
	
	<!-- Translations -->

	<xsl:template name="ingredients">
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				Ingredients
			</xsl:when>
			<xsl:when test="$lang = 'fr'">
				Ingrédients
			</xsl:when>
			<xsl:when test="$lang = 'pl'">
				Składniki
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="for">
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				for
			</xsl:when>
			<xsl:when test="$lang = 'fr'">
				pour
			</xsl:when>
			<xsl:when test="$lang = 'pl'">
				dla
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="directions">
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				Directions
			</xsl:when>
			<xsl:when test="$lang = 'fr'">
				Instructions
			</xsl:when>
			<xsl:when test="$lang = 'pl'">
				Wykonanie
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="equipment">
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				Specific equipment(s)
			</xsl:when>
			<xsl:when test="$lang = 'fr'">
				Instrument(s) particulier(s)
			</xsl:when>
			<xsl:when test="$lang = 'pl'">
				Sprzęt(y)
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="preptime">
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				Preparation time
			</xsl:when>
			<xsl:when test="$lang = 'fr'">
				Durée de preparation
			</xsl:when>
			<xsl:when test="$lang = 'pl'">
				Czas przygotowanie
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@type">
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				<xsl:choose>
					<xsl:when test=". = 'preparation'">
						Preparation
					</xsl:when>
					<xsl:when test=". = 'cooking'">
						Cooking
					</xsl:when>
					<xsl:when test=". = 'cooling'">
						Cooling
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang = 'fr'">
				<xsl:choose>
					<xsl:when test=". = 'preparation'">
						Préparation
					</xsl:when>
					<xsl:when test=". = 'cooking'">
						Cuisson
					</xsl:when>
					<xsl:when test=". = 'cooling'">
						Refroidissement
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang = 'pl'">
				<xsl:choose>
					<xsl:when test=". = 'preparation'">
						Przygotowanie
					</xsl:when>
					<xsl:when test=". = 'cooking'">
						Gotowanie
					</xsl:when>
					<xsl:when test=". = 'cooling'">
						Chłodzenie
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>