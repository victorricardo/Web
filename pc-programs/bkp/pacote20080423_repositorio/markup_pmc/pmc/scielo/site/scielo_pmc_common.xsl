<?xml version="1.0" encoding="utf-8"?><xsl:transform version="1.0" id="ViewNLM-v2-04_scielo.xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:util="http://dtd.nlm.nih.gov/xsl/util" xmlns:doc="http://www.dcarlisle.demon.co.uk/xsldoc" xmlns:ie5="http://www.w3.org/TR/WD-xsl" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:fns="http://www.w3.org/2002/Math/preference" xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:pref="http://www.w3.org/2002/Math/preference" pref:renderer="mathplayer" exclude-result-prefixes="util xsl">	<xsl:template match="*">		<xsl:copy>			<xsl:apply-templates select="@*|*|text()" />		</xsl:copy>	</xsl:template>	<xsl:template match="@*" >		<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>	</xsl:template>		<xsl:template match="author-notes" mode="translate">		<xsl:param name="lang" select="../../../../..//ARTICLE/@TEXTLANG"/>		<xsl:choose>			<xsl:when test="$lang='pt' ">Correspondência</xsl:when>			<xsl:when test="$lang='es' ">Correspondencia</xsl:when>			<xsl:otherwise>Send correspondence to</xsl:otherwise>		</xsl:choose>	</xsl:template>	<xsl:template match="author-notes" mode="back">		<p>			<br/>		</p>		<p>			<br/>		</p>		<a>			<xsl:attribute name="href">#top</xsl:attribute>			<img src="/img/seta.gif" alt="" border="0" align="middle"/>		</a>		<xsl:text> </xsl:text>		<a name="{corresp/@id}">			<xsl:copy-of select=".//corresp"/>		</a>	</xsl:template>	<xsl:template match="*" mode="list-item">		<xsl:param name="sep" select="', '"/>				<xsl:value-of select="."/><xsl:if test="position()!=last()"><xsl:value-of select="$sep"/></xsl:if>	</xsl:template>		<xsl:template match="label | caption">		<span class="{name()}"><xsl:apply-templates select="*|text()"/></span>	</xsl:template>		<xsl:template match="history" mode="back">		<p>	</p>		<xsl:apply-templates select="date" mode="text"/>		<xsl:text>.</xsl:text>	</xsl:template>	<xsl:template match="date" mode="text">		<xsl:if test="position()!=1">; </xsl:if>		<xsl:variable name="the-type">			<xsl:choose>				<xsl:when test="@date-type='accepted'">Accepted: </xsl:when>				<xsl:when test="@date-type='received'">Received: </xsl:when>				<xsl:when test="@date-type='rev-request'">Revision Requested: </xsl:when>				<xsl:when test="@date-type='rev-recd'">Revision Received: </xsl:when>			</xsl:choose>		</xsl:variable>		<xsl:if test="@date-type">			<!--span class="gen"-->			<xsl:value-of select="$the-type"/>			<xsl:text/>			<!--/span-->		</xsl:if>		<xsl:variable name="the-month">			<xsl:choose>				<xsl:when test="month='01'">January</xsl:when>				<xsl:when test="month='02'">February</xsl:when>				<xsl:when test="month='03'">March</xsl:when>				<xsl:when test="month='04'">April</xsl:when>				<xsl:when test="month='05'">May</xsl:when>				<xsl:when test="month='06'">June</xsl:when>				<xsl:when test="month='07'">July</xsl:when>				<xsl:when test="month='08'">August</xsl:when>				<xsl:when test="month='09'">September</xsl:when>				<xsl:when test="month='10'">October</xsl:when>				<xsl:when test="month='11'">November</xsl:when>				<xsl:when test="month='12'">December</xsl:when>			</xsl:choose>		</xsl:variable>		<xsl:value-of select="$the-month"/>		<xsl:text> </xsl:text>		<xsl:value-of select="day"/>		<xsl:text>, </xsl:text>		<xsl:value-of select="year"/>	</xsl:template>	<xsl:template match="fn-group" mode="back">		<p>			<br/>		</p>		<p>			<br/>		</p>		<p>			<br/>		</p>		<xsl:value-of select="fn"/>	</xsl:template>	<xsl:template match="fn" mode="back">			</xsl:template>	<xsl:template match="mml:math">		<xsl:comment>pmc</xsl:comment>		<xsl:copy-of select="."/>	</xsl:template>	<xsl:template match="tex-math">		<xsl:variable name="f">			<xsl:choose>				<xsl:when test="contains(.,'\begin{document}')">					<xsl:value-of select="substring-before(substring-after(.,'\begin{document} $$'),'$$ \end{document}')"/>				</xsl:when>				<xsl:otherwise>					<xsl:value-of select="."/>				</xsl:otherwise>			</xsl:choose>		</xsl:variable>		<img src="{concat(//MIMETEX,'?',$f)}" alt="" border="0" align="middle"/>	</xsl:template>	<xsl:template match="email">		<a href="mailto:{.}">			<xsl:apply-templates/>		</a>	</xsl:template>	<!--													-->	<!--		<xsl:template match="//corresp" mode="copyValue">		<xsl:copy-of select="."/>	</xsl:template>		<xsl:template match="*" mode="make-end-metadata">		<xsl:apply-templates select=".//article-meta"/>	</xsl:template>	<xsl:template match="article-meta">		<xsl:apply-templates select="article-categories"/>		<xsl:apply-templates select="related-article"/>		<xsl:apply-templates select="conference"/>	</xsl:template>			<xsl:template match="*" mode="back">		<a href="javascript: back()">_</a>	</xsl:template>	--></xsl:transform>