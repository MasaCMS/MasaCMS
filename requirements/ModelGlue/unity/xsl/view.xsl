<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">    
&lt;cfset listEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.list")  /&gt;
&lt;cfset commitEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.commit") &amp; "&amp;<xsl:value-of select="object/alias"/>Id=" &amp; urlEncodedFormat(viewstate.getValue("<xsl:value-of select="object/alias"/>Id")) /&gt;
&lt;cfset <xsl:value-of select="object/alias"/>Record = viewstate.getValue("<xsl:value-of select="object/alias"/>Record") /&gt;
&lt;cfset validation = viewstate.getValue("<xsl:value-of select="object/alias"/>Validation", structNew()) /&gt;

&lt;cfoutput&gt;
&lt;div id="breadcrumb"&gt;&lt;a href="#listEvent#"&gt;<xsl:value-of select="object/label"/>s&lt;/a&gt; / View <xsl:value-of select="object/label"/>&lt;/div&gt;
&lt;/cfoutput&gt;
&lt;br /&gt;
  
&lt;cfform class="edit"&gt;
    
&lt;fieldset&gt;
    
<xsl:for-each select="object/properties/property">
  <xsl:if test="(primarykey = 'false' or relationship = 'true')">
    <xsl:if test="relationship = 'false'">
        &lt;div class="formfield"&gt;
          &lt;cfoutput&gt;
	        &lt;label for="<xsl:value-of select="alias"/>"&gt;&lt;b&gt;<xsl:value-of select="label"/>:&lt;/b&gt;&lt;/label&gt;
	        &lt;span class="input"&gt;#<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()#&lt;/span&gt;
	        &lt;/cfoutput&gt;
        &lt;/div&gt;
    </xsl:if>
    <xsl:if test="relationship = 'true'">
      <xsl:if test="pluralrelationship = 'false'">
        &lt;div class="formfield"&gt;
          &lt;cfoutput&gt;
	        &lt;label for="<xsl:value-of select="alias"/>"&gt;&lt;b&gt;<xsl:value-of select="label"/>:&lt;/b&gt;
	        &lt;/label&gt;

					&lt;cfif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "get<xsl:value-of select="name"/>")&gt;
						&lt;cfset targetObject = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="name"/>() /&gt;
					&lt;cfelseif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "getParent<xsl:value-of select="name"/>")&gt;
						&lt;cfset targetObject = <xsl:value-of select="/object/alias"/>Record.getParent<xsl:value-of select="name"/>() /&gt;
					&lt;/cfif&gt;
				
	        &lt;div&gt;
	       		#targetObject.get<xsl:value-of select="sourcecolumn"/>()#
	        &lt;/div&gt;
	        &lt;/cfoutput&gt;
        &lt;/div&gt;
      </xsl:if>
      <xsl:if test="pluralrelationship = 'true'">
        &lt;div class="formfield"&gt;
        	&lt;label&gt;&lt;b&gt;<xsl:value-of select="sourcecolumn"/>(s):&lt;/b&gt;&lt;/label&gt;

					&lt;!--- This XSL supports both Reactor and Transfer ---&gt;
					&lt;cfif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "get<xsl:value-of select="alias"/>Struct")&gt;
						&lt;cfset selected = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>Struct() /&gt;
					&lt;cfelseif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "get<xsl:value-of select="alias"/>Array")&gt;
						&lt;cfset selected = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>Array() /&gt;
					&lt;cfelse&gt;
						&lt;cfset selected = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>Iterator().getQuery() /&gt;
					&lt;/cfif&gt;

					&lt;cfif isQuery(selected)&gt;
						&lt;cfset selectedList = valueList(selected.<xsl:value-of select="sourcekey"/>) /&gt;
						&lt;div class="formfieldinputstack"&gt;
						&lt;cfoutput query="selected"&gt;
							#selected.<xsl:value-of select="sourcecolumn"/>#&lt;br /&gt;
						&lt;/cfoutput&gt;
						&lt;/div&gt;
					&lt;cfelseif isStruct(selected)&gt;
						&lt;cfoutput&gt;
						&lt;div class="formfieldinputstack"&gt;
						&lt;cfloop collection="#selected#" item="i"&gt;
							#selected[i].get<xsl:value-of select="sourcecolumn"/>()#&lt;br /&gt;
						&lt;/cfloop&gt;
						&lt;/div&gt;
						&lt;/cfoutput&gt;
					&lt;cfelseif isArray(selected)&gt;
						&lt;cfoutput&gt;
						&lt;div class="formfieldinputstack"&gt;
						&lt;cfloop from="1" to="#arrayLen(selected)#" index="i"&gt;
							#selected[i].get<xsl:value-of select="sourcecolumn"/>()#&lt;br /&gt;
						&lt;/cfloop&gt;
						&lt;/div&gt;
						&lt;/cfoutput&gt;
					&lt;/cfif&gt;

        &lt;/div&gt;
          
      </xsl:if>
    </xsl:if>
  </xsl:if>
</xsl:for-each>
&lt;/fieldset&gt;
&lt;/div&gt;
&lt;/cfform&gt;
    
	</xsl:template>
</xsl:stylesheet>