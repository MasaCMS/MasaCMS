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