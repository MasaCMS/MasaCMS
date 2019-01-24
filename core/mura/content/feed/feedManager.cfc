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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides content feed service level logic functionality">

<cffunction name="init" output="false">
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

<cffunction name="getFeeds" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="type"  type="string" />
	<cfargument name="publicOnly" type="boolean" required="true" default="false">
	<cfargument name="activeOnly" type="boolean" required="true" default="false">

	<cfreturn variables.feedgateway.getFeeds(arguments.siteID,arguments.type,arguments.publicOnly,arguments.activeOnly) />
</cffunction>

<cffunction name="getFeed" output="false">
	<cfargument name="feedBean"  type="any">
	<cfargument name="tag"  required="true" default="">
	<cfargument name="aggregation"  required="true" default="false">
	<cfargument name="applyPermFilter" required="true" default="false">
	<cfargument name="countOnly" default="false">
	<cfargument name="menuType" default="default">
	<cfargument name="from" required="true" default="">
	<cfargument name="to" required="true" default="">
	<cfargument name="applyIntervals" required="true" type="boolean" default="true">

	<cfreturn variables.feedgateway.getFeed(
		feedBean=arguments.feedBean
		, tag=arguments.tag
		, aggregation=arguments.aggregation
		, applyPermFilter=arguments.applyPermFilter
		, countOnly=arguments.countOnly
		, menuType=arguments.menuType
		, from=arguments.from
		, to=arguments.to
		, applyIntervals=arguments.applyIntervals
	) />
</cffunction>

<cffunction name="getFeedIterator" output="false">
	<cfargument name="feedBean"  type="any" />
	<cfargument name="tag"  required="true" default="" />
	<cfargument name="aggregation"  required="true" default="false" />
	<cfargument name="applyPermFilter" required="true" default="false">
	<cfargument name="from" required="true" default="#now()#">
	<cfargument name="to" required="true" default="#now()#">

	<cfset var rs =  variables.feedgateway.getFeed(arguments.feedBean,arguments.tag,arguments.aggregation,arguments.applyPermFilter,arguments.from,arguments.to) />
	<cfset var it = getBean("contentIterator")>
	<cfset it.setQuery(rs)>
	<cfreturn it/>
</cffunction>

<cffunction name="getcontentItems" output="false">
	<cfargument name="feedBean" />

	<cfreturn variables.feedgateway.getcontentItems(arguments.feedBean) />
</cffunction>

