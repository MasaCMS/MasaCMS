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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provide content feed utility functionality">
<cffunction name="init" output="false">
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

<cffunction name="doImport" returntype="struct" output="false">
	<cfargument name="data" type="struct" />

	<cfset var feedItem = structNew() />
	<cfset var theImport = structNew() />
	<cfset var xmlFeed = "" />
	<cfset var items = "" />
	<cfset var maxItems = 0 />
	<cfset var content = "" />
	<cfset var contentBean = "" />
	<cfset var i = "" />
	<cfset var c = "" />
	<cfset var feedItemId = "" />

	<cfset theImport.feedBean=variables.feedDAO.read(arguments.data.feedID) />

	<cfif not len(theImport.feedBean.getParentID())>
		<cfset theImport.success=false />
		<cfreturn theImport>
	</cfif>

	<cfset theImport.ParentBean=variables.contentManager.getActiveContent(theImport.feedBean.getParentID(),theImport.feedBean.getSiteID()) />
	<cfif theImport.ParentBean.getIsNew() or theImport.feedBean.getParentID() eq ''>
	<cfset theImport.success=false />
	<cfreturn theImport>
	<cfelse>

	<cfhttp attributeCollection='#getHTTPAttrs(
			url=theImport.feedBean.getChannelLink(),
			authtype=theImport.feedBean.getAuthType(),
			method="GET",
			resolveurl="Yes",
			throwOnError="Yes")#'>

	<cfset xmlFeed=xmlParse(CFHTTP.FileContent)/>
	<cfswitch expression="#theImport.feedBean.getVersion()#">
		<cfcase value="RSS 0.920,RSS 2.0">

			<cfset items = xmlFeed.rss.channel.item>
			<cfset maxItems=arrayLen(items) />

			<cfif maxItems gt theImport.feedBean.getMaxItems()>
				<cfset maxItems=theImport.feedBean.getMaxItems()/>
			</cfif>

			<cfloop from="#maxItems#" to="1" index="i" step="-1">

			<cftry>
			  <cfset feedItemId=hash(left(items[i].guid.xmlText,255)) />
			    <cfcatch>
			      <cfset feedItemId=hash(left(items[i].link.xmlText,255)) />
			    </cfcatch>
			</cftry>

			<cfif isdefined('arguments.data.remoteID') and (arguments.data.remoteID eq 'All' or listFind(arguments.data.remoteID,feedItemId)) >

				<cfset contentBean=getBean('content').loadBy(remoteID=feedItemId,siteID=theImport.feedBean.getSiteID())>

					<cfset feedItem = structNew() />
					<cfset feedItem.remoteURL=left(items[i].link.xmlText,255) />
					<cfset feedItem.title=left(items[i].title.xmlText,255) />
					<cfset feedItem.summary="" />

					<cfif structKeyExists(items[i],"description")>
						<cfset feedItem.summary=items[i].description.xmlText />
					<cfelseif  structKeyExists(items[i],"summary")>
						<cfset feedItem.summary=items[i].summary.xmlText />
					</cfif>

					<cfset feedItem.remotePubDate=items[i].pubDate.xmlText />

					<cfif isDate(items[i].pubDate.xmlText)>
						<cfset feedItem.releaseDate=parseDateTime(items[i].pubDate.xmlText) />
					</cfif>

					<cfset feedItem.remoteID=feedItemId />

					<cftry>
						<cfset content = xmlFeed.rss.channel.item[i]["content:encoded"]>

						<cfif ArrayLen(content)>
							<cfset feedItem.body = content[1].xmlText>
						<cfelse>
							<cfif structKeyExists(items[i],"description")>
								<cfset feedItem.body=items[i].description.xmlText />
							<cfelseif structKeyExists(items[i],"summary")>
								<cfset feedItem.body=items[i].summary.xmlText />
							</cfif>
						</cfif>

						<cfcatch>
							<cfif structKeyExists(items[i],"description")>
								<cfset feedItem.body=items[i].description.xmlText />
							<cfelseif structKeyExists(items[i],"summary")>
								<cfset feedItem.body=items[i].summary.xmlText />
							</cfif>
						</cfcatch>
					</cftry>

					<cfset feedItem.parentID=theImport.feedBean.getParentID() />
					<cfset feedItem.siteID=theImport.feedBean.getSiteID() />
					<cfset feedItem.approved=1 />
					<cfset feedItem.type='Page' />
					<cfset feedItem.display=1 />
					<cfset feedItem.isNav=1 />
					<cfset feedItem.moduleID='00000000000000000000000000000000000' />
					<cfset feedItem.mode='import' />
					<!---<cfset feedItem.releaseDate=dateformat(now(),"m/d/yy") />--->

					<cfif theImport.feedBean.getCategoryID() neq ''>
						<cfloop from="1" to="#listLen(theImport.feedBean.getCategoryID())#" index="c">
						<cfset feedItem["categoryAssign#replace(listGetAt(theImport.feedBean.getCategoryID(),c),'-','','ALL')#"]=0 />
						</cfloop>
					</cfif>

					<cfset contentBean.set(feedItem).save() />

					<cfif not contentBean.getIsNew() and arguments.data.remoteID eq 'All'>
						<cfset contentBean.deleteVersionHistory() />
					</cfif>
			</cfif>
		</cfloop>

		<cfset theImport.success=true/>
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

	<cfreturn theImport />
