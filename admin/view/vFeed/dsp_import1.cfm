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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'collections.remotefeedimportselection')#</h2>

<form novalidate="novalidate" action="index.cfm?fuseaction=cFeed.import2&feedid=#URLEncodedFormat(attributes.feedid)#&siteid=#URLEncodedFormat(attributes.siteid)#" method="post" name="contentForm" onsubmit="return false;">
	<cfset feedBean=application.feedManager.read(attributes.feedID) />
	<h3>#feedBean.getName()#</h3>
		</cfoutput>
		
	<CFHTTP url="#feedBean.getChannelLink()#" method="GET" resolveurl="Yes" throwOnError="Yes" />
	<cfset xmlFeed=xmlParse( REReplace( CFHTTP.FileContent, "^[^<]*", "", "all" ) )/>
	<cfswitch expression="#feedBean.getVersion()#">
		<cfcase value="RSS 0.920,RSS 2.0">
			
			<cfset items = xmlFeed.rss.channel.item> 
			<cfset maxItems=arrayLen(items) />
			
			<cfif maxItems gt feedBean.getMaxItems()>
				<cfset maxItems=feedBean.getMaxItems()/>
			</cfif>
		
<cfloop from="1" to="#maxItems#" index="i">
			<cfsilent>
		<cftry>
		 <cfset remoteID=left(items[i].guid.xmlText,255) />
		 <cfcatch>
		  <cfset remoteID=left(items[i].link.xmlText,255) />
		 </cfcatch>
		 </cftry>
		 
			<cfset request.newBean=application.contentManager.getActiveByRemoteID(remoteID,attributes.siteid) />
		
		</cfsilent>
		<cfif not (not request.newBean.getIsNew() and (items[i].pubDate.xmlText eq request.newBean.getRemotePubDate())) >
		<cfset request.rsCategoryAssign = application.contentManager.getCategoriesByHistID(request.newBean.getcontenthistID()) />
		
			<cfoutput>
				<dl class="oneColumn">
				<dt><a href="#items[i].link.xmlText#" target="_blank">#items[i].title.xmlText#<cfif not request.newBean.getIsNew()> [#application.rbFactory.getKeyValue(session.rb,'collections.update')#]</cfif></a>&nbsp;&nbsp;#application.rbFactory.getKeyValue(session.rb,'collections.import')# <input name="remoteID" value="#remoteID#" type="checkbox" checked /></dt>
				<dd>#items[i].description.xmlText#</dd>
			<!---	<cfinclude template="dsp_categories_import_nest.cfm">--->
				</dl>
			</cfoutput>		
		</cfif>
		</cfloop>
		
		</cfcase>
		<cfcase value="atom">
			<cfoutput><p>#application.rbFactory.getKeyValue(session.rb,'collections.formatnosupported')#</p></cfoutput>
		</cfcase>
	</cfswitch>
	<cfoutput><input type="button" class="submit" onclick="confirmImport();" value="#application.rbFactory.getKeyValue(session.rb,'collections.import')#" /></cfoutput>
	<input type="hidden" name="action" value="import" />
</form>
	
	
