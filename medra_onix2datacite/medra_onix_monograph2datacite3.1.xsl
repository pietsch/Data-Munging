<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <resource xmlns="http://datacite.org/schema/kernel-3">
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance">http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd</xsl:attribute>
      <xsl:for-each select="DOIMonographicProduct">
	<identifier identifierType="DOI">
	  <xsl:value-of select="DOI"/>
	</identifier>
      </xsl:for-each>
      <creators>
	<xsl:for-each select="DOIMonographicProduct/Contributor">
	  <creator>
	    <xsl:for-each select="PersonName">
	      <creatorName>
		<xsl:value-of select="."/>
	      </creatorName>
	    </xsl:for-each>
	    <xsl:for-each select="PersonNameInverted">
	      <creatorName>
		<xsl:value-of select="."/>
	      </creatorName>
	    </xsl:for-each>
	    <xsl:for-each select="CorporateName">
	      <creatorName>
		<xsl:value-of select="."/>
	      </creatorName>
	    </xsl:for-each>
	  </creator>
	</xsl:for-each>
      </creators>
      <titles>
	<xsl:for-each select="DOIMonographicProduct/Title">
	  <title>
	    <xsl:value-of select="TitleText"/>
	  </title>
	</xsl:for-each>
	<xsl:for-each select="DOIMonographicProduct/Title/Subtitle">
	  <title>
	    <xsl:value-of select="."/>
	  </title>
	</xsl:for-each>
      </titles>
      <publisher>
	<xsl:choose>
	  <xsl:when test="DOIMonographicProduct/Series">
	    <xsl:value-of select="DOIMonographicProduct/Series/TitleOfSeries"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="DOIMonographicProduct/Publisher/PublisherName"/>
	  </xsl:otherwise>
	</xsl:choose>
      </publisher>
      <xsl:for-each select="DOIMonographicProduct">
	<publicationYear>
	  <xsl:value-of select="substring(PublicationDate,1,4)"/>
	</publicationYear>
      </xsl:for-each>
      <subjects>
	<xsl:for-each select="DOIMonographicProduct/MainSubject/SubjectCode">
	  <subject>
	    <xsl:if test="../MainSubjectSchemeIdentifier = 36">
	      <xsl:attribute name="subjectScheme">DDC</xsl:attribute>
	    </xsl:if>
	    <xsl:value-of select="."/>
	  </subject>
	</xsl:for-each>
	<xsl:for-each select="DOIMonographicProduct/MainSubject/SubjectHeadingText">
	  <subject subjectScheme="SubjectHeadingText">
	    <xsl:value-of select="."/>
	  </subject>
	</xsl:for-each>
      </subjects>
      <contributors>
	<contributor contributorType="RegistrationAgency">
	  <contributorName>Bielefeld University Library</contributorName>
	</contributor>
	<contributor contributorType="HostingInstitution">
	  <contributorName>Bielefeld University</contributorName>
	</contributor>
	<contributor contributorType="Distributor">
	  <contributorName>BieColl</contributorName>
	</contributor>
	<contributor contributorType="ContactPerson">
	  <contributorName>publikationsdienste.ub@uni-bielefeld.de</contributorName>
	</contributor>
	<xsl:for-each select="DOIMonographicProduct/ImprintName">
	  <contributor contributorType="ResearchGroup">
	    <contributorName>
	      <xsl:value-of select="."/>
	    </contributorName>
	  </contributor>
	</xsl:for-each>
      </contributors>
      <xsl:for-each select="DOIMonographicProduct/Language">
	<language>
	  <xsl:value-of select="LanguageCode"/>
	</language>
      </xsl:for-each>
      <resourceType resourceTypeGeneral="Text"/>
<!-- untested because these elements do not occur in my input files:
      <xsl:for-each select="DOIMonographicProduct/RelatedWork">
	<relatedIdentifiers>
	  <xsl:for-each select="WorkIdentifier">
	    <relatedIdentifier>
	      <xsl:value-of select="IDValue"/>
	    </relatedIdentifier>
	  </xsl:for-each>
	</relatedIdentifiers>
      </xsl:for-each>
      <sizes>
	<xsl:for-each select="DOIMonographicProduct/PagesRoman">
	  <size>
	    <xsl:value-of select="."/>
	  </size>
	</xsl:for-each>
	<xsl:for-each select="DOIMonographicProduct/NumberOfPages">
	  <size>
	    <xsl:value-of select="floor(.)"/>
	  </size>
	</xsl:for-each>
	<xsl:for-each select="DOIMonographicProduct/PagesArabic">
	  <size>
	    <xsl:value-of select="floor(.)"/>
	  </size>
	</xsl:for-each>
      </sizes>
      <xsl:for-each select="DOIMonographicProduct/CopyrightStatement">
	<rightsList/>
      </xsl:for-each>
      <descriptions>
	<xsl:for-each select="DOIMonographicProduct/OtherText">
	  <description>
	    <xsl:if test="Text/@language">
	      <xsl:attribute name="xml:lang">
		<xsl:value-of select="Text/@language"/>
	      </xsl:attribute>
	    </xsl:if>
	    <xsl:for-each select="Text/node()">
	      <xsl:if test="self::text()">
		<xsl:value-of select="."/>
	      </xsl:if>
	      <xsl:if test="self::br">
		<br/>
	      </xsl:if>
	    </xsl:for-each>
	  </description>
	</xsl:for-each>
      </descriptions> -->
      <geoLocations>
	<geoLocation>
	  <geoLocationPlace>
	    <xsl:value-of select="DOIMonographicProduct/CountryOfPublication"/>
	  </geoLocationPlace>
	</geoLocation>
      </geoLocations>
    </resource>
  </xsl:template>
</xsl:stylesheet>
