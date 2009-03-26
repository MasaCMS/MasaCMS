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
<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="feedDAO" type="any" required="yes"/>
<cfargument name="contentManager" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.feedDAO=arguments.feedDAO />
		<cfset variables.contentManager=arguments.contentManager />
		<cfset variables.globalUtility=arguments.utility />
	<cfreturn this />
</cffunction>

<cffunction name="import" access="public" returntype="struct" output="false">
	<cfargument name="data" type="struct" />		
	
	<cfset var feedItem = structNew() />
	<cfset var import = structNew() />
	<cfset var xmlFeed = "" />
	<cfset var items = "" />
	<cfset var maxItems = 0 />
	<cfset var content = "" />
	<cfset var i = "" />
	<cfset var c = "" />

	<cfset import.feedBean=variables.feedDAO.read(arguments.data.feedID) />
	
	<cfif not len(import.feedBean.getParentID())>
		<cfset import.success=false />
		<cfreturn import>
	</cfif>
	
	<cfset import.ParentBean=variables.contentManager.getActiveContent(import.feedBean.getParentID(),import.feedBean.getSiteID()) />
	<cfif import.ParentBean.getIsNew() or import.feedBean.getParentID() eq ''>
	<cfset import.success=false />
	<cfreturn import>
	<cfelse>
	
	<CFHTTP url="#import.feedBean.getChannelLink()#" method="GET" resolveurl="Yes" throwOnError="Yes" />
	<cfset xmlFeed=xmlParse(CFHTTP.FileContent)/>
	<cfswitch expression="#import.feedBean.getVersion()#">
		<cfcase value="RSS 0.920,RSS 2.0">
			
			<cfset items = xmlFeed.rss.channel.item> 
			<cfset maxItems=arrayLen(items) />
			
			<cfif maxItems gt import.feedBean.getMaxItems()>
				<cfset maxItems=import.feedBean.getMaxItems()/>
			</cfif>
			
			<cfloop from="#maxItems#" to="1" index="i" step="-1">
			
			<cfif isdefined('arguments.data.remoteID') and listFind(arguments.data.remoteID,items[i].guid.xmlText) >
				<cfset feedItem = structNew() />
				<cfset feedItem.remoteURL=left(items[i].link.xmlText,255) />
				<cfset feedItem.title=left(items[i].title.xmlText,255) />
				<cfset feedItem.summary=items[i].description.xmlText />
				<cfset feedItem.remotePubDate=items[i].pubDate.xmlText />
				
				<cftry>
					<cfset feedItem.remoteID=left(items[i].guid.xmlText,255) />
					<cfcatch>
						<cfset feedItem.remoteID=left(items[i].link.xmlText,255)> 
					</cfcatch>
				</cftry>
				
				<cftry>
					<cfset content = xmlFeed.rss.channel.item[i]["content:encoded"]>
					<cfif ArrayLen(content)>
						<cfset feedItem.body = content[1].xmlText>   
					<cfelse>     
						<cfset feedItem.body=items[i].description.xmlText>   
					</cfif>
					<cfcatch>
						<cfset feedItem.body=items[i].description.xmlText> 
					</cfcatch>
				</cftry>
				<cfset feedItem.parentID=import.feedBean.getParentID() />
				<cfset feedItem.siteID=import.feedBean.getSiteID() />
				<cfset feedItem.approved=1 />
				<cfset feedItem.type='Page' />
				<cfset feedItem.display=1 />
				<cfset feedItem.isNav=1 />
				<cfset feedItem.moduleID='00000000000000000000000000000000000' />
				<cfset feedItem.mode='import' />
				<!---<cfset feedItem.releaseDate=dateformat(now(),"m/d/yy") />--->
				
				
				<cfif import.feedBean.getCategoryID() neq ''>
					<cfloop from="1" to="#listLen(import.feedBean.getCategoryID())#" index="c">
					<cfset feedItem["categoryAssign#replace(listGetAt(import.feedBean.getCategoryID(),c),'-','','ALL')#"]=0 />
					</cfloop>
				</cfif>
			
				<cfset variables.contentManager.add(feedItem) />
			</cfif>
			</cfloop>
		<cfset import.success=true/>
		</cfcase>
		<cfcase value="atom">
			<!---<cfoutput>

			<cfloop from="1" to="#arrayLen(xmlFeed.feed.entry)#" index="i">
			<dt><a href="#xmlFeed.feed.entry[i].link.xmlAttributes.href#">#xmlFeed.feed.entry[i].title.xmlText#</a></dt>
			<cfif hasSummary><dd>#xmlFeed.feed.entry[i].summary.xmlText#</dd></cfif>
			</cfloop>
			</dl></cfoutput>--->
		</cfcase>
	</cfswitch>
	
	
	</cfif>
	
	<cfreturn import />
</cffunction>

</cfcomponent>