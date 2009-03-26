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

<cfsetting enablecfoutputonly="yes">
<cfset request.siteid = "#url.siteid#">
<cf_CacheOMatic key="#url.rssURL##url.maxRssItems#" expiration="#createTimeSpan(0,0,20,0)#">
<cftry>
<CFHTTP url="#url.rssURL#" method="GET" resolveurl="Yes" throwOnError="Yes" />
<cfset xmlFeed=xmlParse(CFHTTP.FileContent)/>
<cfif StructKeyExists(xmlFeed, "rss")>
	<cfset channelTitle =  xmlFeed.rss.channel.title.xmlText>
	<cfset itemArray = xmlFeed.rss.channel.item>
	<cfset maxItems = arrayLen(itemArray) />
	<cfif maxItems gt url.maxRssItems>
		<cfset maxItems = url.maxRssItems/>
	</cfif>
	<cfoutput>#outputRssFeedHeader(channelTitle, maxItems)#<cfloop from="1" to="#maxItems#" index="i">#outputRssFeed(itemArray[i].title.xmlText, itemArray[i].description.xmlText, itemArray[i].link.xmlText)#</cfloop></cfoutput>
<cfelseif StructKeyExists(xmlFeed, "rdf:RDF")>
	<cfset channelArray = XMLSearch(xmlFeed, "//:channel")> 
	<cfset channelTitle =  channelArray[1].title.xmlText>
	<cfset itemArray = XMLSearch(xmlFeed, "//:item")> 
	<cfset maxItems = arrayLen(itemArray) />
	<cfif maxItems gt url.maxRssItems>
		<cfset maxItems = url.maxRssItems/>
	</cfif>
	<cfoutput>#outputRssFeedHeader(channelTitle, maxItems)#<cfloop from="1" to="#maxItems#" index="i">#outputRssFeed(itemArray[i].title.xmlText, itemArray[i].description.xmlText, itemArray[i].link.xmlText)#</cfloop></cfoutput>
<cfelseif StructKeyExists(xmlFeed, "feed")>
	<cfset channelTitle =  xmlFeed.feed.title.xmlText>
	<cfset itemArray = xmlFeed.feed.entry>
	<cfset maxItems = arrayLen(itemArray) />
	<cfif maxItems gt url.maxRssItems>
		<cfset maxItems = url.maxRssItems/>
	</cfif>
	<!---itemArray[i].content.xmlText--->
	<cfoutput>#outputRssFeedHeader(channelTitle, maxItems)#<cfloop from="1" to="#maxItems#" index="i">#outputRssFeed(itemArray[i].title.xmlText, '', itemArray[i].link.XmlAttributes.href)#</cfloop></cfoutput>
</cfif>
<cfcatch><cfoutput>0#chr(10)#</cfoutput></cfcatch>
</cftry>
</cf_cacheomatic>


<cffunction name="outputRssFeedHeader" output="false" returntype="string">
	<cfargument name="channelTitle" required="yes" default="">
	<cfargument name="maxItems" required="yes" default="">
	<cfset var returnContent = "">
	
	<cfsavecontent variable="returnContent"><cfoutput>#arguments.channelTitle##chr(10)##arguments.maxItems##chr(10)#</cfoutput></cfsavecontent>
	
	<cfreturn returnContent>
</cffunction>

<cffunction name="outputRssFeed" output="false" returntype="string">
	<cfargument name="itemTitle" required="yes" default="">
	<cfargument name="itemDescription" required="yes" default="">
	<cfargument name="itemLink" required="yes" default="">
	<cfset var returnContent = "">
	
	<cfsavecontent variable="returnContent"><cfoutput>#chr(10)##chr(10)##arguments.itemTitle##########arguments.itemDescription######arguments.itemLink#####</cfoutput></cfsavecontent>
	
	<cfreturn returnContent>
</cffunction>