<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:ags="http://purl.org/agmes/1.1/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:agls="http://www.naa.gov.au/recordkeeping/gov_online/agls/1.2" xmlns:dcterms="http://purl.org/dc/terms/">

<xsl:output method="xml"/>
<xsl:variable name="spacechar">00</xsl:variable>

<xsl:template match="/">
	<ListRecords>
		<xsl:apply-templates select="//article/front"/>	
		<xsl:apply-templates select="//RESUME"/>
	</ListRecords>		
</xsl:template>

<xsl:template match="title-group" mode="title">
	<dc:title xml:lang="{article-title/@xml:lang}"><xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text><xsl:value-of select="article-title"/><xsl:text disable-output-escaping="yes">]]&gt;</xsl:text></dc:title>
</xsl:template>

<xsl:template match="contrib" mode="creator">
	<xsl:variable name="aff">
		<xsl:apply-templates select="xref" mode="aff" />
	</xsl:variable>
	<ags:creatorPersonal><xsl:value-of select="normalize-space(concat(name/surname,', ',name/given-names))"/>
	<xsl:if test="normalize-space($aff) != '' ">(<xsl:value-of select="normalize-space(substring-after($aff,','))" />)</xsl:if></ags:creatorPersonal>
</xsl:template>

<xsl:template match="xref" mode="aff">
	<xsl:variable name="rid" select="@rid" />
	<xsl:apply-templates select="../../../aff[@id = $rid]" mode="aff"/>
</xsl:template>

<xsl:template match="aff" mode="aff">
	<xsl:value-of select="institution" />
</xsl:template>

<xsl:template match="publisher" mode="publisher">
	<dc:publisher>
		<ags:publisherName><xsl:value-of select="publisher-name"/></ags:publisherName>
	</dc:publisher>
</xsl:template>

<xsl:template match="pub-date[@pub-type='pub']" mode="date">
	<dc:date>
		<dcterms:dateIssued><xsl:value-of select="year"/></dcterms:dateIssued>
	</dc:date>
</xsl:template>

<xsl:template match="kwd" mode="subject">
	<dc:subject>
		<xsl:if test="normalize-space(@lng) != ''">
			<xsl:attribute name="xml:lang">
					<xsl:value-of select="@lng" />
			</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="."/>
	</dc:subject>		
</xsl:template>

<xsl:template match="abstract" mode="description">
	<dc:description>
		<dcterms:abstract xml:lang="{@xml:lang}"><xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text><xsl:value-of select="p"/><xsl:text disable-output-escaping="yes">]]&gt;</xsl:text></dcterms:abstract>
	</dc:description>
</xsl:template>

<xsl:template match="article-meta" mode="identifier">
	<dc:identifier scheme="dcterms:URI">http://www.scielo.br/scielo.php?script=sci_arttext&#x0026;pid=<xsl:value-of select="article-id"/></dc:identifier>
	<dc:identifier scheme="ags:DOI">10.1590/<xsl:value-of select="article-id"/></dc:identifier>
</xsl:template>

<xsl:template match="title-group" mode="language">
	<dc:language scheme="ags:ISO639-1"><xsl:value-of select="article-title/@xml:lang"/></dc:language>
</xsl:template>

<xsl:template match="RESUME">
		<xsl:variable name="from">
			<xsl:call-template name="FormatDate">
				<xsl:with-param name="date" select="@FROM"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="until">
			<xsl:call-template name="FormatDate">
				<xsl:with-param name="date" select="@UNTIL"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="resumptionToken">
			<xsl:if test="@CONTROL">
				<xsl:value-of select="@CONTROL"/>:<xsl:value-of select="@SET"/>:<xsl:value-of select="$from"/>:<xsl:value-of select="$until"/>
			</xsl:if>
		</xsl:variable>
		<resumptionToken><xsl:value-of select="normalize-space($resumptionToken)"/></resumptionToken>
</xsl:template>

<xsl:template name="FormatDate">
		<xsl:param name="date"/>
		<xsl:if test="$date">
			<xsl:choose>
				<xsl:when test=" substring($date,5,2) = '00' ">
					<xsl:value-of select="concat(substring($date,1,4),'-01-01') "/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(substring($date,1,4), '-', substring($date,5,2), '-01') "/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>



