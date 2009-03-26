<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">    

&lt;cfset listEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.list")  /&gt;
&lt;cfset <xsl:value-of select="object/alias"/>Record = viewstate.getValue("<xsl:value-of select="object/alias"/>Record") /&gt;
&lt;cfset keyString = "<xsl:for-each select="object/properties/property"><xsl:if test="primarykey = 'true'">&amp;<xsl:value-of select="alias"/>=#urlEncodedFormat(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>())#</xsl:if></xsl:for-each>" />
&lt;cfset commitEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.commit") &amp; keyString /&gt;
&lt;cfset validation = viewstate.getValue("<xsl:value-of select="object/alias"/>Validation", structNew()) /&gt;

&lt;cfset isNew = true /&gt;
		
<xsl:for-each select="object/properties/property">
  <xsl:if test="primarykey = 'true'">
		&lt;cfif (not isNumeric(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()) and len(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>())) or (isNumeric(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()) and <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>())&gt;
			&lt;cfset isNew = false /&gt;
		&lt;/cfif&gt;
	</xsl:if>
</xsl:for-each>
		
&lt;cfoutput&gt;
&lt;div id="breadcrumb"&gt;
		&lt;a href="#listEvent#"&gt;<xsl:value-of select="object/label"/>s&lt;/a&gt; / 
		&lt;cfif isNew&gt;
			Add New <xsl:value-of select="object/label"/>
		&lt;cfelse&gt;
			#<xsl:value-of select="object/alias"/>Record.get<xsl:value-of select="object/labelfield"/>()#
		&lt;/cfif&gt;
&lt;/div&gt;
&lt;/cfoutput&gt;
&lt;br /&gt;


								
&lt;cfform action="#commitEvent#" class="edit"&gt;
    
&lt;fieldset&gt;
    
