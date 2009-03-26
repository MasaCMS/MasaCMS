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
<cfargument name="feedGateway" type="any" required="yes"/>
<cfargument name="feedDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="feedUtility" type="any" required="yes"/>
<cfargument name="pluginManager" type="any" required="yes"/>

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.feedgateway=arguments.feedGateway />
	<cfset variables.feedDAO=arguments.feedDAO />
	<cfset variables.globalUtility=arguments.utility />
	<cfset variables.feedUtility=arguments.feedUtility />
	<cfset variables.pluginManager=arguments.pluginManager />
	
	<cfreturn this />
</cffunction>

<cffunction name="getFeeds" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="type"  type="string" />
	<cfargument name="publicOnly" type="boolean" required="true" default="false">
	<cfargument name="activeOnly" type="boolean" required="true" default="false">

	<cfreturn variables.feedgateway.getFeeds(arguments.siteID,arguments.type,arguments.publicOnly,arguments.activeOnly) />
</cffunction>

<cffunction name="getFeed" returntype="query" access="public" output="false">
	<cfargument name="feedBean"  type="any" />
	<cfargument name="tag"  required="true" default="" />
	<cfargument name="aggregation"  required="true" default="false" />

	<cfreturn variables.feedgateway.getFeed(arguments.feedBean,arguments.tag,arguments.aggregation) />
</cffunction>

<cffunction name="getcontentItems" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contentID"  type="string" />

	<cfreturn variables.feedgateway.getcontentItems(arguments.siteID,arguments.contentID) />
</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var feedBean=application.serviceFactory.getBean("feedBean") />
	<cfset var pluginEvent = createObject("component","mura.event") />
	<cfset feedBean.set(arguments.data) />
	
	<cfif structIsEmpty(feedBean.getErrors())>
		<cfset feedBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset feedBean.setFeedID("#createUUID()#") />
		<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was created","sava-content","Information",true) />
		<cfset variables.feedDAO.create(feedBean) />
		<cfset pluginEvent.setValue("feedBean",feedBean)>
		<cfset variables.pluginManager.executeScripts("onFeedSave",feedBean.getSiteID(),pluginEvent)>
	</cfif>
	
	<cfreturn feedBean />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="categoryID" type="String" />		
	
	<cfreturn variables.feedDAO.read(arguments.categoryID) />

</cffunction>

<cffunction name="import" access="public" returntype="struct" output="false">
	<cfargument name="data" type="struct" />		
	
	<cfreturn variables.feedUtility.import(arguments.data) />

</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var feedBean=variables.feedDAO.read(arguments.data.feedID) />
	<cfset var pluginEvent = createObject("component","mura.event") />
	<cfset feedBean.set(arguments.data) />
	
	<cfif structIsEmpty(feedBean.getErrors())>
		<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was updated","sava-content","Information",true) />
		<cfset feedBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset variables.feedDAO.update(feedBean) />
		<cfset pluginEvent.setValue("feedBean",feedBean)>
		<cfset variables.pluginManager.executeScripts("onFeedSave",feedBean.getSiteID(),pluginEvent)>	
	</cfif>
	
	<cfreturn feedBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="feedID" type="String" />		
	
	<cfset var feedBean=read(arguments.feedID) />
	<cfset var pluginEvent = createObject("component","mura.event") />
	<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was deleted","sava-content","Information",true) />
	<cfset variables.feedDAO.delete(arguments.feedID) />
	
	<cfset pluginEvent.setValue("feedBean",feedBean)>
	<cfset variables.pluginManager.executeScripts("onFeedDelete",feedBean.getSiteID(),pluginEvent)>	

</cffunction>