<xsl:template match="front">	
	<record>
		<header>
			<xsl:apply-templates select=".//article-meta/article-id" mode="identifier"/>
			<xsl:apply-templates select="article-meta/pub-date[@pub-type='pub']" mode="datestamp" />
			<xsl:apply-templates select="journal-meta/issn" mode="setSpec" />
		</header>
		<metadata>
			<ags:resources>		
				<ags:resource ags:ARN="SC{concat(substring(article-meta/article-id,11,4),$spacechar,substring(article-meta/article-id,17,2),substring(article-meta/article-id,22,2) )}">
					<xsl:apply-templates select=".//title-group" mode="title"/>
					<dc:creator>
						<xsl:apply-templates select=".//contrib-group/contrib" mode="creator"/>
					</dc:creator>
					<xsl:apply-templates select=".//publisher" mode="publisher"/>
					<xsl:apply-templates select=".//pub-date[@pub-type='pub']" mode="date"/>
					<xsl:apply-templates select=".//kwd-group/kwd" mode="subject"/>
					<xsl:apply-templates select=".//abstract" mode="description"/>
					<xsl:apply-templates select=".//article-meta" mode="identifier"/>
					<dc:type>journal article</dc:type>
					<dc:format><dcterms:medium>text/xml</dcterms:medium></dc:format>
					<xsl:apply-templates select=".//title-group" mode="language"/>				
					<!--xsl:apply-templates select="article-meta" mode="article-id"/-->
					<agls:availability>
						<ags:availabilityLocation>SCIELO</ags:availabilityLocation>
						<ags:availabilityNumber>10.1590/<xsl:value-of select=".//article-meta/article-id"/></ags:availabilityNumber> 
					</agls:availability>
					<ags:citation>
				              <xsl:apply-templates select="journal-meta/publisher/publisher-name" mode="citationTitle"/>
			               	 <xsl:apply-templates select="journal-meta/issn" mode="issn"/>
				              <xsl:apply-templates select="article-meta" mode="volnum"/>
				              <xsl:apply-templates select="article-meta/pub-date[@pub-type='pub']/year" mode="year"/>
					</ags:citation>			
				</ags:resource>
			</ags:resources>
		</metadata>
	</record>
</xsl:template>

<xsl:template match="article-id" mode="identifier">
	<!--identifier>oai:agris.scielo:<xsl:value-of select="normalize-space(.)"/></identifier-->
	<identifier>oai:agris.scielo:SC<xsl:value-of select="concat(substring(.,11,4),$spacechar,substring(.,17,2),substring(.,22,2) )"/></identifier>
</xsl:template>

<xsl:template match="issn" mode="setSpec">
	<setSpec><xsl:value-of select="normalize-space(.)"/></setSpec>
</xsl:template>

<xsl:template match="pub-date" mode="datestamp">
	<datestamp><xsl:value-of select="year"/>-<xsl:value-of select="month"/>-<xsl:choose><xsl:when test="normalize-space(day) != '00'"><xsl:value-of select="day"/></xsl:when><xsl:otherwise><xsl:text>01</xsl:text></xsl:otherwise></xsl:choose></datestamp>
</xsl:template>

<xsl:template match="publisher-name" mode="citationTitle">
	<ags:citationTitle><xsl:value-of select="normalize-space(.)"/></ags:citationTitle>
</xsl:template>

<xsl:template match="issn" mode="issn">
	<ags:citationIdentifier scheme="ags:ISSN"><xsl:value-of select="normalize-space(.)"/></ags:citationIdentifier>
</xsl:template>

<xsl:template match="article-meta" mode="volnum">
	<ags:citationNumber><xsl:apply-templates select="volume" mode="volnum"/><xsl:apply-templates select="numero" mode="volnum"/></ags:citationNumber>
</xsl:template>

<xsl:template match="volume" mode="volnum">vol.<xsl:value-of select="normalize-space(.)"/></xsl:template>

<xsl:template match="numero" mode="volnum"> num.<xsl:value-of select="normalize-space(.)"/></xsl:template>

<xsl:template match="year" mode="year">
	<ags:citationChronology>
		<xsl:value-of select="normalize-space(.)"/>/<xsl:value-of select="normalize-space(../month)"/>
	</ags:citationChronology>
</xsl:template>
</xsl:stylesheet>
