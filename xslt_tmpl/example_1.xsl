<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html>
<body>
User Name: <xsl:value-of select="/xmlroot/document/username" /><br />
Email: <xsl:value-of select="/xmlroot/document/email" />
</body>
</html>
</xsl:template>
</xsl:stylesheet>