<cffunction name="create" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>

	<cfset var feedBean=getBean("feed") />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
	<cfset var sessionData=getSession()>

	<cfset feedBean.set(arguments.data) />
	<cfset feedBean.validate()>

	<cfset pluginEvent.setValue("feedBean",feedBean)>
	<cfset pluginEvent.setValue("bean",feedBean)>
	<cfset pluginEvent.setValue("siteID",feedBean.getSiteID())>
	<cfset variables.pluginManager.announceEvent(eventToAnnounce="onBeforeFeedSave",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
	<cfset variables.pluginManager.announceEvent(eventToAnnounce="onBeforeFeedCreate",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>

	<cfif structIsEmpty(feedBean.getErrors())>
		<cfset feedBean.setLastUpdate(now())>
		<cfset feedBean.setLastUpdateBy(left(sessionData.mura.fname & " " & sessionData.mura.lname,50) ) />
		<cfif not (structKeyExists(arguments.data,"feedID") and len(arguments.data.feedID))>
			<cfset feedBean.setFeedID("#createUUID()#") />
		</cfif>
		<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was created","mura-content","Information",true) />
		<cfset variables.feedDAO.create(feedBean) />
		<cfset feedBean.setIsNew(0)>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onFeedSave",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onFeedCreate",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onAfterFeedSave",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onAfterFeedCreate",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
	</cfif>

	<cfreturn feedBean />
</cffunction>

<cffunction name="read" output="false">
	<cfargument name="feedID" required="true" default=""/>
	<cfargument name="name" required="true" default=""/>
	<cfargument name="remoteID" required="true" default=""/>
	<cfargument name="siteID" required="true" default=""/>
	<cfargument name="feedBean" required="true" default=""/>

	<cfif not len(arguments.feedID) and len(arguments.siteid)>
		<cfif len(arguments.name)>
			<cfreturn readByName(arguments.name,arguments.siteid,arguments.feedBean) />
		<cfelseif len(arguments.remoteID)>
			<cfreturn readByRemoteID(arguments.remoteID,arguments.siteid,arguments.feedBean) />
		</cfif>
	</cfif>

	<cfset var key= "feed" & arguments.siteid & arguments.feedid />
	<cfset var site=getBean('settingsManager').getSite(arguments.siteid)/>
	<cfset var cacheFactory=site.getCacheFactory(name="data")>
	<cfset var bean=arguments.feedBean>

	<cfif site.getCache()>
		<!--- check to see if it is cached. if not then pass in the context --->
		<!--- otherwise grab it from the cache --->
		<cfif NOT cacheFactory.has( key )>
			<cfset bean=variables.feedDAO.read(arguments.feedID,bean) />
			<cfif not isArray(bean) and not bean.getIsNew()>
				<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
			</cfif>
			<cfset commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: feedBean, key: #key#}"))>
			<cfreturn bean/>
		<cfelse>
			<cftry>
				<cfif not isObject(bean)>
					<cfset bean=getBean("feed")/>
				</cfif>
				<cfset commitTracePoint(initTracePoint(detail="DATA CACHE HIT: {class: feedBean, key: #key#}"))>
				<cfset bean.setValue('frommuracache',true)>
				<cfset bean.setAllValues( duplicate(cacheFactory.get( key )) )>
				<cfreturn bean />
				<cfcatch>
					<cfset bean=variables.feedDAO.read(arguments.feedID,bean) />
					<cfif not isArray(bean) and not bean.getIsNew()>
						<cfset cacheFactory.get( key, duplicate(bean.getAllValues()) ) />
					</cfif>
					<cfset commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: feedBean, key: #key#}"))>
					<cfreturn bean/>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfset commitTracePoint(initTracePoint(detail="Loading feedBean"))>
		<cfreturn variables.feedDAO.read(arguments.feedID,bean) />
	</cfif>

</cffunction>

<cffunction name="readByName" output="false">
	<cfargument name="name" type="String" />
	<cfargument name="siteid" type="String" />
	<cfargument name="feedBean" required="true" default=""/>
	<cfset var key= "feed" & arguments.siteid & arguments.name />
	<cfset var site=getBean('settingsManager').getSite(arguments.siteid)/>
	<cfset var cacheFactory=site.getCacheFactory(name="data")>
	<cfset var bean=arguments.feedBean>

	<cfif site.getCache()>
		<!--- check to see if it is cached. if not then pass in the context --->
		<!--- otherwise grab it from the cache --->
		<cfif NOT cacheFactory.has( key )>
			<cfset bean=variables.feedDAO.readByName(arguments.name,arguments.siteid,bean) />
			<cfif not isArray(bean) and not bean.getIsNew()>
				<cfset cacheFactory.get( key, duplicate(bean.getAllValues()) ) />
			</cfif>
			<cfset commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: contentBean, key: #key#}"))>
			<cfreturn bean/>
		<cfelse>
			<cftry>
				<cfif not isObject(bean)>
					<cfset bean=getBean("feed")/>
				</cfif>
				<cfset commitTracePoint(initTracePoint(detail="DATA CACHE HIT: {class: feedBean, key: #key#}"))>
				<cfset bean.setAllValues( duplicate(cacheFactory.get( key )) )>
				<cfset bean.setValue('frommuracache',true)>
				<cfreturn bean />
				<cfcatch>
					<cfset bean=variables.feedDAO.readByName(arguments.name,arguments.siteid,bean) />
					<cfif not isArray(bean) and not bean.getIsNew()>
						<cfset cacheFactory.get( key, duplicate(bean.getAllValues()) ) />
					</cfif>
					<cfset commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: feedBean, key: #key#}"))>
					<cfreturn bean/>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfset commitTracePoint(initTracePoint(detail="Loading feedBean"))>
		<cfreturn variables.feedDAO.readByName(arguments.name,arguments.siteid,bean) />
	</cfif>

</cffunction>

<cffunction name="readByRemoteID" output="false">
	<cfargument name="remoteID" type="String" />
	<cfargument name="siteid" type="String" />
	<cfargument name="feedBean" required="true" default=""/>
	<cfset var key= "feed" & arguments.siteid & arguments.remoteid />
	<cfset var site=getBean('settingsManager').getSite(arguments.siteid)/>
	<cfset var cacheFactory=site.getCacheFactory(name="data")>
	<cfset var bean=arguments.feedBean>

	<cfif site.getCache()>
		<!--- check to see if it is cached. if not then pass in the context --->
		<!--- otherwise grab it from the cache --->
		<cfif NOT cacheFactory.has( key )>
			<cfset bean=variables.feedDAO.readByRemoteID(arguments.remoteID,arguments.siteid,bean) />
			<cfif not isArray(bean) and not bean.getIsNew()>
				<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
			</cfif>
			<cfset commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: feedBean, key: #key#}"))>
			<cfreturn bean/>
		<cfelse>
			<cftry>
				<cfif not isObject(bean)>
					<cfset bean=getBean("feed")/>
				</cfif>
				<cfset commitTracePoint(initTracePoint(detail="DATA CACHE HIT: {class: feedBean, key: #key#}"))>
				<cfset bean.setAllValues( structCopy(cacheFactory.get( key )) )>
				<cfset bean.setValue('frommuracache',true)>
				<cfreturn bean />
				<cfcatch>
					<cfset bean=variables.feedDAO.readByRemoteID(arguments.remoteID,arguments.siteid,bean) />
					<cfif not isArray(bean) and not bean.getIsNew()>
						<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
					</cfif>
					<cfset commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: feedBean, key: #key#}"))>
					<cfreturn bean/>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfset commitTracePoint(initTracePoint(detail="Loading feedBean"))>
		<cfreturn variables.feedDAO.readByRemoteID(arguments.remoteID,arguments.siteid,bean) />
	</cfif>

</cffunction>

<cffunction name="purgeFeedCache" output="false">
	<cfargument name="feedID">
	<cfargument name="feedBean">
	<cfargument name="broadcast" default="true">

	<cfif not isDefined("arguments.feedBean")>
		<cfset arguments.feedBean=read(feedID=arguments.feedID)>
	</cfif>

	<cfif arguments.feedBean.exists()>
		<cfset var siteid=arguments.feedBean.getSiteid()>
		<cfset var cache=getBean('settingsManager').getSite(siteid).getCacheFactory(name="data")>

		<cfset cache.purge("feed" & siteid & arguments.feedBean.getFeedID())>

		<cfif len(arguments.feedBean.getRemoteID())>
			<cfset cache.purge("feed" & siteid & arguments.feedBean.getRemoteID())>
		</cfif>
		<cfif len(arguments.feedBean.getName())>
			<cfset cache.purge("feed" & siteid & arguments.feedBean.getName())>
		</cfif>
	</cfif>

	<cfif arguments.broadcast>
		<cfset getBean('clusterManager').purgeFeedCache(userID=arguments.feedBean.getFeedID())>
	</cfif>

</cffunction>

<cffunction name="doImport" returntype="struct" output="false">
	<cfargument name="data" type="struct" />
	<cfreturn variables.feedUtility.doImport(arguments.data) />

</cffunction>

<cffunction name="doAutoImport" output="false">
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

<cffunction name="update" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>

	<cfset var feedBean=variables.feedDAO.read(arguments.data.feedID) />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
	<cfset var sessionData=getSession()>
	<cfset feedBean.set(arguments.data) />
	<cfset feedBean.validate()>

	<cfset pluginEvent.setValue("feedBean",feedBean)>
	<cfset pluginEvent.setValue("bean",feedBean)>
	<cfset pluginEvent.setValue("siteID",feedBean.getSiteID())>
	<cfset variables.pluginManager.announceEvent(eventToAnnounce="onBeforeFeedSave",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
	<cfset variables.pluginManager.announceEvent(eventToAnnounce="onBeforeFeedUpdate",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>

	<cfif structIsEmpty(feedBean.getErrors())>
		<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was updated","mura-content","Information",true) />
		<cfset feedBean.setLastUpdate(now())>
		<cfset feedBean.setLastUpdateBy(left(sessionData.mura.fname & " " & sessionData.mura.lname,50) ) />
		<cfset variables.feedDAO.update(feedBean) />
		<cfset purgeFeedCache(feedBean=feedBean)>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onFeedSave",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onFeedUpdate",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onAfterFeedSave",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onAfterFeedUpdate",currentEventObject=pluginEvent,objectid=feedBean.getFeedID())>
	</cfif>

	<cfreturn feedBean />
</cffunction>

<cffunction name="save" output="false">
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

<cffunction name="delete" output="false">
	<cfargument name="feedID" type="String" />

	<cfset var feedBean=read(arguments.feedID) />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments) />

	<cfif not feedBean.getIsLocked()>
		<cfset pluginEvent.setValue("feedBean",feedBean)>
		<cfset pluginEvent.setValue("bean",feedBean)>
		<cfset pluginEvent.setValue("siteID",feedBean.getSiteID())>

		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onBeforeFeedDelete",currentEventObject=pluginEvent,objectid=feedBean.getContentID())>
		<cfset variables.trashManager.throwIn(feedBean,'feed')>
		<cfset variables.globalUtility.logEvent("feedID:#feedBean.getfeedID()# Name:#feedBean.getName()# was deleted","mura-content","Information",true) />
		<cfset variables.feedDAO.delete(arguments.feedID) />
		<cfset purgeFeedCache(feedBean=feedBean)>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onFeedDelete",currentEventObject=pluginEvent,objectid=feedBean.getContentID())>
		<cfset variables.pluginManager.announceEvent(eventToAnnounce="onAfterFeedDelete",currentEventObject=pluginEvent,objectid=feedBean.getContentID())>
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
			<cfset var sessionData=getSession()>

			<cfif listFind(sessionData.mura.memberships,'S2IsPrivate;#arguments.feedBean.getSiteID()#')>
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

<cffunction name="getDefaultFeeds" output="false">
	<cfargument name="siteID" type="string" />

	<cfreturn variables.feedgateway.getDefaultFeeds(arguments.siteID) />
</cffunction>

<cffunction name="getFeedsByCategoryID" output="false">
	<cfargument name="categoryID" type="string" />
	<cfargument name="siteID" type="string" />

	<cfreturn variables.feedgateway.getFeedsByCategoryID(arguments.categoryID, arguments.siteID) />
</cffunction>

<cffunction name="getRemoteFeedData" output="false">
	<cfargument name="feedURL" required="true" >
	<cfargument name="maxItems" required="true" >
	<cfargument name="timeout" required="true" default="5" >
	<cfargument name="authtype" required="true" default="">
	<cfargument name="siteid" required="true" default="default">

	<cfset var key= arguments.feedURL />
	<cfset var site=getBean('settingsManager').getSite(arguments.siteid)/>
	<cfset var cacheFactory=site.getCacheFactory(name="data")>
	<cfset var feedData="">

	<cfif site.getCache()>
		<!--- check to see if it is cached. if not then pass in the context --->
		<!--- otherwise grab it from the cache --->
		<cfif NOT cacheFactory.has( key )>
			<cfreturn variables.feedUtility.getRemoteFeedData(argumentCollection=arguments)>
			<cfif not IsSimpleValue(feedData)>
				<cfset cacheFactory.get( key=key, context=structCopy(feedData),timespan=CreateTimeSpan(0,0,5,0) ) />
			</cfif>
			<cfset commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: feedBean, key: #key#}"))>
			<cfreturn feedData/>
		<cfelse>
			<cftry>
				<cfset feedData=structCopy(cacheFactory.get( key ))>
				<cfset feedData.frommuracache=true>
				<cfset commitTracePoint(initTracePoint(detail="DATA CACHE HIT: {class: feedBean, key: #key#}"))>
				<cfreturn feedData />
				<cfcatch>
					<cfset feedData=variables.feedUtility.getRemoteFeedData(argumentCollection=arguments)>
					<cfif not IsSimpleValue(feedData)>
						<cfset cacheFactory.get( key=key, context=structCopy(feedData),timespan=CreateTimeSpan(0,0,5,0) ) />
					</cfif>
					<cfset commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: feedBean, key: #key#}"))>
					<cfreturn feedData/>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfreturn variables.feedUtility.getRemoteFeedData(argumentCollection=arguments)>
	</cfif>

</cffunction>

</cfcomponent>
