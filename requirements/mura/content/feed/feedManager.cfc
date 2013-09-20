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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="feedGateway" type="any" required="yes"/>
<cfargument name="feedDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="feedUtility" type="any" required="yes"/>
<cfargument name="pluginManager" type="any" required="yes"/>
<cfargument name="trashManager" type="any" required="yes"/>

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.feedgateway=arguments.feedGateway />
	<cfset variables.feedDAO=arguments.feedDAO />
	<cfset variables.globalUtility=arguments.utility />
	<cfset variables.feedUtility=arguments.feedUtility />
	<cfset variables.pluginManager=arguments.pluginManager />
	<cfset variables.trashManager=arguments.trashManager />

	<cfreturn this />
</cffunction>

<cffunction name="getBean" output="false">
	<cfargument name="beanName" default="feed">
	<cfreturn super.getBean(arguments.beanName)>
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
	<cfargument name="applyPermFilter" required="true" default="false">
	<cfargument name="countOnly" default="false">

	<cfreturn variables.feedgateway.getFeed(arguments.feedBean,arguments.tag,arguments.aggregation,arguments.applyPermFilter,arguments.countOnly) />
</cffunction>

<cffunction name="getFeedIterator" returntype="any" access="public" output="false">
	<cfargument name="feedBean"  type="any" />
	<cfargument name="tag"  required="true" default="" />
	<cfargument name="aggregation"  required="true" default="false" />
	<cfargument name="applyPermFilter" required="true" default="false">

	<cfset var rs =  variables.feedgateway.getFeed(arguments.feedBean,arguments.tag,arguments.aggregation,arguments.applyPermFilter) />
	<cfset var it = getBean("contentIterator")>
	<cfset it.setQuery(rs)>
	<cfreturn it/>	
</cffunction>

<cffunction name="getcontentItems" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contentID"  type="string" />

	<cfreturn variables.feedgateway.getcontentItems(arguments.siteID,arguments.contentID) />
