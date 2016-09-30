<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Templates for building a BIBFRAME 2.0 entities from MARCXML
      All templates should have the mode "entities"
      Parameter "recordid" used to generate id
  -->

  <xsl:template match="marc:datafield[@tag='210']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>

    <xsl:if test="@ind1 = 1">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:Title>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title210-<xsl:value-of select="position()"/></xsl:attribute>
            <rdf:type>bf:VariantTitle</rdf:type>
            <rdf:type>bf:AbbreviatedTitle</rdf:type>
            <xsl:if test="@ind2 = ' '">
              <bf:source>
                <bf:Source>
                  <rdf:value>issnkey</rdf:value>
                </bf:Source>
              </bf:source>
            </xsl:if>
            <xsl:variable name="label">
              <xsl:apply-templates mode="label" select="marc:subfield[@code='a' or @code='b']"/>
            </xsl:variable>
            <xsl:if test="$label != ''">
              <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
              <bflc:titleSortKey><xsl:value-of select="substring($label,1,string-length($label)-1)"/></bflc:titleSortKey>
            </xsl:if>
            <xsl:apply-templates mode="title210">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
          </bf:Title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

  </xsl:template>
        
  <xsl:template match="marc:subfield[@code='a']" mode="title210">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='b']" mode="title210">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:qualifier><xsl:value-of select="."/></bf:qualifier>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='2']" mode="title210">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:source>
          <bf:Source>
            <rdfs:label><xsl:value-of select="."/></rdfs:label>
          </bf:Source>
        </bf:source>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="title210"/>

  <xsl:template match="marc:datafield[@tag='222']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:Title>
          <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title222-<xsl:value-of select="position()"/></xsl:attribute>
          <rdf:type>bf:VariantTitle</rdf:type>
          <rdf:type>bf:KeyTitle</rdf:type>
          <xsl:variable name="label">
            <xsl:apply-templates mode="label" select="marc:subfield[@code='a' or @code='b']"/>
          </xsl:variable>
          <xsl:if test="$label != ''">
            <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
            <bflc:titleSortKey><xsl:value-of select="substring($label,@ind2+1,(string-length($label)-@ind2)-1)"/></bflc:titleSortKey>
          </xsl:if>
          <xsl:apply-templates mode="title222">
            <xsl:with-param name="serialization" select="$serialization"/>
          </xsl:apply-templates>
        </bf:Title>
      </xsl:when>
    </xsl:choose>

  </xsl:template>
  
  <xsl:template match="marc:subfield[@code='a']" mode="title222">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='b']" mode="title222">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:qualifier><xsl:value-of select="."/></bf:qualifier>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="title222"/>

  <xsl:template match="marc:datafield[@tag='245']" mode="entities">
    <xsl:param name="recordid"/>
    <xsl:param name="serialization"/>

    <xsl:if test="@ind1 = 1">
      <xsl:choose>
        <xsl:when test="$serialization = 'rdfxml'">
          <bf:Title>
            <xsl:attribute name="rdf:about"><xsl:value-of select="$recordid"/>title245</xsl:attribute>

            <rdf:type>bf:InstanceTitle</rdf:type>
            <xsl:if test="not(../marc:datafield[@tag='130']) and not(../marc:datafield[@tag='240'])">
              <rdf:type>bf:WorkTitle</rdf:type>
            </xsl:if>

            <xsl:variable name="label">
              <xsl:apply-templates mode="label" select="marc:subfield[@code='a' or @code='n' or @code='p']"/>
            </xsl:variable>
            <xsl:if test="$label != ''">
              <rdfs:label><xsl:value-of select="substring($label,1,string-length($label)-1)"/></rdfs:label>
              <bflc:titleSortKey><xsl:value-of select="substring($label,@ind2+1,(string-length($label)-@ind2)-1)"/></bflc:titleSortKey>
            </xsl:if>
            
            <xsl:apply-templates mode="title245">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            
          </bf:Title>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <xsl:template match="marc:subfield[@code='a']" mode="title245">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:mainTitle><xsl:value-of select="."/></bf:mainTitle>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='b']" mode="title245">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:subtitle><xsl:value-of select="."/></bf:subtitle>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='n']" mode="title245">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:partNumber><xsl:value-of select="."/></bf:partNumber>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:subfield[@code='p']" mode="title245">
    <xsl:param name="serialization"/>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <bf:partName><xsl:value-of select="."/></bf:partName>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="label">
    <!-- create a space delimited label -->
    <!-- need to trim off the trailing space to use -->
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="title245"/>

  <!-- suppress text from unmatched nodes -->
  <xsl:template match="text()" mode="entities"/>

</xsl:stylesheet>
