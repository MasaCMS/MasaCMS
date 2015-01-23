<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.attributeID=0/>
<cfset variables.instance.ExtendSetID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.hint=""/>
<cfset variables.instance.type="TextBox"/>
<cfset variables.instance.orderno=1/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.required="false"/>
<cfset variables.instance.validation=""/>
<cfset variables.instance.regex=""/>
<cfset variables.instance.message=""/>
<cfset variables.instance.label=""/>
<cfset variables.instance.defaultValue=""/>
<cfset variables.instance.optionList=""/>
<cfset variables.instance.optionLabelList=""/>
<cfset variables.instance.isNew=1/>
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	<cfargument name="contentRenderer">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.contentRenderer=arguments.contentRenderer />
	<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
	<cfreturn this />
</cffunction>

<cffunction name="set" output="false" access="public">
		<cfargument name="property" required="true">
		<cfargument name="propertyValue">  	
		
		<cfif not isDefined('arguments.data')>
			<cfif isSimpleValue(arguments.property)>
				<cfreturn setValue(argumentCollection=arguments)>
			</cfif>

			<cfset arguments.data=arguments.property>
		</cfif>

		<cfset var prop=""/>
		<cfset var tempFunc="">
		
		<cfif isquery(arguments.data)>
		
			<cfset setAttributeID(arguments.data.attributeID) />
			<cfset setSiteID(arguments.data.siteID) />
			<cfset setExtendSetID(arguments.data.ExtendSetID) />
			<cfset setName(arguments.data.name) />
			<cfset setHint(arguments.data.name) />
			<cfset setType(arguments.data.Type) />
			<cfset setOrderNo(arguments.data.orderno) />
			<cfset setIsActive(arguments.data.isActive) />
			<cfset setRequired(arguments.data.required) />
			<cfset setvalidation(arguments.data.validation) />
			<cfset setRegex(arguments.data.regex) />
			<cfset setMessage(arguments.data.Message) />
			<cfset setLabel(arguments.data.label) />
			<cfset setDefaultValue(arguments.data.DefaultValue) />
			<cfset setOptionList(arguments.data.optionList) />
			<cfset setOptionLabelList(arguments.data.optionLabelList) />
			
		<cfelseif isStruct(arguments.data)>
		<!--- <cfdump var="#arguments.data#"><cfabort> --->
			<cfloop collection="#arguments.data#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset tempFunc=this["set#prop#"]>
          			<cfset tempFunc(arguments.data['#prop#'])>
				</cfif>
			</cfloop>
			
		<!--- 	<cfif getType eq "radio" or getType() eq "select">
				<cfset setOptions(arguments.data)/>
			</cfif> --->
			
		</cfif>
		
		<cfset validate() />
		<cfreturn this>
</cffunction>
  
<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getAttributeID" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.attributeID />
</cffunction>

<cffunction name="setAttributeID" access="public" output="false">
	<cfargument name="AttributeID" type="numeric" />
	<cfset variables.instance.AttributeID =arguments.AttributeID />
	<cfreturn this>
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getExtendSetID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ExtendSetID />
</cffunction>

<cffunction name="setExtendSetID" access="public" output="false">
	<cfargument name="ExtendSetID" type="String" />
	<cfset variables.instance.ExtendSetID = trim(arguments.ExtendSetID) />
	<cfreturn this>
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
	<cfreturn this>
</cffunction>

<cffunction name="getHint" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Hint />
</cffunction>

<cffunction name="setHint" access="public" output="false">
	<cfargument name="Hint" type="String" />
	<cfset variables.instance.Hint = trim(arguments.Hint) />
	<cfreturn this>
</cffunction>

<cffunction name="getType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="setType" access="public" output="false">
	<cfargument name="Type" type="String" />
	<cfset variables.instance.Type = trim(arguments.Type) />
	<cfif variables.instance.Type eq "text">
		<cfset variables.instance.Type="TextBox">
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getOrderNo" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.OrderNo />
</cffunction>

