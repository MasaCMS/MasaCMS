<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">
	
<cfset variables.instance.name=""/>
<cfset variables.instance.hint=""/>
<cfset variables.instance.type="TextBox"/>
<cfset variables.instance.required="false"/>
<cfset variables.instance.validation=""/>
<cfset variables.instance.regex=""/>
<cfset variables.instance.message=""/>
<cfset variables.instance.label=""/>
<cfset variables.instance.settingValue=""/>
<cfset variables.instance.optionList=""/>
<cfset variables.instance.optionLabelList=""/>
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfreturn this />
</cffunction>

<cffunction name="set"  access="public" output="false" returntype="void">
<cfargument name="theXML">
<cfargument name="moduleID">

<cfset setName(arguments.theXML.name.xmlText)/>
<cfset setType(arguments.theXML.type.xmlText)/>
<cfset setHint(arguments.theXML.hint.xmlText)/>
<cfset setRequired(arguments.theXML.required.xmlText)/>
<cfset setValidation(arguments.theXML.validation.xmlText)/>
<cfset setRegex(arguments.theXML.regex.xmlText)/>
<cfset setMessage(arguments.theXML.message.xmlText)/>
<cfset setLabel(arguments.theXML.label.xmlText)/>
<cfset setSettingValue(arguments.theXML.defaultvalue.xmlText)/>
<cfset setOptionList(arguments.theXML.optionlist.xmlText)/>
<cfset setOptionLabelList(arguments.theXML.optionlabellist.xmlText)/>
<cfset setModuleID(arguments.moduleID)/>
<cfset loadSettingValue()/>

</cffunction>
  
<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset variables.instance.errors=structnew() />
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
</cffunction>

<cffunction name="getModuleID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ModuleID />
</cffunction>

<cffunction name="setModuleID" access="public" output="false">
	<cfargument name="ModuleID" type="String" />
	<cfset variables.instance.ModuleID = trim(arguments.ModuleID) />
</cffunction>

<cffunction name="getHint" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Hint />
</cffunction>

<cffunction name="setHint" access="public" output="false">
	<cfargument name="Hint" type="String" />
	<cfset variables.instance.Hint = trim(arguments.Hint) />
</cffunction>

<cffunction name="getType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="setType" access="public" output="false">
	<cfargument name="Type" type="String" />
	<cfset variables.instance.Type = trim(arguments.Type) />
</cffunction>

<cffunction name="getRequired" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Required />
</cffunction>

<cffunction name="setRequired" access="public" output="false">
	<cfargument name="Required" type="String" />
	<cfset variables.instance.Required = trim(arguments.Required) />
</cffunction>

<cffunction name="getValidation" returntype="String" access="public" output="false">
	<cfreturn variables.instance.validation />
</cffunction>

<cffunction name="setValidation" access="public" output="false">
	<cfargument name="validation" type="String" />
	<cfset variables.instance.validation = trim(arguments.validation) />
</cffunction>

<cffunction name="getRegex" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Regex />
</cffunction>

<cffunction name="setRegex" access="public" output="false">
	<cfargument name="Regex" type="String" />
	<cfset variables.instance.Regex = trim(arguments.Regex) />
</cffunction>

<cffunction name="getMessage" returntype="String" access="public" output="false">
	
	<cfreturn variables.instance.Message />
	
</cffunction>

<cffunction name="setMessage" access="public" output="false">
	<cfargument name="Message" type="String" />
	<cfset variables.instance.Message = trim(arguments.Message) />
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
</cffunction>

<cffunction name="getSettingValue" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SettingValue />
</cffunction>

<cffunction name="setSettingValue" access="public" output="false">
	<cfargument name="SettingValue" type="String" />
	<cfset variables.instance.SettingValue = trim(arguments.SettingValue) />
</cffunction>

<cffunction name="getOptionList" returntype="String" access="public" output="false">
	<cfreturn variables.instance.optionList />
</cffunction>

<cffunction name="setOptionList" access="public" output="false">
	<cfargument name="OptionList" type="String" />
	<cfset variables.instance.OptionList = trim(arguments.OptionList) />
</cffunction>

<cffunction name="getOptionLabelList" returntype="String" access="public" output="false">
	<cfreturn variables.instance.OptionLabelList />
</cffunction>

<cffunction name="setOptionLabelList" access="public" output="false">
	<cfargument name="OptionLabelList" type="String" />
	<cfset variables.instance.OptionLabelList = trim(arguments.OptionLabelList) />
</cffunction>

<cffunction name="renderSetting" output="false" returntype="string">
<cfargument name="theValue" required="true" default="useMuraDefault"/>
<cfset var renderValue= arguments.theValue />
<cfset var optionValue= "" />
<cfset var str=""/>
<cfset var key=getName() />
<cfset var o=0/>

