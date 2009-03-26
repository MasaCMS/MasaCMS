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

<cfcomponent extends="mura.content.contentRenderer">

<!--- 
<cfset this.navOffSet=0/>
<cfset this.navDepthLimit=1000/>
<cfset this.navParentIdx=2/>
<cfset this.navGrandParentIdx=3/>
<cfset this.navDepthAjust=0/>
<cfset this.navSelfIdx=1/>
<cfset this.jslib="prototype"/>
<cfset this.jsLibLoaded=false>
<cfset this.longDateFormat="long"/>
<cfset this.shortDateFormat="short"/>
<cfset this.showMetaList="jpg,jpeg,png,gif">
<cfset this.imageInList="jpg,jpeg,png,gif">
<cfset this.personalization="user">
<cfset this.showAdminToolBar=true/>
<cfset this.renderHTMLHead=true/>
 --->

<!---
<cffunction name="dspObject" access="public" output="false" returntype="string">
<cfargument name="object" type="string">
<cfargument name="objectid" type="string">
<cfargument name="siteid" type="string">

	<cfset var theObject = "" />
	<cfset var theDisplayPoolID = application.settingsManager.getSite(request.siteid).getDisplayPoolID() />
	
		<cfsavecontent variable="theObject">
			<cfswitch expression="#arguments.object#">
				<cfcase value="example_object">
					<cfinclude template="/#application.configBean.getWebRootMap()#/#theDisplayPoolID#/includes/display_objects/custom/example.cfm.">
				</cfcase>
			</cfswitch>
		</cfsavecontent>
		
		<cfset theObject = theObject & super.dspObject(arguments.object, arguments.objectid, arguments.siteid)>		
		
		<cfreturn trim(theObject) />
</cffunction> --->

<!---  
This is to be used when the webroot is including /tasks/content/contentServerRoot.cfm 
for urls like http://yourdomain.com/index.cfm/path/tp/content/ 

<cffunction name="getURLStem" access="public" output="false" returntype="string">
	<cfargument name="siteID">
	<cfargument name="filename">
	
	<cfif arguments.filename neq ''>
		<cfif application.configBean.getStub() eq ''>
			<cfreturn "/index.cfm" & "/" & arguments.filename & "/"/>
		<cfelse>
			<cfreturn application.configBean.getStub() & "/"  & arguments.filename & "/" />
		</cfif>
	<cfelse>
		<cfreturn "/" />
	</cfif>

</cffunction>
--->

</cfcomponent>