<cffunction name="setOrderNo" access="public" output="false">
	<cfargument name="OrderNo" />
	<cfif isNumeric(arguments.OrderNo)>
	<cfset variables.instance.OrderNo = arguments.OrderNo />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.IsActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="IsActive" />
	<cfif isBoolean(arguments.IsActive)>
		<cfif arguments.IsActive>
			<cfset variables.instance.IsActive = 1 />
		<cfelse>
			<cfset variables.instance.IsActive = 0 />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getRequired" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Required />
</cffunction>

<cffunction name="setRequired" access="public" output="false">
	<cfargument name="Required" type="String" />
	<cfset variables.instance.Required = trim(arguments.Required) />
	<cfreturn this>
</cffunction>

<cffunction name="getValidation" returntype="String" access="public" output="false">
	<cfreturn variables.instance.validation />
</cffunction>

<cffunction name="setValidation" access="public" output="false">
	<cfargument name="validation" type="String" />
	<cfset variables.instance.validation = trim(arguments.validation) />
	<cfreturn this>
</cffunction>

<cffunction name="getRegex" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Regex />
</cffunction>

<cffunction name="setRegex" access="public" output="false">
	<cfargument name="Regex" type="String" />
	<cfset variables.instance.Regex = trim(arguments.Regex) />
	<cfreturn this>
</cffunction>

<cffunction name="getMessage" returntype="String" access="public" output="false">
	
	<cfreturn variables.instance.Message />
	
</cffunction>

<cffunction name="setMessage" access="public" output="false">
	<cfargument name="Message" type="String" />
	<cfset variables.instance.Message = trim(arguments.Message) />
	<cfreturn this>
</cffunction>

<cffunction name="getLabel" returntype="String" access="public" output="false">
	<cfif len(variables.instance.Label)>
	<cfreturn variables.instance.Label />
	<cfelse>
	<cfreturn variables.instance.name />
	</cfif>
</cffunction>

<cffunction name="setLabel" access="public" output="false">
	<cfargument name="Label" type="String" />
	<cfset variables.instance.Label = trim(arguments.Label) />
	<cfreturn this>
</cffunction>

<cffunction name="getDefaultValue" returntype="String" access="public" output="false">
	<cfreturn variables.instance.DefaultValue />
</cffunction>

<cffunction name="setDefaultValue" access="public" output="false">
	<cfargument name="DefaultValue" type="String" />
	<cfset variables.instance.DefaultValue = trim(arguments.DefaultValue) />
</cffunction>

<cffunction name="getOptionList" returntype="String" access="public" output="false">
	<cfreturn variables.instance.optionList />
</cffunction>

<cffunction name="setOptionList" access="public" output="false">
	<cfargument name="OptionList" type="String" />
	<cfset variables.instance.OptionList = trim(arguments.OptionList) />
	<cfreturn this>
</cffunction>

<cffunction name="getOptionLabelList" returntype="String" access="public" output="false">
	<cfreturn variables.instance.OptionLabelList />
</cffunction>

<cffunction name="setOptionLabelList" access="public" output="false">
	<cfargument name="OptionLabelList" type="String" />
	<cfset variables.instance.OptionLabelList = trim(arguments.OptionLabelList) />
	<cfreturn this>
</cffunction>

<cffunction name="getIsNew" output="false">
	<cfreturn variables.instance.isNew>
</cffunction>

<cffunction name="setIsNew" output="false">
	<cfargument name="isNew">
	<cfset variables.instance.isNew=arguments.isNew>
	<cfreturn this>
</cffunction>

<cffunction name="load"  access="public" output="false">
<cfset var rs=""/>
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select * from tclassextendattributes where 
	<cfif getAttributeID()>
	attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAttributeID()#">
	<cfelse>
	extendSetID=<cfqueryparam cfsqltype="cf_sql_char" maxlength="35" value="#getExtendSetID()#">
	and name=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#getName()#">
	</cfif>
	</cfquery>
	
	<cfif rs.recordcount>
		<cfset set(rs) />
		<cfset setIsNew(0)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="save"  access="public" output="false">