<cfswitch expression="#getType()#">
<cfcase value="Text,TextBox">
<cfsavecontent variable="str"><cfoutput><input type="text" name="#key#" id="#key#" label="#XMLFormat(getlabel())#" value="#HTMLEditFormat(renderValue)#" required="#getRequired()#"<cfif len(getvalidation())> validate="#getValidation()#"</cfif><cfif getvalidation() eq "Regex"> regex="#getRegex()#"</cfif><cfif len(getMessage())> message="#XMLFormat(getMessage())#"</cfif>/></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="TextArea">
<cfsavecontent variable="str"><cfoutput><textarea name="#key#" id="#key#" label="#XMLFormat(getlabel())#" required="#getRequired()#"<cfif len(getMessage())> message="#XMLFormat(getMessage())#"</cfif>>#HTMLEditFormat(renderValue)#</textarea></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="Select,SelectBox,MultiSelectBox">
<cfsavecontent variable="str"><cfoutput><select name="#key#" id="#key#" label="#XMLFormat(getlabel())#" required="#getRequired()#"<cfif len(getMessage())> message="#XMLFormat(getMessage())#"</cfif><cfif getType() eq "MultiSelectBox"> multiple</cfif>><cfif listLen(getOptionList(),'^')><cfloop from="1" to="#listLen(getOptionList(),'^')#" index="o"><cfset optionValue=listGetAt(getOptionList(),o,'^') /><option value="#XMLFormat(optionValue)#" <cfif optionValue eq renderValue or listFind(renderValue,optionValue)>selected</cfif>><cfif len(getOptionLabelList())>#listGetAt(getOptionLabelList(),o,'^')#<cfelse>#optionValue#</cfif></option></cfloop></cfif></select></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="Radio,RadioGroup">
<cfsavecontent variable="str"><cfoutput><cfif listLen(getOptionList(),'^')><cfloop from="1" to="#listLen(getOptionList(),'^')#" index="o"><cfset optionValue=listGetAt(getOptionList(),o,'^') /><input type="radio" id="#key#" name="#key#" value="#XMLFormat(optionValue)#" <cfif optionValue eq renderValue>checked</cfif>/> <cfif len(getOptionLabelList())>#listGetAt(getOptionLabelList(),o,'^')#<cfelse>#optionValue#</cfif> </cfloop></select></cfif></cfoutput></cfsavecontent>
</cfcase>
</cfswitch>

<cfreturn str/>
</cffunction>

<cffunction name="loadSettingValue"  access="public" output="false" returntype="void">
<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tpluginsettings 
	where name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getName()#">
	and moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getModuleID()#">
	</cfquery>
	
	<cfset setSettingValue(rs.settingValue) />
</cffunction>
<!--- 
<cffunction name="getOptions" access="public" returntype="query">
	<cfset var rs = "" />

	<cfif not isQuery(variables.instance.options)>
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select * from TClassExtendAttributeOptions
		where attributeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getAttributeID()#">
		order by orderno 
		</cfquery>
		
		<cfset variables.instance.options=rs />
	</cfif>

	<cfreturn variables.instance.options />

</cffunction>

<cffunction name="setOptions" access="public" returntype="void">
<cfargument name="options">
<cfset var o=1/>

<cfif isQuery(arguments.options)>
	<cfset variables.instance.options=arguments.options />
<cfelse>
	<cfset variables.instance.options=queryNew("optionID,attributeID,siteID,optionValue,label,orderno","cf_sql_varchar,cf_sql_varchar,cf_sql_varchar,cf_sql_varchar,cf_sql_varchar,cf_sql_varchar") />

	<cfloop condition="structkeyExist(arguments.options,'options#o#')">
	
		<cfif len(arguments.options["label#o#"])
			or len(arguments.options["optionValue#o#"])>
			
			<cfset querySetCell(variables.instance.options,"optionID",createUUID(),o) />
			<cfset querySetCell(variables.instance.options,"attributeID",getAttributeID(),o) />
			<cfset querySetCell(variables.instance.options,"siteID",getSiteID(),o) />
			<cfset querySetCell(variables.instance.options,"orderno",o,o) />
			<cfset querySetCell(variables.instance.options,"label",arguments.options["label#o#"],o) />
			<cfset querySetCell(variables.instance.options,"optionValue",arguments.options["optionValue#o#"],o) />

		</cfif>
	<cfset o=o+1/>
	</cfloop>
</cfif>

</cffunction>

<cffunction name="deleteOptions" returntype="void">
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from TExtendAttributeOptions
		where attributeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getAttributeID()#">
	</cfquery>
</cffunction>

<cffunction name="saveOptions" access="public" returntype="void">
	<cfif isQuery(variables.instance.options)>
		<cfset deleteOptions() />
		
		<cfloop query="variables.instance.options">
			<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into TClassExtendAttributeOptions
			(optionID,attributeID,siteID,optionValue,label,orderno)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.options.optionID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.options.attributeID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.options.siteID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.options.optionValue neq '',de('no'),de('yes'))#" value="#variables.instance.options.optionValue#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.options.label neq '',de('no'),de('yes'))#" value="#variables.instance.options.label#">,
				variables.instance.options.orderno
			)
			</cfquery>
		</cfloop>

	</cfif>
	
</cffunction> --->

</cfcomponent>