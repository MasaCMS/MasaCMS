<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="mura.cfobject" output="false">
<cffunction name="init" access="public" returntype="ANY" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="emailDAO" type="any" required="yes"/>
<cfargument name="emailGateway" type="any" required="yes"/>
<cfargument name="emailUtility" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.emailDAO=arguments.emailDAO />
		<cfset variables.emailGateway=arguments.emailGateway />
		<cfset variables.emailUtility=arguments.emailUtility />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.globalUtility=arguments.utility />
	<cfreturn this />	
</cffunction>

<cffunction name="getList" access="public" returntype="query" output="false">
		<cfargument name="data" type="struct"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.emailGateway.getList(data) />
		
		<cfreturn rs />
</cffunction>
	
<cffunction name="getPrivateGroups" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.emailGateway.getPrivateGroups(arguments.siteid) />
		
		<cfreturn rs />
</cffunction>

<cffunction name="getPublicGroups" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.emailGateway.getPublicGroups(arguments.siteid) />
		
		<cfreturn rs />
</cffunction>

<cffunction name="getMailingLists" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.emailGateway.getMailingLists(arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>
	
<cffunction name="update" access="public" returntype="void" output="false">
	<cfargument name="args" type="struct"/>	
	<cfset var emailBean = "" /> 
	<cfset var data=arguments.args />
	
	<cfswitch expression="#data.action#">
	<cfcase value="Update">
		<cfset data.bodyhtml=replaceNoCase(data.bodyhtml,'src="/','src="http://#variables.settingsManager.getSite(data.siteid).getDomain("production")##variables.configBean.getServerPort()#/','ALL')>
		<cfset data.bodyhtml=replaceNoCase(data.bodyhtml,"src='/",'src="http://#variables.settingsManager.getSite(data.siteid).getDomain("production")##variables.configBean.getServerPort()#/','ALL')>
		<cfset data.bodyhtml=replaceNoCase(data.bodyhtml,'href="/','href="http://#variables.settingsManager.getSite(data.siteid).getDomain("production")##variables.configBean.getServerPort()#/','ALL')>
		<cfset data.bodyhtml=replaceNoCase(data.bodyhtml,"href='/",'href="http://#variables.settingsManager.getSite(data.siteid).getDomain("production")##variables.configBean.getServerPort()#/','ALL')>
		
		<cfif data.deliveryDate neq '' AND isDate(data.deliveryDate)>
			<cfif data.timepart eq "PM">
				<cfset data.timehour = data.timehour + 12>
			</cfif>
			<cfif data.timehour eq 24>
				<cfset data.timehour = 0>
			</cfif>
			<cfset data.deliveryDate = createDateTime(year(data.deliveryDate), month(data.deliveryDate), day(data.deliveryDate), data.timehour, data.timeminute, "0")>
		</cfif>
		
		<cfif data.sendNow eq "true">
			<cfset data.deliveryDate = now()>
		</cfif>
		
		<cfset emailBean=application.serviceFactory.getBean("emailBean") />
		<cfset emailBean.set(data) />
		<cfset emailBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,"^")#") />
		<cfset emailBean.setLastUpdateByID("#listGetAt(getAuthUser(),1,"^")#") />
		<cfset variables.globalUtility.logEvent("EmailID: #emailBean.getEmailID()# Subject:#emailBean.getSubject()# was updated","mura-email","Information",true) />
		<cfset variables.emailDAO.update(emailbean) />
		<cfset variables.emailUtility.send() />
	</cfcase>
	
	<cfcase value="Delete">
		<cfset emailBean=read(data.emailid) />
		<cfset variables.globalUtility.logEvent("EmailID:#data.emailid# Subject:#emailBean.getSubject()# was deleted","mura-email","Information",true) />
		<cfset variables.emailDAO.delete(data.emailid) />
	</cfcase>
	
	<cfcase value="Add">
		<cfset data.bodyhtml=replaceNoCase(data.bodyhtml,'src="/','src="http://#variables.settingsManager.getSite(data.siteid).getDomain("production")##variables.configBean.getServerPort()#/','ALL')>
		<cfset data.bodyhtml=replaceNoCase(data.bodyhtml,"src='/",'src="http://#variables.settingsManager.getSite(data.siteid).getDomain("production")##variables.configBean.getServerPort()#/','ALL')>
		<cfset data.bodyhtml=replaceNoCase(data.bodyhtml,'href="/','href="http://#variables.settingsManager.getSite(data.siteid).getDomain("production")##variables.configBean.getServerPort()#/','ALL')>
		<cfset data.bodyhtml=replaceNoCase(data.bodyhtml,"href='/",'href="http://#variables.settingsManager.getSite(data.siteid).getDomain("production")##variables.configBean.getServerPort()#/','ALL')>
		
		<cfif isDate(data.deliveryDate)>
			<cfif data.timepart eq "PM">
				<cfset data.timehour = data.timehour + 12>
				<cfif data.timehour eq 24>
					<cfset data.timehour = 12>
				</cfif>
			<cfelse>
				<cfif data.timehour eq 12>
					<cfset data.timehour = 0>
				</cfif>
			</cfif>
			
			<cfset data.deliveryDate = createDateTime(year(data.deliveryDate), month(data.deliveryDate), day(data.deliveryDate), data.timehour, data.timeminute, "0")>
		</cfif>
		
		<cfif data.sendNow eq "true">
			<cfset data.deliveryDate = now()>
		</cfif>
		
		<cfset emailBean=application.serviceFactory.getBean("emailBean") />
		<cfset emailBean.set(data) />
		<cfset emailBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,"^")#") />
		<cfset emailBean.setLastUpdateByID("#listGetAt(getAuthUser(),1,"^")#") />
		<cfset emailBean.setEmailID(createuuid()) />
		<cfset variables.globalUtility.logEvent("Email:#emailBean.getEmailID()# Subject:#emailBean.getSubject()# was created","mura-email","Information",true) />
		<cfset variables.emailDAO.create(emailbean) />
		<cfset variables.emailUtility.send() />
		
	</cfcase>
	</cfswitch>