<cfset var rs=""/>
	
	
	<cfif getAttributeID()>
		
		<cfquery>
		update tclassextendattributes set
		ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getExtendSetID() neq '',de('no'),de('yes'))#" value="#getExtendSetID()#">,
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		name=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getName() neq '',de('no'),de('yes'))#" value="#getName()#">,
		hint=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getHint() neq '',de('no'),de('yes'))#" value="#getHint()#">,
		type=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
		isActive=#getIsActive()#,
		orderno=#getOrderno()#,
		required=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getRequired() neq '',de('no'),de('yes'))#" value="#getRequired()#">,
		validation=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getvalidation() neq '',de('no'),de('yes'))#" value="#getvalidation()#">,
		regex=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getRegex() neq '',de('no'),de('yes'))#" value="#getRegex()#">,
		message=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getMessage() neq '',de('no'),de('yes'))#" value="#getMessage()#">,
		label=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getLabel() neq '',de('no'),de('yes'))#" value="#getLabel()#">,
		defaultValue=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDefaultValue() neq '',de('no'),de('yes'))#" value="#getDefaultValue()#">,
		optionList=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getOptionList() neq '',de('no'),de('yes'))#" value="#getOptionList()#">,
		optionLabelList=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getOptionLabelList() neq '',de('no'),de('yes'))#" value="#getOptionLabelList()#">
		where attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
		</cfquery>
		
	<cfelse>
	
		<cflock name="addingAttribute#application.instanceID#" timeout="100">
			
			<cfquery>
			Insert into tclassextendattributes (ExtendSetID,siteID,name,hint,type,isActive,orderno,required,validation,regex,message,label,defaultValue,optionList,optionLabelList) 
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getExtendSetID() neq '',de('no'),de('yes'))#" value="#getExtendSetID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getName() neq '',de('no'),de('yes'))#" value="#getName()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getHint() neq '',de('no'),de('yes'))#" value="#getHint()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
			#getIsActive()#,
			#getOrderno()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getRequired() neq '',de('no'),de('yes'))#" value="#getRequired()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getvalidation() neq '',de('no'),de('yes'))#" value="#getvalidation()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getRegex() neq '',de('no'),de('yes'))#" value="#getRegex()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getMessage() neq '',de('no'),de('yes'))#" value="#getMessage()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getLabel() neq '',de('no'),de('yes'))#" value="#getLabel()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDefaultValue() neq '',de('no'),de('yes'))#" value="#getDefaultValue()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getOptionList() neq '',de('no'),de('yes'))#" value="#getOptionList()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getOptionLabelList() neq '',de('no'),de('yes'))#" value="#getOptionLabelList()#">
			)
			</cfquery>
			
			<cfquery name="rs"  datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select max(attributeID) as newID  from tclassextendattributes
			</cfquery>
			
			<cfset setAttributeID(rs.newID)/>
		
		</cflock>
	</cfif>
	
	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>
	
	<cfreturn this>
	<!--- <cfset saveOptions() /> --->
</cffunction>

<cffunction name="delete" access="public">
<cfset var fileManager=getBean("fileManager") />	
<cfset var rs =""/>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select attributeValue,baseID from tclassextenddata
	inner join tclassextendattributes on (tclassextenddata.attributeID=tclassextendattributes.attributeID)
	where tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	and attributeValue is not null
	and tclassextendattributes.type='File'
	</cfquery>
	
	<cfloop query="rs">
		<cfset fileManager.deleteIfNotUsed(rs.attributeValue,rs.baseID) />
	</cfloop>
	
	<cfquery>
	delete from tclassextenddata
	where attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	</cfquery>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select attributeValue,baseID from tclassextenddatauseractivity
	inner join tclassextendattributes on (tclassextenddatauseractivity.attributeID=tclassextendattributes.attributeID)
	where tclassextenddatauseractivity.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	and attributeValue is not null
	and tclassextendattributes.type='File'
	</cfquery>
	
	<cfloop query="rs">
		<cfset fileManager.deleteIfNotUsed(rs.attributeValue,rs.baseID) />
	</cfloop>
	
	<cfquery>
	delete from tclassextenddatauseractivity
	where attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	</cfquery>
	
	<cfquery>
	delete from tclassextendattributes
	where attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	</cfquery>
	
	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>
