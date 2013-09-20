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
<cfsilent>
<cfset variables.strField = "" />
<cfif arguments.field.isrequired>
	<cfset variables.strField = variables.strField & ' data-required="true" required="true"' />
</cfif>
<cfif structkeyexists(arguments.field,'size') and len(arguments.field.size)>
	<cfset variables.strField = strField & ' size="#arguments.field.size#"' />
</cfif>
<cfif structkeyexists(arguments.field,'placeholder') and len(arguments.field.placeholder)>
	<cfset variables.strField = strField & ' placeholder="#arguments.field.placeholder#"' />
</cfif>
<cfif structkeyexists(arguments.field,'maxlength') and len(arguments.field.maxlength)>
	<cfset variables.strField = variables.strField & ' maxlength="#arguments.field.maxlength#"' />
<cfelseif structkeyexists(arguments.field,'size') and len(arguments.field.size)>
	<cfset variables.strField = variables.strField & ' maxlength="#arguments.field.size#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cols') and len(arguments.field.cols)>
	<cfset variables.strField = variables.strField & ' cols="#arguments.field.cols#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cssid') and len(arguments.field.cssid)>
	<cfset variables.strField = variables.strField & ' id="#arguments.field.cssid#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cssclass') and len(arguments.field.cssclass)>
	<cfset variables.strField = variables.strField & ' class="#arguments.field.cssclass#"' />
</cfif>
<cfif len(arguments.field.validatemessage)>
	<cfset variables.strField = variables.strField & ' data-message="#replace(arguments.field.validatemessage,"""","&quot;","all")#"' />
</cfif>
<cfif len(arguments.field.validatetype)>
	<cfif arguments.field.validatetype eq "regex" and len(arguments.field.validateregex)>
		<cfset variables.strField = variables.strField & ' data-validate="#arguments.field.validatetype#" data-regex="#arguments.field.validateregex#"' />
	<cfelse>
		<cfset variables.strField = variables.strField & ' data-validate="#arguments.field.validatetype#"' />
	</cfif>
</cfif>
<cfif len(arguments.field.remoteid)>
	<cfset variables.strField = variables.strField & ' data-remoteid="#arguments.field.remoteid#"' />
</cfif>
</cfsilent>
<cfoutput>#variables.strField#</cfoutput>