</cffunction>

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="emailid" type="string" default="" required="yes" />
	<cfset var emailBean ="" />
	
	<cfset emailBean=variables.emailDAO.read(arguments.emailid) />
	
	<cfreturn emailBean />
</cffunction>

<cffunction name="send" access="public" output="false" returntype="void" >
	
	<cfset variables.emailUtility.send() />
	
</cffunction>

<cffunction name="sendEmail" access="public" output="false" returntype="any" >
	<cfargument name="fromName" type="string" required="yes">
	<cfargument name="fromEmail" type="string" required="yes">
	<cfargument name="toEmail" type="string" required="yes"> 
	<cfargument name="subject" type="string" required="yes">
	<cfargument name="body" type="string" required="yes"> 
	<cfargument name="htmlBody" type="string" required="yes"> 
	<cfset var returnVar = "" />
	
	<cfset returnVar = variables.emailUtility.sendEmail(arguments.fromName, arguments.fromEmail, arguments.toEmail, arguments.subject, arguments.body, arguments.htmlBody) />
	
	<cfreturn returnVar />
</cffunction>

<cffunction name="forward" access="public" output="false" returntype="void" >
<cfargument name="data" type="struct"/>

	<cfset variables.emailUtility.forward(data) />
	
</cffunction>

<cffunction name="track" output="false" returntype="void">
		<cfargument name="emailid" type="string" required="yes">
		<cfargument name="email" type="string" required="yes">
		<cfargument name="type" type="string" required="yes">

		<cfset variables.emailUtility.track(arguments.emailid,arguments.email,arguments.type)/>
</cffunction>

<cffunction name="getStat" output="false" returntype="numeric" access="public">
	<cfargument name="emailid" type="string">
	<cfargument name="type" type="string">

	<cfreturn variables.emailGateway.getStat(arguments.emailid,arguments.type) />
</cffunction>

<cffunction name="trackBounces" output="false" returntype="void">
	<cfargument name="siteid" type="string" required="yes">
	
	<cfset variables.emailUtility.trackBounces(arguments.siteid) />
</cffunction>

<cffunction name="getBounces" output="false" returntype="any" access="public">
	<cfargument name="emailid" type="string">

	<cfreturn variables.emailGateway.getBounces(arguments.emailid) />
</cffunction>

<cffunction name="getReturns" output="false" returntype="any" access="public">
	<cfargument name="emailid" type="string">

	<cfreturn variables.emailGateway.getReturns(arguments.emailid) />
</cffunction>

<cffunction name="getReturnsByUser" output="false" returntype="any" access="public">
	<cfargument name="emailid" type="string">

	<cfreturn variables.emailGateway.getReturnsByUser(arguments.emailid) />
</cffunction>

<cffunction name="getSentCount" output="false" returntype="any" access="public">
	<cfargument name="siteid" type="string" default="">
	<cfargument name="startDate" type="string" default="">
	<cfargument name="stopDate" type="string" default="">

	<cfreturn variables.emailGateway.getSentCount(arguments.siteid, arguments.startDate, arguments.stopDate) />
</cffunction>

<cffunction name="getAllBounces" output="false" returntype="any" access="public">
	<cfargument name="data" type="struct">
	
	<cfreturn variables.emailGateway.getAllBounces(arguments.data) />
</cffunction>

<cffunction name="deleteBounces" output="false" returntype="void" access="public">
	<cfargument name="data" type="struct">
	
	<cfreturn variables.emailGateway.deleteBounces(arguments.data) />
</cffunction>

<cffunction name="getAddresses" returntype="query" access="public">
<cfargument name="groupList" type="String" required="true">
<cfargument name="siteID" type="String" required="true">

	<cfreturn variables.emailUtility.getAddresses(arguments.groupList,arguments.siteID) />
</cffunction>

<cffunction name="getEmailActivity" access="public" output="false" returntype="query" >
		<cfargument name="siteid" type="string" />
		<cfargument name="limit" type="numeric" required="true" default="3">
		<cfargument name="startDate" type="string" required="true" default="">
		<cfargument name="stopDate" type="string" required="true" default="">
		
		<cfreturn variables.emailGateway.getEmailActivity(arguments.siteID,arguments.limit,arguments.startDate,arguments.stopDate) />
</cffunction>
</cfcomponent>