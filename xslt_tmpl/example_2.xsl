<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
User Name: <xsl:value-of select="/xmlroot/document/username" />.
<hr />

Email: <xsl:value-of select="/xmlroot/document/email" />.
</xsl:template>

</xsl:stylesheet>