<cffunction name="allowFeed" output="false" returntype="boolean">
			<cfargument name="feedBean" type="any"  />
			<cfargument name="username"  type="string" default="" />
			<cfargument name="password"  type="string" default="" />

			<cfset var rs="" />
			<cfset var allowFeed=true />
			<cfset var rLen=listLen(arguments.feedBean.getRestrictGroups()) />
			<cfset var G = 0 />
			
			<cfif isUserInRole('S2IsPrivate;#arguments.feedBean.getSiteID()#')>
				<cfreturn true />
			</cfif>
			
			<cfif  arguments.feedBean.getRestricted()>
						<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
						select tusers.userid from tusers 
						<cfif rLen> inner join tusersmemb 
						on(tusers.userid=tusersmemb.userid)</cfif>
						where tusers.type=2 
						and tusers.username=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.username#"> 
						and (tusers.password=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.password#">
							or 
						     tusers.password=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(hash(arguments.password))#">)
						and tusers.siteid='#application.settingsManager.getSite(arguments.feedBean.getSiteID()).getPublicUserPoolID()#'
						
						<cfif rLen>
						and tusersmemb.groupid in ( 
						<cfloop from="1" to="#rlen#" index="g">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.feedBean.getRestrictGroups(),g)#">
						<cfif g lt rlen>,</cfif>
						</cfloop>)
						</cfif>
						</cfquery>
						
						<cfif not rs.recordcount>
							<cfreturn false />
						</cfif>
			</cfif>
			
		<cfreturn allowFeed>
</cffunction>

<cffunction name="getDefaultFeeds" returntype="query" access="public" output="false">
	<cfargument name="siteID" type="string" />

	<cfreturn variables.feedgateway.getDefaultFeeds(arguments.siteID) />
</cffunction>

<cffunction name="getFeedsByCategoryID" returntype="query" access="public" output="false">
	<cfargument name="categoryID" type="string" />
	<cfargument name="siteID" type="string" />

	<cfreturn variables.feedgateway.getFeedsByCategoryID(arguments.categoryID, arguments.siteID) />
</cffunction>

<cffunction name="getRemoteFeedData" returntype="any" output="false">
	<cfargument name="feedURL" required="true" >
	<cfargument name="maxItems" required="true" >
	<cfset var data = "" />
	<cfset var temp = 0 />
	<cfset var response=structNew() />
	
	<cftry>
	<cfhttp result="temp" url="#arguments.feedURL#" method="GET" resolveurl="Yes" throwOnError="Yes" charset="UTF-8"/>
	<cfcatch></cfcatch>
	</cftry>
	
	<cfset data=replace(temp.FileContent,chr(20),'','ALL') />

	<cfif isXML(data)>
		<cfset response.xml=XMLParse(data)/>
		<cfif StructKeyExists(response.xml, "rss")>
	       	<cfset response.channelTitle =  response.xml.rss.channel.title.xmlText>
	       	<cfset response.itemArray = response.xml.rss.channel.item>
        	<cfset response.maxItems = arrayLen(response.itemArray) />
			<cfset response.type = "rss" />
    	<cfelseif StructKeyExists(response.xml, "rdf:RDF")>
	       	 <cfset response.channelArray = XMLSearch(response.xml, "//:channel")>
	      	<cfset response.channelTitle =  response.channelArray[1].title.xmlText>
	      	<cfset response.itemArray = XMLSearch(response.channelArray[1], "//:item")>
	     	<cfset response.maxItems = arrayLen(response.itemArray) />
	    	<cfset response.type = "rdf" />
     	<cfelseif StructKeyExists(response.xml, "feed")>
			<cfset response.channelTitle =  response.xml.feed.title.xmlText>
			<cfset response.itemArray =response.xml.feed.entry>
			<cfset response.maxItems = arrayLen(response.itemArray) />
			<cfset response.type = "atom" />
		</cfif>
	
		<cfif response.maxItems gt arguments.MaxItems>
			<cfset response.maxItems=arguments.MaxItems/>
		</cfif>

	</cfif>

	<cfreturn response />
</cffunction>

</cfcomponent>
