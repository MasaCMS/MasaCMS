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

<cffunction name="init" access="public" returntype="any" output="false">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="memberDAO" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="contentRenderer" type="any" required="yes"/>

		<cfset variables.configBean=arguments.configBean />
		<cfset variables.memberDAO=arguments.memberDAO />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.contentRenderer=arguments.contentRenderer />
		
	<cfreturn this />
</cffunction>

<cffunction name="setMailer" returntype="any" access="public" output="false">
<cfargument name="mailer"  required="true">

	<cfset variables.mailer=arguments.mailer />

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />
	
	<cfset var memberBean=getBean("memberBean") />
	<cfset memberBean.set(arguments.data) />
	
	<cfset variables.memberDAO.delete(memberBean) />
	
</cffunction>

<cffunction name="deleteAll" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />
	
	<cfset var memberBean=getBean("memberBean") />
	<cfset memberBean.set(arguments.data) />
	
	<cfset variables.memberDAO.deleteAll(memberBean) />
	
</cffunction>

<cffunction name="create" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />
	<cfargument name="mailingListManager" type="any" required="yes"/>
	
	<cfset var memberBean=""/>
	<cfset var listBean=""/>
	
	<cfif arguments.data.mlid neq ''>
		<cftry>
		<cfset memberBean=variables.memberDAO.read(arguments.data.email,arguments.data.siteid) />
		<cfset memberBean.set(arguments.data) />
		<cfif memberBean.getIsVerified() eq 0>
			<cfset listBean=arguments.mailingListManager.read(arguments.data.mlid,arguments.data.siteid) />
			<cfset sendVerification(arguments.data.email,arguments.data.mlid,arguments.data.siteid,listBean.getName())>
		</cfif>
		<cfset variables.memberDAO.update(memberBean) />
		<cfset variables.memberDAO.create(memberBean) />
		<cfcatch type="database"></cfcatch>
		</cftry>
	</cfif>

</cffunction>

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="data" type="struct" />
	<cfset var memberBean="">
	
	<cfif not structKeyExists(arguments.data,"mailinglistBean")>
		<cfset arguments.data.mailinglistBean="">	
	</cfif>
	
	<cfset memberBean = variables.memberDAO.read(arguments.data.email,arguments.data.siteid,arguments.data.mailinglistBean) />
	
	<cfreturn memberBean />
	
</cffunction>

<cffunction name="masterSubscribe" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />
	<cfargument name="mailingListManager" type="any" required="yes"/>

	<cfset deleteAll(arguments.data) />
	<cfset create(arguments.data,arguments.mailingListManager) />

</cffunction>

<cffunction name="sendVerification" returntype="void" output="false">
<cfargument name="sendto" type="string" default="">
<cfargument name="mlid" type="string" default="">
<cfargument name="siteid" type="string" default="">
<cfargument name="mailingListName" type="string" default="">

<cfset var rsReturnForm=""/>
<cfset var mailingListConfirmScript=""/>
<cfset var mailText=""/>
<cfset var listName=arguments.mailingListName/>
<cfset var returnURL=""/>
<cfset var contactEmail=variables.settingsManager.getSite(arguments.siteid).getContact()/>
<cfset var contactName=variables.settingsManager.getSite(arguments.siteid).getSite()/>
<cfset var finder=""/>
<cfset var theString=""/>

<cfquery name="rsReturnForm" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
select filename from tcontent where siteid='#arguments.siteid#'  and active =1 and ((display=1) or (display=2  and tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)) 
and contenthistid in (select contenthistid from tcontentobjects where object='mailing_list_master')	
</cfquery>

<cfset returnURL="http://#variables.settingsManager.getSite(arguments.siteid).getDomain()##variables.configBean.getServerPort()##variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteid,rsreturnform.filename)#?doaction=validateMember&mlid=#arguments.mlid#&siteid=#URLEncodedFormat(arguments.siteid)#&email=#arguments.sendto#&nocache=1"/>
<cfset mailingListConfirmScript = variables.settingsManager.getSite(arguments.siteid).getmailingListConfirmScript()/>

<cfoutput>
<cfif mailingListconfirmScript neq ''>
	<cfset theString = mailingListConfirmScript/>
	<cfset finder=refind('##.+?##',theString,1,"true")>
	<cfloop condition="#finder.len[1]#">
		<cftry>
			<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'#trim(evaluate(mid(theString, finder.pos[1], finder.len[1])))#')>
			<cfcatch>
				<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'')>
			</cfcatch>
		</cftry>
		<cfset finder=refind('##.+?##',theString,1,"true")>
	</cfloop>
	<cfset mailingListConfirmScript = theString/>

	<cfsavecontent variable="mailText">
#mailingListConfirmScript#
	</cfsavecontent>

<cfelse>

	<cfsavecontent variable="mailText">
You've requested to be signed up for the mailing list: #listName#

If this is correct, please verify your email address by entering the following url into your browser window:

#returnURL#

Please contact #contactEmail# if you have any questions or comments on this process.

Thank you,

The #contactName# staff
	</cfsavecontent>

</cfif>
</cfoutput>

<cfset variables.mailer.sendText(mailText,
				arguments.sendto,
				"Mailing List Manager",
				"Mailing List Verification",
				arguments.siteid) />

	
</cffunction>

<cffunction name="validateMember" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />
	
	
	<cfquery>
		update tmailinglistmembers
		set isVerified = 1 
		where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.email#"> and
		mlid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#data.mlid#">)  and
		siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.siteid#">
	</cfquery>
	
</cffunction>

</cfcomponent>