</cffunction>

<cffunction name="renderAttribute" output="false" returntype="string">
<cfargument name="theValue" required="true" default="useMuraDefault"/>
<cfargument name="bean" default=""/>
<cfargument name="compactDisplay" default="false">
<cfargument name="size" default="medium">
<cfset var renderValue= arguments.theValue />
<cfset var optionValue= "" />
<cfset var str=""/>
<!---<cfset var key="ext#replace(getAttributeID(),'-','','ALL')#"/>--->
<cfset var key=getName() />
<cfset var o=0/>
<cfset var optionlist=""/>
<cfset var optionLabellist=""/>
<cfset var renderInstanceValue=renderValue>
<cfif renderValue eq "useMuraDefault">
	<cfset renderValue=variables.contentRenderer.setDynamicContent(getDefaultValue()) />
</cfif>

<cfswitch expression="#getType()#">
<cfcase value="Hidden">
<cfsavecontent variable="str"><cfoutput><input type="hidden" name="#key#" id="#key#" data-label="#XMLFormat(getlabel())#" value="#HTMLEditFormat(renderValue)#" /></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="TextBox,Text">
<cfif getValidation() neq 'datetime'>
	<cfif getValidation() eq "date">
		<cfset renderValue=lsDateFormat(renderValue,session.dateKeyFormat) />
	</cfif>
	<cfsavecontent variable="str">
	<cfoutput><input type="text" name="#key#" class="text<cfif getValidation() eq 'date'> datepicker<cfelseif getValidation() eq 'Color'> colorpicker</cfif>" id="#key#" data-label="#XMLFormat(getlabel())#" value="#HTMLEditFormat(renderValue)#" data-required="#getRequired()#"<cfif len(getvalidation())> data-validate="#getValidation()#"</cfif><cfif getvalidation() eq "Regex"> data-regex="#getRegex()#"</cfif><cfif len(getMessage())> data-message="#XMLFormat(getMessage())#"</cfif> /></cfoutput>
	</cfsavecontent>
<cfelse>
	<cfsavecontent variable="str"><cfoutput><cf_datetimeselector name="#key#" datetime="#renderValue#" id="#key#" label="#getlabel()#" required="#getRequired()#" validation="#getValidation()#" regex="#getRegex()#" message="#getMessage()#"></cfoutput></cfsavecontent>
