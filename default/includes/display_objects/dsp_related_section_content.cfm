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
	<cfquery datasource="#application.configBean.getDatasource(mode='readOnly')#" username="#application.configBean.getDBUsername(mode='readOnly')#" password="#application.configBean.getDBPassword(mode='readOnly')#" name="rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#variables.$.event('siteID')#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1</cfquery>
	<cfif variables.rsSection.recordcount>
	<cfset variables.menutype=iif(variables.rsSection.type eq 'Portal',de('default'),de('calendar_features'))/>
	<cfset rsPreFeatures=variables.$.getBean('contentGateway').getkids('00000000000000000000000000000000000','#variables.$.event('siteID')#','#arguments.objectid#',variables.menutype,now(),0,"",0,iif(variables.rsSection.type eq 'Portal',de('#variables.rsSection.sortBy#'),de('displaystart')),iif(variables.rsSection.type eq 'Portal',de('#variables.rsSection.sortDirection#'),de('desc')),'','#variables.$.content('contentID')#')>
		<cfif variables.$.siteConfig('extranet') eq 1 and variables.$.event('r').restrict eq 1>
			<cfset variables.rsFeatures=variables.$.queryPermFIlter(variables.rsPreFeatures)/>
		<cfelse>
			<cfset variables.rsFeatures=rsPreFeatures/>
		</cfif>
	</cfif>
</cfsilent>
<cfoutput>
<cfif variables.rsSection.recordcount and variables.rsFeatures.recordcount>
<cfsilent>
	<cfset variables.iterator=variables.$.getBean("contentIterator")>
	<cfset variables.iterator.setQuery(rsFeatures)>
	<cfset variables.cssID=variables.$.createCSSid(variables.rsSection.menuTitle)>
</cfsilent>
<div id="#variables.cssID#" class="svRelSecContent svIndex mura-rel-sec-content mura-index">
	<#variables.$.getHeaderTag('subHead1')#>#rsSection.menutitle#</#variables.$.getHeaderTag('subHead1')#>
	<cfif not structIsEmpty(objectparams)>
		#variables.$.dspObject_Include(
				thefile='dsp_content_list.cfm',
				fields=params.displayList,
				type='objectparams', 
				iterator=variables.iterator,
				imageSize=objectparams.imageSize,
				imageHeight=objectparams.imageHeight,
				imageWidth=objectparams.imageWidth
				)#
	<cfelse>
		<cfsilent>
		<cfset variables.contentListFields="Title">
		
		<cfif variables.$.getBean('contentGateway').getHasComments(variables.$.event('siteID'),arguments.objectid) >
			<cfset variables.contentListFields=listAppend(variables.contentListFields,"Comments")>
		</cfif>
		</cfsilent>
		#variables.$.dspObject_Include(
			thefile='dsp_content_list.cfm',
			fields=variables.contentListFields,
			type='Related', 
			iterator= variables.iterator
			)#
	</cfif>
	
	<dl class="moreResults">
		<dt><a href="#variables.siteConfig('context')##getURLStem(variables.$.event('siteID'),variables.rsSection.filename)#">View All</a></dt>
	</dl>
</div>
<cfelse>
	<!-- Empty Related Section Content '#rsSection.menutitle#' -->
</cfif>
</cfoutput>