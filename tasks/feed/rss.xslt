<!-- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. -->

<?xml version='1.0' encoding='UTF-8'?>
<!-- Style RSS so that it is readable. -->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	version="1.0"
>

<xsl:template match='/rss'>
	<html>
		<head>
			<title>RSS Feed for <xsl:value-of select='channel/title'/></title>
			<style type="text/css">
				body { margin:10px 50px 25px;  font-family: verdana, sans-serif; font-size: 80%; line-height: 1.45em; } 
				#block { margin:0px auto; width:600px; text-align:left; }
				p { padding-top: 0px; margin-top: 0px; }
				h1 { font-size: 120%; padding-bottom: 0px; margin-bottom: 0px; }
				h2 { font-size: 100%; margin-bottom: 0px; } 
				.code {font-family:"Courier New", Courier, mono; border:1px dotted #ccc; background-color:#EFEFEF;}
			</style>
		</head>
		<body>
			<div id='block'>
			<h1>RSS Feed for <xsl:value-of select='channel/title'/></h1>
			<p>By subscribing to this Really Simple Syndication (RSS) feed from <a href='{channel/link}'><xsl:value-of select='channel/title'/></a>, advanced users can have new headlines and article previews delivered in an RSS reader or aggregator. RSS offers a convenience because you can subscribe to feeds from several sources and automatically aggregate headlines from all the sources into one list. You can quickly browse the list of new content without visiting each site to search for new info of interest.</p>
			<hr />
			<xsl:apply-templates select='channel/item' />
			</div>
		</body>
	</html>
</xsl:template>

<xsl:template match='item'>
		<h2>
			<a href='{link}'>
				<xsl:value-of select='title'/>
			</a>
		</h2>
		<p>
			<xsl:value-of select='description' disable-output-escaping='yes' />
			<br />
			<strong>Author: </strong><xsl:value-of select='dc:creator' />
			<br />
			<strong>Published Date: </strong><xsl:value-of select='pubDate' />
			<br />
		<xsl:for-each select='category'>
			<xsl:value-of select='.' /> | 
		</xsl:for-each>
			<br />
			<a href='{link}'>Read the full item</a>.
		</p>
		<hr/>
</xsl:template>

<xsl:template match='category'>
		<xsl:value-of select='.'/> |  
</xsl:template>


</xsl:stylesheet>