</cfif>
</cfcase>
<cfcase value="TextArea,HTMLEditor">
<cfsavecontent variable="str"><cfoutput><textarea name="#key#" id="#key#" data-label="#XMLFormat(getlabel())#" data-required="#getRequired()#"<cfif len(getMessage())> data-message="#XMLFormat(getMessage())#"</cfif><cfif getType() eq "HTMLEditor"> class="htmlEditor"</cfif><cfif len(getvalidation())> data-validate="#getValidation()#"</cfif><cfif getvalidation() eq "Regex"> data-regex="#getRegex()#"</cfif>>#HTMLEditFormat(renderValue)#</textarea></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="SelectBox,MultiSelectBox">
<cfset optionlist=variables.contentRenderer.setDynamicContent(getOptionList())/>
<cfset optionLabellist=variables.contentRenderer.setDynamicContent(getOptionLabelList())/>
<cfsavecontent variable="str"><cfoutput><cfif getType() EQ "MultiSelectBox"><input type="hidden" name="#key#" value="" /></cfif><select name="#key#" id="#key#" data-label="#XMLFormat(getlabel())#" data-required="#getRequired()#"<cfif len(getMessage())> data-message="#XMLFormat(getMessage())#"</cfif><cfif getType() eq "MultiSelectBox"> multiple="multiple"</cfif>><cfif listLen(optionlist,'^')><cfloop from="1" to="#listLen(optionlist,'^')#" index="o"><cfset optionValue=listGetAt(optionlist,o,'^') /><option value="#XMLFormat(optionValue)#"<cfif optionValue eq renderValue or listFind(renderValue,optionValue,"^") or listFind(renderValue,optionValue)> selected="selected"</cfif>><cfif len(optionlabellist)>#listGetAt(optionlabellist,o,'^')#<cfelse>#optionValue#</cfif></option></cfloop></cfif></select></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="RadioGroup">
<cfset optionlist=variables.contentRenderer.setDynamicContent(getOptionList())/>
<cfset optionLabellist=variables.contentRenderer.setDynamicContent(getOptionLabelList())/>
<cfsavecontent variable="str"><cfoutput><cfif listLen(optionlist,'^')><cfloop from="1" to="#listLen(optionlist,'^')#" index="o"><cfset optionValue=listGetAt(optionlist,o,'^') /><input type="radio" id="#key#" name="#key#" value="#XMLFormat(optionValue)#"<cfif optionValue eq renderValue> checked="checked"</cfif> /> <cfif len(optionlabellist)>#listGetAt(optionlabellist,o,'^')#<cfelse>#optionValue#</cfif> </cfloop></cfif></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="File">
<cfif isObject(arguments.bean)>
<cfsavecontent variable="str"><cfoutput><cf_fileselector name="#key#" property="#key#" id="#key#" label="#getlabel()#" required="#getRequired()#" validation="#getValidation()#" regex="#getRegex()#" message="#getMessage()#" bean="#arguments.bean#" compactDisplay="#arguments.compactDisplay#"  deleteKey="extDelete#getAttributeID()#" size="#arguments.size#"></cfoutput></cfsavecontent>
<cfelse>
<cfsavecontent variable="str"><cfoutput><input type="file" name="#key#" id="#key#" data-label="#XMLFormat(getlabel())#" value="" data-required="#getRequired()#"<cfif len(getvalidation())> data-validate="#getValidation()#"</cfif><cfif getvalidation() eq "Regex"> data-regex="#getRegex()#"</cfif><cfif len(getMessage())> data-message="#XMLFormat(getMessage())#"</cfif>/></cfoutput></cfsavecontent>
</cfif>
</cfcase>
</cfswitch>

<cfreturn str/>
</cffunction>

<cffunction name="getAllValues" ouput="false">
	<cfset var extensionData = duplicate(variables.instance) />
	<cfset structDelete(extensionData,"errors") />

	<cfreturn extensionData />
</cffunction>	

<cffunction name="getAsXML" ouput="false" returntype="xml">
	<cfargument name="documentXML">
	<cfargument name="includeIDs" type="boolean" default="false" >
	
	<cfset var extensionData = {} />
	<cfset var item = "" />
	<cfset var i = 0 />

	<cfset var xmlAttributes = XmlElemNew( documentXML, "", "attribute" ) />

	<cfset extensionData = duplicate(variables.instance) />
	<cfset structDelete(extensionData,"errors") />
	<cfif not(arguments.includeIDs)>
		<cfset structDelete(extensionData,"extendsetID") />
	</cfif>

	<cfset structDelete(extensionData,"isNew") />
	<cfset structDelete(extensionData,"isActive") />
	<cfset structDelete(extensionData,"siteid") />
	<!--- Append the personality to the root. --->
	<cfloop collection="#extensionData#" item="item">
		<cfif isSimpleValue(extensionData[item])>
			<cfif arguments.includeIDs or item neq "attributeid">
				<cfset xmlAttributes.XmlAttributes[lcase(item)] = extensionData[item] />
			</cfif>
		</cfif>
	</cfloop>

	<cfreturn xmlAttributes />	

</cffunction>

</cfcomponent>