</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var feedBean=getBean("feed") />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
	<cfset feedBean.set(arguments.data) />
	<cfset feedBean.validate()>
	
	<cfset pluginEvent.setValue("feedBean",feedBean)>
	<cfset pluginEvent.setValue("siteID",feedBean.getSiteID())>
	<cfset variables.pluginManager.announceEvent("onBeforeFeedSave",pluginEvent)>
	<cfset variables.pluginManager.announceEvent("onBeforeFeedCreate",pluginEvent)>	
	
	<cfif structIsEmpty(feedBean.getErrors())>
		<cfset feedBean.setLastUpdateBy(left(session.mura.fname & " " & session.mura.lname,50) ) />
		<cfif not (structKeyExists(arguments.data,"feedID") and len(arguments.data.feedID))>
			<cfset feedBean.setFeedID("#createUUID()#") />
		</cfif>
		<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was created","mura-content","Information",true) />
		<cfset variables.feedDAO.create(feedBean) />
		<cfset feedBean.setIsNew(0)>
		<cfset variables.trashManager.takeOut(feedBean)>
		<cfset variables.pluginManager.announceEvent("onFeedSave",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onFeedCreate",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterFeedSave",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterFeedCreate",pluginEvent)>
	</cfif>
	
	<cfreturn feedBean />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="feedID" required="true" default=""/>		
	<cfargument name="name" required="true" default=""/>
	<cfargument name="remoteID" required="true" default=""/>
	<cfargument name="siteID" required="true" default=""/>
	<cfargument name="feedBean" required="true" default=""/>
	
	<cfif not len(arguments.feedID) and len(arguments.siteid)>
		<cfif len(arguments.name)>
			<cfreturn variables.feedDAO.readByName(arguments.name,arguments.siteid,arguments.feedBean) />
		<cfelseif len(arguments.remoteID)>
			<cfreturn variables.feedDAO.readByRemoteID(arguments.remoteID,arguments.siteid,arguments.feedBean) />
		</cfif>
	</cfif>
	
	<cfreturn variables.feedDAO.read(arguments.feedID,arguments.feedBean) />
	
</cffunction>

<cffunction name="readByName" access="public" returntype="any" output="false">
	<cfargument name="name" type="String" />
	<cfargument name="siteid" type="String" />
	<cfargument name="feedBean" required="true" default=""/>		
	
	<cfreturn variables.feedDAO.readByName(arguments.name,arguments.siteid,arguments.feedBean) />

</cffunction>

<cffunction name="readByRemoteID" access="public" returntype="any" output="false">
	<cfargument name="remoteID" type="String" />
	<cfargument name="siteid" type="String" />
	<cfargument name="feedBean" required="true" default=""/>		
	
	<cfreturn variables.feedDAO.readByRemoteID(arguments.remoteID,arguments.siteid,arguments.feedBean) />

</cffunction>

<cffunction name="doImport" access="public" returntype="struct" output="false">
	<cfargument name="data" type="struct" />		
	<cfreturn variables.feedUtility.doImport(arguments.data) />

</cffunction>

<cffunction name="doAutoImport" access="public" output="false">		
	<cfargument name="siteid">
	<cfset var rs=getFeeds(arguments.siteid,'Remote',0,1)>
	<cfset var importArgs=structNew()>

	<cfset importArgs.remoteID='All'>

	<cfloop query="rs">
		<cfif rs.autoimport eq 1>
			<cfset importArgs.feedID=rs.feedID>
			<cfset variables.feedUtility.doImport(importArgs) >
		</cfif>
	</cfloop>
	
</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var feedBean=variables.feedDAO.read(arguments.data.feedID) />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
	<cfset feedBean.set(arguments.data) />
	<cfset feedBean.validate()>
	
	<cfset pluginEvent.setValue("feedBean",feedBean)>
	<cfset pluginEvent.setValue("siteID",feedBean.getSiteID())>
	<cfset variables.pluginManager.announceEvent("onBeforeFeedSave",pluginEvent)>
	<cfset variables.pluginManager.announceEvent("onBeforeFeedUpdate",pluginEvent)>	
	
	<cfif structIsEmpty(feedBean.getErrors())>
		<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was updated","mura-content","Information",true) />
		<cfset feedBean.setLastUpdateBy(left(session.mura.fname & " " & session.mura.lname,50) ) />
		<cfset variables.feedDAO.update(feedBean) />
		<cfset variables.pluginManager.announceEvent("onFeedSave",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onFeedUpdate",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterFeedSave",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterFeedUpdate",pluginEvent)>			
	</cfif>
	
	<cfreturn feedBean />
</cffunction>

<cffunction name="save" access="public" returntype="any" output="false">
	<cfargument name="data" type="any" default="#structnew()#"/>	
	
	<cfset var feedID="">
	<cfset var rs="">
	
	<cfif isObject(arguments.data)>
		<cfif listLast(getMetaData(arguments.data).name,".") eq "feedBean">
			<cfset arguments.data=arguments.data.getAllValues()>
		<cfelse>
			<cfthrow type="custom" message="The attribute 'DATA' is not of type 'mura.content.feed.feedBean'">
		</cfif>
	</cfif>
	<cfif structKeyExists(arguments.data,"feedID")>
		<cfset feedID=arguments.data.feedID>
	<cfelse>
		<cfthrow type="custom" message="The attribute 'FEEDID' is required when saving a feed.">
	</cfif>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rs">
	select feedID from tcontentfeeds where feedID=<cfqueryparam value="#feedID#">
	</cfquery>
	
	<cfif rs.recordcount>
		<cfreturn update(arguments.data)>	
	<cfelse>
		<cfreturn create(arguments.data)>
	</cfif>

</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="feedID" type="String" />		
	
	<cfset var feedBean=read(arguments.feedID) />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments) />

	<cfif not feedBean.getIsLocked()>
		<cfset pluginEvent.setValue("feedBean",feedBean)>
		<cfset pluginEvent.setValue("siteID",feedBean.getSiteID())>
		
		<cfset variables.pluginManager.announceEvent("onBeforeFeedDelete",pluginEvent)>
		<cfset variables.trashManager.throwIn(feedBean)>
		<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was deleted","mura-content","Information",true) />
		<cfset variables.feedDAO.delete(arguments.feedID) />
		
		<cfset variables.pluginManager.announceEvent("onFeedDelete",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterFeedDelete",pluginEvent)>
	</cfif>	

</cffunction>

<cffunction name="allowFeed" output="false" returntype="boolean">
			<cfargument name="feedBean" type="any"  />
			<cfargument name="username"  type="string" default="" />
			<cfargument name="password"  type="string" default="" />
			<cfargument name="userID"  type="string" default="" />

			<cfset var rs="" />
			<cfset var rLen=listLen(arguments.feedBean.getRestrictGroups()) />
			<cfset var G = 0 />
			
			<cfif listFind(session.mura.memberships,'S2IsPrivate;#arguments.feedBean.getSiteID()#')>
				<cfreturn true />
			<cfelseif arguments.feedBean.getIsNew()>
				<cfreturn false>
			<cfelseif  arguments.feedBean.getRestricted()>
						<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
						select tusers.userid from tusers 
						<cfif rLen> inner join tusersmemb 
						on(tusers.userid=tusersmemb.userid)</cfif>
						where tusers.type=2 
						<cfif len(arguments.userID)>
							tusers.userID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.userID#">
						<cfelse>
						and tusers.username=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.username#"> 
						and (tusers.password=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.password#">
							or 
						     tusers.password=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(hash(arguments.password))#">)
						</cfif>
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
			<cfelse>
				<cfreturn true>
			</cfif>
		
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
	<cfargument name="timeout" required="true" default="5" >
	<cfset var data = "" />
	<cfset var temp = 0 />
	<cfset var response=structNew() />
	
	<cftry>
	<cfif len(variables.configBean.getProxyServer())>
		<cfhttp result="temp" url="#arguments.feedURL#" method="GET" resolveurl="Yes" 
		throwOnError="Yes" charset="UTF-8" timeout="#arguments.timeout#" 
		proxyUser="#variables.configBean.getProxyUser()#" proxyPassword="#variables.configBean.getProxyPassword()#"
		proxyServer="#variables.configBean.getProxyServer()#" proxyPort="#variables.configBean.getProxyPort()#"/>
	<cfelse>
		<cfhttp result="temp" url="#arguments.feedURL#" method="GET" resolveurl="Yes" 
		throwOnError="Yes" charset="UTF-8" timeout="#arguments.timeout#"/>
	</cfif>
	<cfcatch><cfreturn response /></cfcatch>
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
