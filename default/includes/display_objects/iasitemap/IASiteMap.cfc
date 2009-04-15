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

<cfcomponent>

<cffunction name="init" returntype="any">


<cfset variables.renderer=application.contentRenderer />

<cfreturn this/>
</cffunction>

<cffunction name="dspNestedItems" output="false" returntype="string">
		<cfargument name="contentid" type="string" >
		<cfargument name="viewDepth" type="numeric" required="true" default="1">
		<cfargument name="currDepth" type="numeric"  required="true"  default="1">
		<cfargument name="sortBy" type="string" default="orderno">
		<cfargument name="sortDirection" type="string" default="asc">
		<cfargument name="context" type="string" default="#application.configBean.getContext()#">
		<cfargument name="stub" type="string" default="#application.configBean.getStub()#">

		
		<cfset var rsSection=application.contentGateway.getKids('00000000000000000000000000000000000','#request.siteid#','#arguments.contentid#','default',now(),50,'',0,'#arguments.sortBy#','#arguments.sortDirection#','','')>
		<cfset var link=''>
		<cfset var isCurrent=false>
		<cfset var nest=''>
		<cfset var subnav=false>
		<cfset var theNav="">

		<cfif rsSection.recordcount >
			<cfset adjust=rsSection.recordcount>
			<cfsavecontent variable="theNav">
			<cfoutput>
			<ul><cfloop query="rsSection"><cfsilent>
			
			<cfset nest=''>
			<cfset subnav=not listFind('Calendar,Portal,Gallery',rsSection.type) >
			
			<cfif subnav>
				<cfset nest=dspNestedItems(rssection.contentid,arguments.viewDepth,evaluate('#arguments.currDepth#+1'),'#rsSection.sortBy#','#rsSection.sortDirection#','#arguments.context#','#arguments.stub#') />
			</cfif>
			
			<cfset link=variables.renderer.addlink('#rsSection.type#','#rsSection.filename#','#rsSection.menutitle#','#rsSection.target#','#rsSection.targetParams#','#rsSection.contentid#','#request.siteid#','','#arguments.context#','#arguments.stub#')>
			</cfsilent>
			<li><div>#link#</div><cfif subnav and find("<li",nest)>#nest#</cfif></li></cfloop>
			</ul></cfoutput>
			</cfsavecontent>
		</cfif>
		<cfreturn theNav />
</cffunction>


</cfcomponent>