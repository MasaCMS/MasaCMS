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
--->
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


</cfcomponent>