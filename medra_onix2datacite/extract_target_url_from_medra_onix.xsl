<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <xsl:for-each select="DOIMonographicProduct">
      <xsl:value-of select="DOIWebsiteLink"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
