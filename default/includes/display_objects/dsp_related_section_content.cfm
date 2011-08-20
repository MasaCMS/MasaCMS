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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsilent>
	<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#request.siteid#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1</cfquery>
	<cfif variables.rsSection.recordcount>
	<cfset variables.menutype=iif(variables.rsSection.type eq 'Portal',de('default'),de('calendar_features'))/>
	<cfset rsPreFeatures=application.contentGateway.getkids('00000000000000000000000000000000000','#request.siteid#','#arguments.objectid#',variables.menutype,now(),0,"",0,iif(variables.rsSection.type eq 'Portal',de('#variables.rsSection.sortBy#'),de('displaystart')),iif(variables.rsSection.type eq 'Portal',de('#variables.rsSection.sortDirection#'),de('desc')),'','#$.content('contentID')#')>
		<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
			<cfset variables.rsFeatures=queryPermFilter(variables.rsPreFeatures)/>
		<cfelse>
			<cfset variables.rsFeatures=rsPreFeatures/>
		</cfif>
	</cfif>
</cfsilent>
<cfoutput>
<cfif variables.rsSection.recordcount and variables.rsFeatures.recordcount>
<cfsilent>
	<cfset variables.iterator=$.getBean("contentIterator")>
	<cfset variables.iterator.setQuery(rsFeatures)>
	
	<cfset variables.contentListType="Related">
	<cfset variables.contentListFields="Title">
	
	<cfif application.contentGateway.getHasComments(request.siteid,arguments.objectid) >
		<cfset variables.contentListFields=listAppend(variables.contentListFields,"Comments")>
	</cfif>
	
	<!--- Omitting Summaries
	<cfif arguments.hasSummary >
		<cfset variables.contentListFields=listAppend(variables.contentListFields,"Summary")>
	</cfif>
	--->
	
	<cfset variables.cssID=$.createCSSid(variables.rsSection.menuTitle)>
</cfsilent>
<div id="#variables.cssID#" class="svRelSecContent svIndex">
	<#getHeaderTag('subHead1')#>#rsSection.menutitle#</#getHeaderTag('subHead1')#>
	#dspObject_Include(thefile='dsp_content_list.cfm',
			fields=variables.contentListFields,
			type=variables.contentListType, 
			iterator= variables.iterator
			)#
	<dl class="moreResults">
		<dt><a href="#application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(request.siteid,variables.rsSection.filename)#">View All</a></dt>
	</dl>
</div>
<cfelse>
	<!-- Empty Related Section Content '#rsSection.menutitle#' -->
</cfif>
</cfoutput>