<xsl:for-each select="object/properties/property">
  <xsl:if test="primarykey = 'true'">
    &lt;cfoutput&gt;
    &lt;input type="hidden" name="<xsl:value-of select="alias"/>" value="#<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()#" /&gt;
    &lt;/cfoutput&gt;
  </xsl:if>  
  <xsl:if test="(primarykey = 'false' or relationship = 'true')">
    <xsl:if test="relationship = 'false'">
        &lt;div class="formfield"&gt;
	        &lt;label for="<xsl:value-of select="name"/>" &lt;cfif structKeyExists(validation, &quot;<xsl:value-of select="alias"/>&quot;)>class=&quot;error&quot;&lt;/cfif&gt;&gt;&lt;b&gt;<xsl:value-of select="label"/>:&lt;/b&gt;&lt;/label&gt;
	        &lt;div&gt;
					<xsl:if test="cfdatatype = 'boolean'">
		        &lt;div class="formfieldinputstack"&gt;
		        &lt;input 
									type="radio" 
									id="<xsl:value-of select="alias"/>_true" 
									name="<xsl:value-of select="alias"/>" 
									value="true" 
									&lt;cfif isBoolean(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()) and <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()&gt;checked&lt;/cfif&gt;
						/&gt;
						&lt;label for="<xsl:value-of select="alias"/>_true"&gt; Yes&lt;/label&gt;
		        &lt;input 
									type="radio" 
									id="<xsl:value-of select="alias"/>_false" 
									name="<xsl:value-of select="alias"/>" 
									value="false" 
									&lt;cfif isBoolean(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()) and not <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()&gt;checked&lt;/cfif&gt;
						/&gt;
						&lt;label for="<xsl:value-of select="alias"/>_false"&gt; No&lt;/label&gt;
						&lt;/div&gt;
					</xsl:if>
	        <xsl:if test="cfdatatype != 'boolean' and length &lt; 65535">
		        &lt;cfinput 
									type="text" 
									class="input" 
									<xsl:if test="cfdatatype = 'string' and length &gt; 0">maxLength="<xsl:value-of select="length"/>"</xsl:if> 
									id="<xsl:value-of select="alias"/>" 
									name="<xsl:value-of select="alias"/>" 
									<xsl:if test="cfdatatype = 'date'">
										value="#dateFormat(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>(), "m/d/yyyy")# #timeFormat(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>(), "h:mm TT")#" 
									</xsl:if>
									<xsl:if test="cfdatatype != 'date'">
										value="#<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()#" 
									</xsl:if>
						/&gt;
		      </xsl:if>
	        <xsl:if test="cfdatatype = 'string' and length &gt;= 65535">
		        &lt;textarea class="input" id="<xsl:value-of select="name"/>" name="<xsl:value-of select="alias"/>"&gt;&lt;cfoutput&gt;#<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()#&lt;/cfoutput&gt;&lt;/textarea&gt;
		      </xsl:if>
	        &lt;/div&gt;
	        &lt;cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="<xsl:value-of select="alias"/>" validation="#validation#" /&gt;
        &lt;/div&gt;
    </xsl:if>
    <xsl:if test="relationship = 'true'">
      <xsl:if test="pluralrelationship = 'false'">
        &lt;div class="formfield"&gt;
	        &lt;label for="<xsl:value-of select="name"/>" &lt;cfif structKeyExists(validation, &quot;<xsl:value-of select="alias"/>&quot;)>class=&quot;error&quot;&lt;/cfif&gt;&gt;&lt;b&gt;<xsl:value-of select="label"/>:&lt;/b&gt;
	        &lt;/label&gt;
	        &lt;cfset valueQuery = viewstate.getValue("<xsl:value-of select="sourceobject"/>List") /&gt;
	        &lt;div&gt;
        
						&lt;cfset sourceValue = "" /&gt;

						&lt;cftry&gt;
							&lt;cfif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "get<xsl:value-of select="alias"/>")&gt;
								&lt;cfset sourceValue = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>() /&gt;
							&lt;cfelseif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "getParent<xsl:value-of select="alias"/>")&gt;
								&lt;cfset sourceValue = <xsl:value-of select="/object/alias"/>Record.getParent<xsl:value-of select="alias"/>() /&gt;
							&lt;/cfif&gt;
							&lt;cfcatch&gt;
							&lt;/cfcatch&gt;
						&lt;/cftry&gt;
				
						&lt;cfif isObject(sourceValue)&gt;
							&lt;cfset sourceValue = sourceValue.get<xsl:value-of select="sourcekey"/>() /&gt;
						&lt;/cfif&gt;
	
          &lt;select name="<xsl:value-of select="name"/>" id="<xsl:value-of select="name"/>" &gt;
            <xsl:if test="nullable = 'true' or nullable = '1'">
              &lt;option value=""&gt;&lt;/option&gt;
            </xsl:if>
				
            &lt;cfoutput query="valueQuery"&gt;
              &lt;option value="#valueQuery.<xsl:value-of select="sourcekey"/>#" &lt;cfif sourceValue eq valueQuery.<xsl:value-of select="sourcekey"/>&gt;selected&lt;/cfif&gt;>#valueQuery.<xsl:value-of select="sourcecolumn"/>#&lt;/option&gt;
            &lt;/cfoutput&gt;
          &lt;/select&gt;
	        &lt;/div&gt;
	        &lt;cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="<xsl:value-of select="alias"/>" validation="#validation#" /&gt;
        &lt;/div&gt;
      </xsl:if>
      <xsl:if test="pluralrelationship = 'true'">
        &lt;div class="formfield"&gt;
        	&lt;label &lt;cfif structKeyExists(validation, &quot;<xsl:value-of select="alias"/>&quot;)>class=&quot;error&quot;&lt;/cfif&gt;&gt;&lt;b&gt;<xsl:value-of select="label"/>(s):&lt;/b&gt;&lt;/label&gt;
          &lt;cfset valueQuery = viewstate.getValue("<xsl:value-of select="sourceobject"/>List") /&gt;
				

					&lt;cfif viewstate.exists("<xsl:value-of select="alias"/>|<xsl:value-of select="sourcekey"/>")&gt;
						&lt;cfset selectedList = viewstate.getValue("<xsl:value-of select="alias"/>|<xsl:value-of select="sourcekey"/>")/&gt;
					&lt;cfelse&gt;
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
						&lt;cfelseif isStruct(selected)&gt;
							&lt;cfset selectedList = structKeyList(selected)&gt;
						&lt;cfelseif isArray(selected)&gt;
							&lt;cfset selectedList = "" /&gt;
							&lt;cfloop from="1" to="#arrayLen(selected)#" index="i"&gt;
								&lt;cfset selectedList = listAppend(selectedList, selected[i].get<xsl:value-of select="sourcekey"/>()) /&gt;
							&lt;/cfloop&gt;
						&lt;/cfif&gt;
					&lt;/cfif&gt;
				            
          &lt;!--- 
            hidden makes the field always defined.  if this wasn't here, and you deleted this whole field
            from the control, you'd wind up deleting all child records during a genericCommit...
          ---&gt;
          &lt;input type="hidden" name="<xsl:value-of select="alias"/>|<xsl:value-of select="sourcekey"/>" value="" /&gt;
	        &lt;div class="formfieldinputstack"&gt;
          &lt;cfoutput query="valueQuery"&gt;
            &lt;label for="<xsl:value-of select="alias"/>_#valueQuery.<xsl:value-of select="sourcekey"/>#"&gt;&lt;input type="checkbox" name="<xsl:value-of select="alias"/>|<xsl:value-of select="sourcekey"/>" id="<xsl:value-of select="alias"/>_#valueQuery.<xsl:value-of select="sourcekey"/>#" value="#valueQuery.<xsl:value-of select="sourcekey"/>#"&lt;cfif listFindNoCase(selectedList, "#valueQuery.<xsl:value-of select="sourcekey"/>#")&gt; checked&lt;/cfif&gt;/&gt;#valueQuery.<xsl:value-of select="sourcecolumn"/>#&lt;/label&gt;&lt;br /&gt;
          &lt;/cfoutput&gt;
	        &lt;/div&gt;
        &lt;/div&gt;
          
      </xsl:if>
    </xsl:if>
  </xsl:if>
</xsl:for-each>
&lt;cfoutput&gt;
&lt;div class="controls"&gt;
 	&lt;input type="submit" value="Save" /&gt;
  &lt;input type="button" value="Cancel" onclick="document.location.replace('#listEvent#')" /&gt;
&lt;/div&gt;
&lt;/cfoutput&gt;
&lt;/fieldset&gt;
&lt;/cfform&gt;
    
	</xsl:template>
</xsl:stylesheet>