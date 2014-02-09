<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:javaFile="javaFile:java.io.File" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon" exclude-result-prefixes="saxon javaFile">
	<xsl:script language="java" implements-prefix="javaFile" src="java:java.io.File"/>

	<xsl:template match="/">
		<xsl:for-each select="//member[contains(@name, 'T:')]">
			<xsl:if test="not(.//remark[text()='DND'])">
				<xsl:call-template name="type">
					<xsl:with-param name="info" select="@name"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="//member[contains(@name, 'F:')]">
			<xsl:if test="not(.//remark[text()='DND'])">
				<xsl:call-template name="nontype">
					<xsl:with-param name="info" select="@name"/>
					<xsl:with-param name="folder" select="'\fields\'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="//member[contains(@name, 'M:')]">
			<xsl:if test="not(./remark[text()='DND'])">
				<xsl:call-template name="nontype">
					<xsl:with-param name="info" select="@name"/>
					<xsl:with-param name="folder" select="'\methods\'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="//member[contains(@name, 'P:')]">
			<xsl:if test="not(./remark[text()='DND'])">
				<xsl:call-template name="nontype">
					<xsl:with-param name="info" select="@name"/>
					<xsl:with-param name="folder" select="'\properties\'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="//member[contains(@name, 'E:')]">
			<xsl:if test="not(./remark[text()='DND'])">
				<xsl:call-template name="nontype">
					<xsl:with-param name="info" select="@name"/>
					<xsl:with-param name="folder" select="'\events\'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="type">
		<xsl:param name="info"/>
		<xsl:variable name="nodefinition" select="substring-after($info, ':')"/>
		<xsl:variable name="namespace">
			<xsl:call-template name="getnamespace">
				<xsl:with-param name="nodefinitionpass" select="$nodefinition"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="class" select="substring-after($nodefinition, concat($namespace, '.'))"/>
		<xsl:variable name="pathname" select="document('xmlpathfile.xml', //path/text())"/>
		<xsl:call-template name="makedirectories">
			<xsl:with-param name="path" select="concat($pathname,'\content\', $namespace, '\classes\', $class)"/>
		</xsl:call-template>
		<xsl:variable name="sharpfree">
			<xsl:choose>
				<xsl:when test="contains($nodefinition, '#')">
					<xsl:call-template name="removesharp">
						<xsl:with-param name="nodefinitionpass" select="$nodefinition"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after($nodefinition, concat($namespace, '.'))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="makefiles">
			<xsl:with-param name="pathfile" select="concat($pathname,'\content\',$namespace, '\classes\', $class, '\', $class,'.xml')"/>
			<xsl:with-param name="namespacepass" select="$namespace"/>
			<xsl:with-param name="classpass" select="$class"/>
			<xsl:with-param name="notypename" select="$sharpfree"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="getnamespace">
		<xsl:param name="nodefinitionpass"/>
		<xsl:value-of select="substring-before($nodefinitionpass, '.')"/>
		<xsl:if test="string-length(substring-after($nodefinitionpass, '.'))!=0">
			<xsl:if test="contains(substring-after($nodefinitionpass,'.'),'.')">
				<xsl:text>.</xsl:text>
				<xsl:call-template name="getnamespace">
					<xsl:with-param name="nodefinitionpass" select="substring-after($nodefinitionpass, '.')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="nontype">
		<xsl:param name="info"/>
		<xsl:param name="folder"/>
		<xsl:choose>
			<xsl:when test="contains($info, '(')">
				<xsl:call-template name="nontype">
					<xsl:with-param name="info" select="substring-before($info, '(' )"/>
					<xsl:with-param name="folder" select="$folder"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($info, '.#ctor')">
				<xsl:variable name="ctorfix">
					<xsl:call-template name="ctorfixhack">
						<xsl:with-param name="info" select="substring-before($info,'.#ctor')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="nontype">
					<xsl:with-param name="info" select="$ctorfix"/>
					<xsl:with-param name="folder" select="$folder"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="nodefinition" select="substring-after($info, ':')"/>
				<xsl:variable name="namespace">
					<xsl:call-template name="getnontypenamespace">
						<xsl:with-param name="nodefinitionpass" select="$nodefinition"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="class" select="substring-before(substring-after($nodefinition, concat($namespace, '.')),'.')"/>
				<xsl:variable name="pathname" select="document('xmlpathfile.xml', //path/text())"/>
				<xsl:call-template name="makedirectories">
					<xsl:with-param name="path" select="concat($pathname,'\content\',$namespace, '\classes\', $class, $folder)"/>
				</xsl:call-template>
				<xsl:variable name="sharpfree">
					<xsl:choose>
						<xsl:when test="contains($nodefinition, '#')">
							<xsl:call-template name="removesharp">
								<xsl:with-param name="nodefinitionpass" select="$nodefinition"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after($nodefinition, concat($class, '.'))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="string-length($class)=0">
					<xsl:message><xsl:value-of select="$info"/></xsl:message>
				</xsl:if>
				<xsl:call-template name="makefiles">
					<xsl:with-param name="pathfile" select="concat($pathname,'\content\',$namespace, '\classes\', $class, $folder, $class, '.', $sharpfree, '.xml')"/>
					<xsl:with-param name="namespacepass" select="$namespace"/>
					<xsl:with-param name="classpass" select="$class"/>
					<xsl:with-param name="notypename" select="$sharpfree"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="ctorfixhack">
		<xsl:param name="info"/>
		<xsl:variable name="namespace">
			<xsl:call-template name="getnamespace">
				<xsl:with-param name="nodefinitionpass" select="$info"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="class" select="substring-after($info, concat($namespace,'.'))"/>
		<xsl:value-of select="concat($info, '.', $class)"/>
	</xsl:template>
	
	<xsl:template name="getnontypenamespace">
		<xsl:param name="nodefinitionpass"/>
		<xsl:value-of select="substring-before($nodefinitionpass, '.')"/>
		<xsl:if test="string-length(substring-after($nodefinitionpass, '.'))!=0">
			<xsl:if test="contains(substring-after(substring-after($nodefinitionpass,'.'),'.'),'.')">
				<xsl:text>.</xsl:text>
				<xsl:call-template name="getnontypenamespace">
					<xsl:with-param name="nodefinitionpass" select="substring-after($nodefinitionpass, '.')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="removesharp">
		<xsl:param name="nodefinitionpass"/>
		<xsl:choose>
			<xsl:when test="string-length(substring-after($nodefinitionpass, '#'))!=0">
				<xsl:call-template name="removesharp">
					<xsl:with-param name="nodefinitionpass" select="substring-after($nodefinitionpass, '#')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$nodefinitionpass"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="makedirectories">
		<xsl:param name="path"/>
		<xsl:variable name="pathobject" select="javaFile:new($path)"/>
		<xsl:variable name="pathdir" select="javaFile:mkdirs($pathobject)"/>
	</xsl:template>

	<xsl:template name="makefiles">
		<xsl:param name="pathfile"/>
		<xsl:param name="namespacepass"/>
		<xsl:param name="classpass"/>
		<xsl:param name="notypename"/>
		<xsl:document href="{$pathfile}" method="xml" indent="yes">
			<api>
				<routine namespace="{$namespacepass}" class="{$classpass}">
					<xsl:value-of select="$notypename"/>
				</routine>
				<xsl:choose>
					<xsl:when test="summary">
						<descrShort id="descrShort">
							<para>
								<xsl:apply-templates select="summary"/>
							</para>
						</descrShort>
						<descrLong id="descrLong">
							<para>
								<xsl:apply-templates select="text()|*[not(self::summary)]"/>
							</para>
						</descrLong>
					</xsl:when>
					<xsl:otherwise>
						<!-- if there's no summary, put the whole thing in the short description -
										at a minimum we must have a short description because it gets 
										displayed in different contexts -->
						<descrShort id="descrShort">
							<para>
								<xsl:apply-templates select="text()|*"/>
							</para>
						</descrShort>
						<descrLong id="descrLong">
							<para/>
						</descrLong>
					</xsl:otherwise>
				</xsl:choose>
			</api>
		</xsl:document>
	</xsl:template>
	
	<xsl:template match="see | paramref">
		<codeInline>
			<xsl:variable name="attr" select="@cref | @name"/>
			<xsl:choose>
				<xsl:when test="contains($attr, ':')">
					<xsl:value-of select="substring-after($attr,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$attr"/>
				</xsl:otherwise>
			</xsl:choose>
		</codeInline>
	</xsl:template>
	
		<xsl:template match="exception | param">
		<codeInline>
			<xsl:variable name="attr" select="@cref | @name"/>
			<xsl:choose>
				<xsl:when test="contains($attr, ':')">
					<xsl:value-of select="substring-after($attr,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$attr"/>
				</xsl:otherwise>
			</xsl:choose>
		</codeInline>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>
