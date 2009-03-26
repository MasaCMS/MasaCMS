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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'collections.remotefeedimportselection')#</h2>

<form action="index.cfm?fuseaction=cFeed.import2&feedID=#attributes.feedID#&siteid=#attributes.siteID#" method="post" name="contentForm" onsubmit="return false;">
	<cfset feedBean=application.feedManager.read(attributes.feedID) />
	<h3>#feedBean.getName()#</h3>
		</cfoutput>
		
	<CFHTTP url="#feedBean.getChannelLink()#" method="GET" resolveurl="Yes" throwOnError="Yes" />
	<cfset xmlFeed=xmlParse(CFHTTP.FileContent)/>
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
			<p>#application.rbFactory.getKeyValue(session.rb,'collections.formatnosupported')#</p>
		</cfcase>
	</cfswitch>
	<cfoutput><a class="submit" href="javascript:;" onclick="if(confirm('Import Selections?')){return submitForm(document.forms.contentForm,'Import');}else{return false;};"><span>#application.rbFactory.getKeyValue(session.rb,'collections.import')#</span></a></cfoutput>
	<input type="hidden" name="action" value="import" />
</form>
	
	