</cffunction>

<cffunction name="getRemoteFeedData" output="false">
	<cfargument name="feedURL" required="true" >
	<cfargument name="maxItems" required="true" >
	<cfargument name="timeout" required="true" default="5" >
	<cfargument name="authtype" required="true" default="">
	<cfset var data = "" />
	<cfset var temp = 0 />
	<cfset var response=structNew() />
	<cfset response.maxItems = 0>

	<cftry>
		<cfhttp attributeCollection='#getHTTPAttrs(result="temp",
						url=arguments.feedURL,
						authtype=arguments.authtype,
						method="GET",
						resolveurl="Yes",
						throwOnError="Yes",
						charset="UTF-8",
						cachedwithin=createTimeSpan(0,0,1,0),
						timeout="#arguments.timeout#")#'>

		<cfcatch>
			<cfreturn ''>
		</cfcatch>
	</cftry>

	<cfset data=replace(temp.FileContent,chr(20),'','ALL') />
	<cfset data=REReplace( data, "^[^<]*", "", "all" )/>

	<cfif isXML(data)>
		<cfset response.xml=XMLParse(data)/>
		<cfif StructKeyExists(response.xml, "rss")>
			<cfset response.channelTitle =  response.xml.rss.channel.title.xmlText>
			<cfif isdefined("response.xml.rss.channel.item")>
				<cfset response.itemArray = response.xml.rss.channel.item>
				<cfset response.maxItems = arrayLen(response.itemArray) />
			<cfelse>
				<cfset response.maxItems = 0 />
			</cfif>
			<cfset response.type = "rss" />
		<cfelseif StructKeyExists(response.xml, "rdf:RDF")>
			<cfset response.channelArray = XMLSearch(response.xml, "//:channel")>
			<cfset response.channelTitle =  response.channelArray[1].title.xmlText>
			<cfset response.itemArray = XMLSearch(response.channelArray[1], "//:item")>
			<cfset response.maxItems = arrayLen(response.itemArray) />
			<cfset response.type = "rdf" />
		<cfelseif StructKeyExists(response.xml, "feed")>
			<cfset response.channelTitle =  response.xml.feed.title.xmlText>
			<cfif isdefined("response.xml.feed.entry")>
			<cfset response.itemArray = response.xml.feed.entry>
				<cfset response.maxItems = arrayLen(response.itemArray) />
			<cfelse>
				<cfset response.maxItems = 0 />
			</cfif>
			<cfset response.type = "atom" />
		</cfif>

		<cfif response.maxItems gt arguments.MaxItems>
			<cfset response.maxItems=arguments.MaxItems/>
		</cfif>

	</cfif>

	<cfreturn response />
</cffunction>
</cfcomponent>
