<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:output method="html" encoding="UTF-8" indent="yes"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

  <xsl:strip-space elements="*"/>

	<xsl:param name="lang">en</xsl:param>

	<!-- XML/HTML recipe tree -->

  <xsl:template match="/recipeml">
    <html>
      <head>
        <title><xsl:value-of select="//recipe/head/title" /></title>
        <link rel="stylesheet" type="text/css" href="../../css/recipe-html.css" />
      </head>

      <body>
        <xsl:apply-templates select="./recipe"/>
      </body>

    </html>
  </xsl:template>

  <xsl:template match="recipe">
    <div class="recipe">
      <h1 class="title"><xsl:value-of select="./head/title" /></h1>

      <xsl:apply-templates select="./head" />
			<xsl:apply-templates select="./equipment" />

      <xsl:apply-templates select="./ingredients">
        <xsl:with-param name="yield" select="./head/yield" />
      </xsl:apply-templates>

      <xsl:apply-templates select="./directions" />
    </div>
  </xsl:template>

  <xsl:template match="head">
		<xsl:if test="./preptime">
	    <div class="preptime">
	      <h4><xsl:call-template name="preptime" /></h4>
	      <ul>
	        <xsl:for-each select="./preptime">
	          <li>
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
	          </li>
	        </xsl:for-each>
	      </ul>
	    </div>
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
	  <div class="equipment">
      <h4><xsl:call-template name="equipment" /></h4>
      <ul>
			  <xsl:for-each select="./tool">
				  <li>
						<xsl:call-template name="range_or_qty">
							<xsl:with-param name="parent" select="." />
						</xsl:call-template>
						<xsl:text> </xsl:text>
					  <xsl:value-of select="./brandname/mfr" />
						<xsl:text> </xsl:text>
					  <xsl:value-of select="./brandname/product" />
					</li>
				</xsl:for-each>
			</ul>
		</div>
  </xsl:template>
  
  <xsl:template match="ingredients">
    <xsl:param name="yield" />
    <div class="ingredients">
      <h3>
				<xsl:call-template name="ingredients" />
				<xsl:if test="$yield">
					<xsl:call-template name="for" />
					<xsl:call-template name="range_or_qty">
						<xsl:with-param name="parent" select="$yield" />
					</xsl:call-template>
					<xsl:text> </xsl:text><xsl:value-of select="$yield/unit" />
				</xsl:if>
			</h3>
			<xsl:choose>
				<xsl:when test="./ing-div">
					<xsl:for-each select="./ing-div">
						<div class="ing-div">
							<h4><xsl:value-of select="./title" /></h4>
				      <ul>
				        <xsl:for-each select="./ing">
									<xsl:apply-templates select="." />
				        </xsl:for-each>
				      </ul>
						</div>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="./ing">
		      <ul>
		        <xsl:for-each select="./ing">
							<xsl:apply-templates select="." />
		        </xsl:for-each>
		      </ul>
				</xsl:when>
			</xsl:choose>
    </div>
  </xsl:template>
	
	<xsl:template match="ing">
		<li>
			<xsl:call-template name="range_or_qty">
				<xsl:with-param name="parent" select="./amt" />
			</xsl:call-template>
			<xsl:text> </xsl:text><xsl:value-of select="./amt/unit" />
			<xsl:text> </xsl:text><xsl:value-of select="./item" />
		</li>
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
    <div class="directions">
      <h3><xsl:call-template name="directions" /></h3>
			<xsl:choose>
				<xsl:when test="./dir-div">
					<xsl:for-each select="./dir-div">
						<div class="dir-div">
							<h4><xsl:value-of select="./title" /></h4>
				      <ol>
				        <xsl:for-each select="./step">
									<xsl:apply-templates select="." />
				        </xsl:for-each>
				      </ol>
						</div>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="step">
		      <ol>
		        <xsl:for-each select="./step">
							<xsl:apply-templates select="." />
		        </xsl:for-each>
		      </ol>
				</xsl:when>
			</xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="step">
		<li class="step">
			<xsl:value-of select="." />
		</li>
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