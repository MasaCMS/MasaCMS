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
<cfcomponent extends="mura.bean.bean" output="false" hint="This provides plugin config xml custom settings functionality">

<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="hint" type="string" default="" required="true" />
<cfproperty name="type" type="string" default="TextBox" required="true" />
<cfproperty name="required" type="string" default="false" required="true" />
<cfproperty name="validation" type="string" default="" required="true" />
<cfproperty name="regex" type="string" default="" required="true" />
<cfproperty name="message" type="string" default="" required="true" />
<cfproperty name="label" type="string" default="" required="true" />
<cfproperty name="settingValue" type="string" default="" required="true" />
<cfproperty name="optionList" type="string" default="" required="true" />
<cfproperty name="optionListLabel" type="string" default="" required="true" />

<cffunction name="init" output="false">
	<cfset super.init(argumentCollection=arguments)>

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

	<cfreturn this />
</cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="set"  output="false">
	<cfargument name="theXML">
	<cfargument name="moduleID">
	<cfset var i="">

	<cfloop list="name,type,hint,required,validation,regex,message,label,optionlist,optionlabellist" index="i">
		<cfif structKeyExists(arguments.theXML,i)>
			<cfset evaluate("set#i#(arguments.theXML[i].xmlText)")/>
		<cfelseif structKeyExists(arguments.theXML.xmlAttributes,i)>
			<cfset evaluate("set#i#(arguments.theXML.xmlAttributes[i])")/>
		</cfif>
	</cfloop>

	<cfset setModuleID(arguments.moduleID)/>
	<cfset loadSettingValue()/>

	<cfreturn this>

</cffunction>

<cffunction name="getName" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
</cffunction>

<cffunction name="getModuleID" output="false">
	<cfreturn variables.instance.ModuleID />
</cffunction>

<cffunction name="setModuleID" output="false">
	<cfargument name="ModuleID" type="String" />
	<cfset variables.instance.ModuleID = trim(arguments.ModuleID) />
</cffunction>

<cffunction name="getHint" output="false">
	<cfreturn variables.instance.Hint />
</cffunction>

<cffunction name="setHint" output="false">
	<cfargument name="Hint" type="String" />
	<cfset variables.instance.Hint = trim(arguments.Hint) />
</cffunction>

<cffunction name="getType" output="false">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="setType" output="false">
	<cfargument name="Type" type="String" />
	<cfset variables.instance.Type = trim(arguments.Type) />
</cffunction>

<cffunction name="getRequired" output="false">
	<cfreturn variables.instance.Required />
</cffunction>

<cffunction name="setRequired" output="false">
	<cfargument name="Required" type="String" />
	<cfset variables.instance.Required = trim(arguments.Required) />
</cffunction>

<cffunction name="getValidation" output="false">
	<cfreturn variables.instance.validation />
</cffunction>

<cffunction name="setValidation" output="false">
	<cfargument name="validation" type="String" />
	<cfset variables.instance.validation = trim(arguments.validation) />
</cffunction>

<cffunction name="getRegex" output="false">
	<cfreturn variables.instance.Regex />
</cffunction>

<cffunction name="setRegex" output="false">
	<cfargument name="Regex" type="String" />
	<cfset variables.instance.Regex = trim(arguments.Regex) />
</cffunction>

<cffunction name="getMessage" output="false">

	<cfreturn variables.instance.Message />

</cffunction>

<cffunction name="setMessage" output="false">
	<cfargument name="Message" type="String" />
	<cfset variables.instance.Message = trim(arguments.Message) />
</cffunction>

<cffunction name="getLabel" output="false">
	<cfif len(variables.instance.Label)>
	<cfreturn variables.instance.Label />
	<cfelse>
	<cfreturn variables.instance.name />
	</cfif>
</cffunction>

<cffunction name="setLabel" output="false">
	<cfargument name="Label" type="String" />
	<cfset variables.instance.Label = trim(arguments.Label) />
</cffunction>

<cffunction name="getSettingValue" output="false">
	<cfreturn variables.instance.SettingValue />
</cffunction>

<cffunction name="setSettingValue" output="false">
	<cfargument name="SettingValue" type="String" />
	<cfset variables.instance.SettingValue = trim(arguments.SettingValue) />
</cffunction>

<cffunction name="getOptionList" output="false">
	<cfreturn variables.instance.optionList />
</cffunction>

<cffunction name="setOptionList" output="false">
	<cfargument name="OptionList" type="String" />
	<cfset variables.instance.OptionList = trim(arguments.OptionList) />
</cffunction>

<cffunction name="getOptionLabelList" output="false">
	<cfreturn variables.instance.OptionLabelList />
</cffunction>

<cffunction name="setOptionLabelList" output="false">
	<cfargument name="OptionLabelList" type="String" />
	<cfset variables.instance.OptionLabelList = trim(arguments.OptionLabelList) />
</cffunction>

<cffunction name="renderSetting" output="false">
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
<cfsavecontent variable="str"><cfoutput><cfif listLen(getOptionList(),'^')><cfloop from="1" to="#listLen(getOptionList(),'^')#" index="o"><cfset optionValue=listGetAt(getOptionList(),o,'^') /><label class="radio inline"><input type="radio" id="#key#" name="#key#" value="#XMLFormat(optionValue)#" <cfif optionValue eq renderValue>checked</cfif>/> <cfif len(getOptionLabelList())>#listGetAt(getOptionLabelList(),o,'^')#<cfelse>#optionValue#</cfif></label></cfloop></select></cfif></cfoutput></cfsavecontent>
</cfcase>
</cfswitch>

<cfreturn str/>
</cffunction>

<cffunction name="loadSettingValue"  output="false">
<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tpluginsettings
	where name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getName()#">
	and moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getModuleID()#">
	</cfquery>

	<cfset setSettingValue(rs.settingValue) />
</cffunction>

</cfcomponent>
