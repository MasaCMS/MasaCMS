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

<cfset variables.instance.subTypeID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.type=""/>
<cfset variables.instance.subtype="Default"/>
<cfset variables.instance.baseTable=""/>
<cfset variables.instance.baseKeyField=""/>
<cfset variables.instance.dataTable="tclassextenddata"/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.hasSummary=1/>
<cfset variables.instance.iconclass=""/>
<cfset variables.instance.hasBody=1/>
<cfset variables.instance.HasAssocFile=1/>
<cfset variables.instance.HasConfigurator=1/>
<cfset variables.instance.description=""/>
<cfset variables.instance.availableSubTypes=""/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.sets=""/>
<cfset variables.instance.isNew=1/>
<cfset variables.instance.errors=structnew() />
<cfset variables.contentRenderer="" />

<cfset variables.iconsclasses="icon-adjust,icon-anchor,icon-archive,icon-asterisk,icon-ban-circle,icon-bar-chart,icon-barcode,icon-beaker,icon-beer,icon-bell,icon-bell-alt,icon-bolt,icon-book,icon-bookmark,icon-bookmark-empty,icon-briefcase,icon-bug,icon-building,icon-bullhorn,icon-bullseye,icon-calendar,icon-calendar-empty,icon-camera,icon-camera-retro,icon-certificate,icon-check,icon-check-empty,icon-check-minus,icon-check-sign,icon-circle,icon-circle-blank,icon-cloud,icon-cloud-download,icon-cloud-upload,icon-code,icon-code-fork,icon-coffee,icon-cog,icon-cogs,icon-collapse,icon-collapse-alt,icon-collapse-top,icon-comment,icon-comment-alt,icon-comments,icon-comments-alt,icon-compass,icon-credit-card,icon-crop,icon-dashboard,icon-desktop,icon-download,icon-download-alt,icon-edit,icon-edit-sign,icon-ellipsis-horizontal,icon-ellipsis-vertical,icon-envelope,icon-envelope-alt,icon-eraser,icon-exchange,icon-exclamation,icon-exclamation-sign,icon-expand,icon-expand-alt,icon-external-link,icon-external-link-sign,icon-eye-close,icon-eye-open,icon-facetime-video,icon-female,icon-fighter-jet,icon-film,icon-filter,icon-fire,icon-fire-extinguisher,icon-flag,icon-flag-alt,icon-flag-checkered,icon-folder-close,icon-folder-close-alt,icon-folder-open,icon-folder-open-alt,icon-food,icon-frown,icon-gamepad,icon-gift,icon-glass,icon-globe,icon-group,icon-hdd,icon-headphones,icon-heart,icon-heart-empty,icon-home,icon-inbox,icon-info,icon-info-sign,icon-key,icon-keyboard,icon-laptop,icon-leaf,icon-legal,icon-lemon,icon-level-down,icon-level-up,icon-lightbulb,icon-location-arrow,icon-lock,icon-magic,icon-magnet,icon-mail-reply-all,icon-male,icon-map-marker,icon-meh,icon-microphone,icon-microphone-off,icon-minus,icon-minus-sign,icon-minus-sign-alt,icon-mobile-phone,icon-money,icon-moon,icon-move,icon-music,icon-off,icon-ok,icon-ok-circle,icon-ok-sign,icon-pencil,icon-phone,icon-phone-sign,icon-picture,icon-plane,icon-plus,icon-plus-sign,icon-plus-sign-alt,icon-print,icon-pushpin,icon-puzzle-piece,icon-qrcode,icon-question,icon-question-sign,icon-quote-left,icon-quote-right,icon-random,icon-refresh,icon-remove,icon-remove-circle,icon-remove-sign,icon-reorder,icon-reply,icon-reply-all,icon-resize-horizontal,icon-resize-vertical,icon-retweet,icon-road,icon-rocket,icon-rss,icon-rss-sign,icon-screenshot,icon-search,icon-share,icon-share-alt,icon-share-sign,icon-shield,icon-shopping-cart,icon-sign-blank,icon-signal,icon-signin,icon-signout,icon-sitemap,icon-smile,icon-sort,icon-sort-by-alphabet,icon-sort-by-alphabet-alt,icon-sort-by-attributes,icon-sort-by-attributes-alt,icon-sort-by-order,icon-sort-by-order-alt,icon-sort-down,icon-sort-up,icon-spinner,icon-star,icon-star-empty,icon-star-half,icon-star-half-empty,icon-subscript,icon-suitcase,icon-sun,icon-superscript,icon-tablet,icon-tag,icon-tags,icon-tasks,icon-terminal,icon-thumbs-down,icon-thumbs-down-alt,icon-thumbs-up,icon-thumbs-up-alt,icon-ticket,icon-time,icon-tint,icon-trash,icon-trophy,icon-truck,icon-umbrella,icon-unlock,icon-unlock-alt,icon-upload,icon-upload-alt,icon-user,icon-volume-down,icon-volume-off,icon-volume-up,icon-warning-sign,icon-wrench,icon-zoom-in,icon-zoom-out,icon-btc,icon-cny,icon-eur,icon-gbp,icon-inr,icon-jpy,icon-krw,icon-usd,icon-align-center,icon-align-justify,icon-align-left,icon-align-right,icon-bold,icon-columns,icon-copy,icon-cut,icon-eraser,icon-file,icon-file-alt,icon-file-text,icon-file-text-alt,icon-font,icon-indent-left,icon-indent-right,icon-italic,icon-link,icon-list,icon-list-alt,icon-list-ol,icon-list-ul,icon-paper-clip,icon-paste,icon-repeat,icon-save,icon-strikethrough,icon-table,icon-text-height,icon-text-width,icon-th,icon-th-large,icon-th-list,icon-underline,icon-undo,icon-unlink,icon-angle-down,icon-angle-left,icon-angle-right,icon-angle-up,icon-arrow-down,icon-arrow-left,icon-arrow-right,icon-arrow-up,icon-caret-down,icon-caret-left,icon-caret-right,icon-caret-up,icon-chevron-down,icon-chevron-left,icon-chevron-right,icon-chevron-sign-down,icon-chevron-sign-left,icon-chevron-sign-right,icon-chevron-sign-up,icon-chevron-up,icon-circle-arrow-down,icon-circle-arrow-left,icon-circle-arrow-right,icon-circle-arrow-up,icon-double-angle-down,icon-double-angle-left,icon-double-angle-right,icon-double-angle-up,icon-hand-down,icon-hand-left,icon-hand-right,icon-hand-up,icon-long-arrow-down,icon-long-arrow-left,icon-long-arrow-right,icon-long-arrow-up,icon-backward,icon-eject,icon-fast-backward,icon-fast-forward,icon-forward,icon-fullscreen,icon-pause,icon-play,icon-play-circle,icon-play-sign,icon-resize-full,icon-resize-small,icon-step-backward,icon-step-forward,icon-stop,icon-youtube-play,icon-adn,icon-android,icon-apple,icon-bitbucket,icon-bitbucket-sign,icon-btc,icon-css3,icon-dribbble,icon-dropbox,icon-facebook,icon-facebook-sign,icon-flickr,icon-foursquare,icon-github,icon-github-alt,icon-github-sign,icon-gittip,icon-google-plus,icon-google-plus-sign,icon-html5,icon-instagram,icon-linkedin,icon-linkedin-sign,icon-linux,icon-maxcdn,icon-pinterest,icon-pinterest-sign,icon-renren,icon-skype,icon-stackexchange,icon-trello,icon-tumblr,icon-tumblr-sign,icon-twitter,icon-twitter-sign,icon-vk,icon-weibo,icon-windows,icon-xing,icon-xing-sign,icon-youtube,icon-youtube-play,icon-youtube-sign,icon-ambulance,icon-h-sign,icon-hospital,icon-medkit,icon-plus-sign-alt,icon-stethoscope,icon-user-md">

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
	<cfreturn this />
</cffunction>

<cffunction name="getIconClasses" output="false">
	<cfreturn variables.iconsclasses>
</cffunction>

<cffunction name="getExtendSetBean" returnType="any">
	<cfset var extendSetBean=createObject("component","mura.extend.extendSet").init(variables.configBean,getContentRenderer()) />
	<cfset extendSetBean.setSubTypeID(getSubTypeID()) />
	<cfset extendSetBean.setSiteID(getSiteID()) />
	<cfreturn extendSetBean />
</cffunction>

<cffunction name="getRelatedContentSetBean" returnType="any">
	<cfset var rcsBean = getBean('relatedContentSet') />
	<cfset rcsBean.setSubTypeID(getSubTypeID()) />
	<cfset rcsBean.setSiteID(getSiteID()) />
	<cfreturn rcsBean />
</cffunction>

<cffunction name="load">
	<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select subtypeid,siteID,baseTable,baseKeyField,dataTable,type,subtype,
		isActive,notes,lastUpdate,dateCreated,lastUpdateBy,hasSummary,hasBody,description,availableSubTypes,iconclass,hasassocfile,hasConfigurator
		from tclassextend 
		where subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtypeID()#">
		or (
			siteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
			and type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#gettype()#">
			and subType=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtype()#">
			)
		order by type,subType
		</cfquery>
	
	<cfif rs.recordcount>
		<cfset set(rs) />
		<cfset setIsNew(0)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="set" output="false" access="public">
		<cfargument name="property" required="true">
		<cfargument name="propertyValue">  	
		
		<cfif not isDefined('arguments.data')>
			<cfif isSimpleValue(arguments.property)>
				<cfreturn setValue(argumentCollection=arguments)>
			</cfif>

			<cfset arguments.data=arguments.property>
		</cfif>

		<cfset var prop=""/>
		<cfset var tempFunc="">
		
		<cfif isquery(arguments.data)>
		
			<cfset setSubTypeID(arguments.data.subTypeID) />
			<cfset setSiteID(arguments.data.siteID) />
			<cfset setType(arguments.data.type) />
			<cfset setSubType(arguments.data.subType) />
			<cfset setBaseTable(arguments.data.BaseTable) />
			<cfset setDataTable(arguments.data.DataTable) />
			<cfset setbaseKeyField(arguments.data.baseKeyField) />
			<cfset setIsActive(arguments.data.isActive) />
			<cfset setHasSummary(arguments.data.hasSummary) />
			<cfset setHasConfigurator(arguments.data.hasConfigurator) />
			<cfset setHasBody(arguments.data.hasBody) />
			<cfset setHasAssocFile(arguments.data.HasAssocFile) />
			<cfset setHasConfigurator(arguments.data.hasConfigurator) />
			<cfset setDescription(arguments.data.description)/>
			<cfset setIconClass(arguments.data.iconclass)/>
			<cfset setAvailableSubTypes(arguments.data.availableSubTypes)/>
			
		<cfelseif isStruct(arguments.data)>
			
			<cfloop collection="#arguments.data#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset tempFunc=this["set#prop#"]>
          			<cfset tempFunc(arguments.data['#prop#'])>
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfset validate() />
		<cfreturn this>
</cffunction>
  
<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getSubTypeID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.SubTypeID)>
		<cfset variables.instance.SubTypeID = createUUID() />
	</cfif>
	<cfreturn variables.instance.SubTypeID />
</cffunction>

<cffunction name="setSubTypeID" access="public" output="false">
	<cfargument name="SubTypeID" type="String" />
	<cfset variables.instance.SubTypeID = trim(arguments.SubTypeID) />
	<cfreturn this>
</cffunction>

<cffunction name="getType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="setType" access="public" output="false">
	<cfargument name="Type" type="String" />
	<cfif arguments.type eq 'Portal'>
		<cfset arguments.type='Folder'>
	</cfif>
	<cfset variables.instance.Type = trim(arguments.Type) />
	<cfreturn this>
</cffunction>

<cffunction name="getSubType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SubType />
</cffunction>

<cffunction name="setSubType" access="public" output="false">
	<cfargument name="SubType" type="String" />
	<cfset variables.instance.SubType = trim(arguments.SubType) />
	<cfreturn this>
</cffunction>

<cffunction name="getDataTable" returntype="String" access="public" output="false">
	<cfreturn variables.instance.DataTable />
</cffunction>

<cffunction name="setDataTable" access="public" output="false">
	<cfargument name="DataTable" type="String" />
	<cfif len(trim(arguments.dataTable))>
		<cfset variables.instance.DataTable = trim(arguments.DataTable) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getBaseTable" returntype="String" access="public" output="false">
	<cfreturn variables.instance.BaseTable />
</cffunction>

<cffunction name="setBaseTable" access="public" output="false">
	<cfargument name="BaseTable" type="String" />
	<cfif len(trim(arguments.BaseTable))>
		<cfset variables.instance.BaseTable = trim(arguments.BaseTable) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getbaseKeyField" returntype="String" access="public" output="false">
	<cfreturn variables.instance.baseKeyField />
</cffunction>

<cffunction name="setbaseKeyField" access="public" output="false">
	<cfargument name="baseKeyField" type="String" />
	<cfif len(trim(arguments.baseKeyField))>
		<cfset variables.instance.baseKeyField = trim(arguments.baseKeyField) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.IsActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="IsActive"/>
	<cfif isBoolean(arguments.IsActive)>
		<cfif arguments.IsActive>
			<cfset variables.instance.IsActive = 1 />
		<cfelse>
			<cfset variables.instance.IsActive = 0 />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getHasSummary" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.hasSummary />
</cffunction>

<cffunction name="setHasSummary" access="public" output="false">
	<cfargument name="hasSummary"/>
	<cfif isBoolean(arguments.hasSummary)>
		<cfif arguments.hasSummary>
			<cfset variables.instance.hasSummary = 1 />
		<cfelse>
			<cfset variables.instance.hasSummary = 0 />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getHasBody" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.hasBody />
</cffunction>

<cffunction name="setHasBody" access="public" output="false">
	<cfargument name="hasBody"/>
	<cfif isBoolean(arguments.hasBody)>
		<cfif arguments.hasBody>
			<cfset variables.instance.hasBody = 1 />
		<cfelse>
			<cfset variables.instance.hasBody = 0 />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getHasAssocFile" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.HasAssocFile />
</cffunction>

<cffunction name="setHasAssocFile" access="public" output="false">
	<cfargument name="HasAssocFile"/>
	<cfif isBoolean(arguments.HasAssocFile)>
		<cfif arguments.hasAssocFile>
			<cfset variables.instance.HasAssocFile = 1 />
		<cfelse>
			<cfset variables.instance.HasAssocFile = 0 />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getHasConfigurator" returntype="numeric" access="public" output="false">
	<cfif listFindNoCase("Folder,Gallery,Calendar",getType())>
		<cfreturn variables.instance.HasConfigurator />
	<cfelse>
		<cfreturn 0 />
	</cfif>
	
</cffunction>

<cffunction name="setHasConfigurator" access="public" output="false">
	<cfargument name="HasConfigurator"/>
	<cfif isNumeric(arguments.HasConfigurator)>
		<cfset variables.instance.HasConfigurator = arguments.HasConfigurator />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDescription" returntype="String" access="public" output="false">
	<cfreturn variables.instance.description />
</cffunction>

<cffunction name="setDescription" access="public" output="false">
	<cfargument name="description" type="String" />
	<cfset variables.instance.description = trim(arguments.description) />
	<cfreturn this>
</cffunction>

<cffunction name="getIconClass" returntype="String" access="public" output="false">
	<cfargument name="includeDefault" default="false">
	<cfset var returnVar = variables.instance.iconclass>
	
	<cfif not len(returnVar) and includeDefault>
		<cfset returnVar=getDefaultIconClass()>
	</cfif>
	
	<cfreturn returnVar>
</cffunction>

<cffunction name="getDefaultIconClass" returntype="String" access="public" output="false">
	<cfset var returnVar="">
	
	<cfswitch expression="#getType()#">
		<cfcase value="page">
			<cfset returnVar = "icon-file">
		</cfcase>
		<cfcase value="folder">
			<cfset returnVar = "icon-folder-open-alt">
		</cfcase>
		<cfcase value="file">
			<cfset returnVar = "icon-file-text-alt">
		</cfcase>
		<cfcase value="link">
			<cfset returnVar = "icon-link">
		</cfcase>
		<cfcase value="calendar">
			<cfset returnVar = "icon-calendar">
		</cfcase>
		<cfcase value="gallery">
			<cfset returnVar = "icon-th">
		</cfcase>
		<cfcase value="1">
			<cfset returnVar = "icon-group">
		</cfcase>
		<cfcase value="2">
			<cfset returnVar = "icon-user">
		</cfcase>
		<cfdefaultcase>
			<cfset returnVar = "icon-cog">
		</cfdefaultcase>
	</cfswitch> 

	<cfreturn returnVar>
</cffunction>

<cffunction name="setIconClass" access="public" output="false">
	<cfargument name="iconclass" type="String" />
	<cfif len(arguments.iconclass)>
		<cfset variables.instance.iconclass = trim(arguments.iconclass) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAvailableSubTypes" returntype="String" access="public" output="false">
	<cfreturn variables.instance.availableSubTypes />
</cffunction>

<cffunction name="setAvailableSubTypes" access="public" output="false">
	<cfargument name="availableSubTypes" type="String" />
	<cfset variables.instance.availableSubTypes = trim(arguments.availableSubTypes) />
	<cfreturn this>
</cffunction>

<cffunction name="getIsNew" output="false">
	<cfreturn variables.instance.isNew>
</cffunction>

<cffunction name="setIsNew" output="false">
	<cfargument name="isNew">
	<cfset variables.instance.isNew=arguments.isNew>
	<cfreturn this>
</cffunction>

<cffunction name="getExtendSets" access="public" returntype="array">
<cfargument name="Inherit" required="true" default="false"/>
<cfargument name="doFilter" required="true" default="false"/>
<cfargument name="filter" required="true" default=""/>
<cfargument name="container" required="true" default=""/>
<cfargument name="activeOnly" required="true" default="false"/>
<cfset var rs=""/>
<cfset var tempArray=""/>
<cfset var extendSet=""/>
<cfset var extendArray=arrayNew(1) />
<cfset var rsSets=""/>
<cfset var extendSetBean=""/>
<cfset var s=0/>

	<cfset rsSets=getSetsQuery(arguments.inherit,arguments.doFilter,arguments.filter,arguments.container,arguments.activeOnly)/>
	
	<cfif rsSets.recordcount>
		<cfset tempArray=createObject("component","mura.queryTool").init(rsSets).toArray() />
		
		<cfloop from="1" to="#rsSets.recordcount#" index="s">
			
			<cfset extendSetBean=getExtendSetBean() />
			<cfset extendSetBean.set(tempArray[s]) />
			<cfset arrayAppend(extendArray,extendSetBean)/>
		</cfloop>
		
	</cfif>
	
	<cfreturn extendArray />
</cffunction>

<cffunction name="getRelatedContentSets" access="public" returntype="array">
	<cfargument name="includeInheritedSets" required="true" default="true"/>
	<cfset var tempArray=""/>
	<cfset var relatedContentSetArray=arrayNew(1) />
	<cfset var rsSets=""/>
	<cfset var relatedContentSetBean=""/>
	<cfset var s=0/>
	<cfset var inheritanceList="ID,TYPE,BASE"/>
	<cfset var i=""/>
	<cfset var process="">
	
	<cfloop list="#inheritanceList#" index="i">
		<cfset process = false>
		<cfswitch expression="#i#">
			<cfcase value="ID">
				<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsSets')#">
					select * from tclassextendrcsets where 
					siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#"> 
					and subTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSubTypeID()#"> 
					order by orderNo
				</cfquery>
				<cfset process = true>
			</cfcase>
			<cfcase value="TYPE">
				<cfif arguments.includeInheritedSets and getSubType() neq "Default">
					<!--- get type/default --->
					<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsSets')#">
						select * from tclassextendrcsets where 
						siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#"> 
						and subTypeID in (select subTypeID from tclassextend where (type = <cfqueryparam CFSQLType="cf_sql_varchar" value="#getType()#"> and subType = 'Default' and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">))
						order by orderNo
					</cfquery>
					<cfset process = true>
				</cfif>
			</cfcase>
			<cfcase value="BASE">
				<cfif arguments.includeInheritedSets and not listFindNoCase("1,2,User,Group,Address,Site,Component,Form", getType())>
					<!--- get base/default --->
					<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsSets')#">
						select * from tclassextendrcsets where 
						siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#"> 
						and subTypeID in (select subTypeID from tclassextend where (type = 'Base' and subType = 'Default' and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#"> ))
						order by orderNo
					</cfquery>
					<cfset process = true>
				</cfif>
			</cfcase>
		</cfswitch>
			
		<cfif process and rsSets.recordcount>
			<cfset tempArray=createObject("component","mura.queryTool").init(rsSets).toArray() />
			
			<cfloop from="1" to="#rsSets.recordcount#" index="s">
				
				<cfset relatedContentSetBean=getRelatedContentSetBean() />
				<cfset relatedContentSetBean.set(tempArray[s]) />
				<cfset arrayAppend(relatedContentSetArray,relatedContentSetBean)/>
			</cfloop>
		</cfif>
		
		<cfif arguments.includeInheritedSets and i eq "ID">
			<!--- include default set --->
			<cfset arrayAppend(relatedContentSetArray, getBean('relatedContentSet').setRelatedContentSetID('00000000000000000000000000000000000').setName('Default').setSiteID(getSiteID()))>
		</cfif>
	</cfloop>
	
	<cfreturn relatedContentSetArray />
</cffunction>

<cffunction name="save"  access="public" output="false">
<cfset var rs=""/>
<cfset var extendSetBean=""/>

	<cfif not len(getBaseTable())>
		<cfswitch expression="#getType()#">
			<cfcase value="Page,Folder,Component,File,Link,Calendar,Gallery,Base,Form">
				<cfset setBaseTable("tcontent")>
			</cfcase>
			<cfcase value="1,2,User,Group,Address">
				<cfset setBaseTable("tusers")>
			</cfcase>
		</cfswitch>
	</cfif>
	
	<cfif not len(getBaseKeyField())>
		<cfswitch expression="#getType()#">
			<cfcase value="Page,Folder,Component,File,Link,Calendar,Gallery,Base,Form">
				<cfset setBaseKeyField("contentHistID")>
			</cfcase>
			<cfcase value="1,2,User,Group,Address">
				<cfset setBaseKeyField("userID")>
			</cfcase>
		</cfswitch>
	</cfif>
	
	<cfif not len(getDataTable())>
		<cfswitch expression="#getType()#">
			<cfcase value="Page,Folder,Component,File,Link,Calendar,Gallery,Base,Form">
				<cfset setDataTable("tclassextenddata")>
			</cfcase>
			<cfcase value="1,2,User,Group,Address">
				<cfset setDataTable("tclassextenddatauseractivity")>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select subTypeID,type,subtype,siteid from tclassextend where subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSubTypeID()#">
	</cfquery>
	
	<cfif rs.recordcount>
		<cfquery>
		update tclassextend set
		siteID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		type = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
		subType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubType() neq '',de('no'),de('yes'))#" value="#getSubType()#" maxlength="25">,
		baseTable = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getBaseTable() neq '',de('no'),de('yes'))#" value="#getBaseTable()#">,
		baseKeyField = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getbaseKeyField() neq '',de('no'),de('yes'))#" value="#getbaseKeyField()#">,
		dataTable=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDataTable() neq '',de('no'),de('yes'))#" value="#getDataTable()#">,
		isActive = #getIsActive()#,
		hasSummary = #getHasSummary()#,
		hasBody = #getHasBody()#,
		description=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDescription() neq '',de('no'),de('yes'))#" value="#getDescription()#">,
		availableSubTypes=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getAvailableSubTypes() neq '',de('no'),de('yes'))#" value="#getAvailableSubTypes()#">,
		iconClass=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getIconClass() neq '',de('no'),de('yes'))#" value="#getIconClass()#">,
		hasAssocFile=#getHasAssocFile()#,
		hasConfigurator=#getHasConfigurator()#
		where subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSubTypeID()#">
		</cfquery>

		<cfif rs.subtype neq 'Default' and (rs.type neq getType() or rs.subtype neq getSubType() and getBaseTable() neq "Custom")
		and listFindNoCase('Folder,Page,Calendar,Gallery,File,link,Component,Form',rs.type) and listFindNoCase('Folder,Page,Calendar,Gallery,File,Link,Component,Form',getType())>
			<cfquery>
				update #getBaseTable()# set
				type = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
				subType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubType() neq '',de('no'),de('yes'))#" value="#getSubType()#" maxlength="25">
				where 
				subType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.subtype#" maxlength="25">
				and type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.type#">
				and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.siteID#">
			</cfquery>	
		</cfif>
		
	<cfelse>
	
		<cfquery>
		Insert into tclassextend (subTypeID,siteID,type,subType,baseTable,baseKeyField,dataTable,isActive,hasSummary,hasBody,description,availableSubTypes,iconclass,hasAssocFile,hasConfigurator) 
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubTypeID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubType() neq '',de('no'),de('yes'))#" value="#getSubType()#" maxlength="25">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getBaseTable() neq '',de('no'),de('yes'))#" value="#getBaseTable()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getbaseKeyField() neq '',de('no'),de('yes'))#" value="#getbaseKeyField()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDataTable() neq '',de('no'),de('yes'))#" value="#getDataTable()#">,
		#getIsActive()#,
		#getHasSummary()#,
		#getHasBody()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDescription() neq '',de('no'),de('yes'))#" value="#getDescription()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getAvailableSubTypes() neq '',de('no'),de('yes'))#" value="#getAvailableSubTypes()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getIconClass() neq '',de('no'),de('yes'))#" value="#getIconClass()#">,
		#getHasAssocFile()#,
		#getHasConfigurator()#
		)
		</cfquery>
		<!---
		<cfset extendSetBean=getExtendSetBean() />
		<cfset extendSetBean.setName('Default') />
		<cfset extendSetBean.setSiteID(getSiteID()) />
		<cfset extendSetBean.save() />
		--->
	</cfif>
	
	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>
	<cfset variables.classExtensionManager.setIconClass(type=getType(),subtype=getSubType(),siteid=getSiteID(),iconclass=getIconClass())>
	<cfreturn this>
</cffunction>

<cffunction name="getExtendSetByName" access="public" output="false" returntype="any">
<cfargument name="name">
<cfset var extendSets=getExtendSets()/>
<cfset var i=0/>
<cfset var extendSet=""/>
	<cfif arrayLen(extendSets)>
	<cfloop from="1" to="#arrayLen(extendSets)#" index="i">
		<cfif extendSets[i].getName() eq arguments.name>
			<cfreturn extendSets[i]/>
		</cfif>
	</cfloop>
	</cfif>
	
	<cfset extendSet=getExtendSetBean()>
	<cfset extendSet.setName(arguments.name)>
	<cfreturn extendSet/>
</cffunction>

<cffunction name="delete" access="public">
<cfset var rs=""/>
<cfset var rsSets=""/>


	<cfset rsSets=getSetsQuery()/>
	
	<cfif rsSets.recordcount>	
		<cfloop query="rsSets">
			<cfset deleteSet(rsSets.ExtendSetID)/>
		</cfloop>
	</cfif>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextend 
	where 
	subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtypeID()#">
	</cfquery>
	
	<cfif not listFindNoCase("Custom,Site,Base",getType())>
		<cfquery>
		update #getBaseTable()#
		set subType='Default'
		where 
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
		and subType=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtype()#">
		</cfquery>
	</cfif>
	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>
	
</cffunction>

<cffunction name="loadSet" access="public" returntype="any">
<cfargument name="ExtendSetID">
<cfset var extendSetBean=getExtendSetBean() />
	
	<cfset extendSetBean.setExtendSetID(arguments.ExtendSetID)/>
	<cfset extendSetBean.load()/>
	<cfreturn extendSetBean/>

</cffunction>

<cffunction name="addExtendSet" access="public" output="false">
<cfargument name="rawdata">
<cfset var extendSet=""/>
<cfset var data=arguments.rawdata />

	<cfif not isObject(data)>
		<cfset extendSet=getExtendSetBean() />
		<cfset extendSet.set(data)/>
	<cfelse>
		<cfset extendSet=data />
	</cfif>
	
	<cfset extendSet.setSubTypeID(getSubTypeID())/>
	<cfset extendSet.setSiteID(getSiteID())/>
	<cfset extendSet.save()/>
	<cfset arrayAppend(getExtendSets(),extendSet)/>
	<cfreturn this>
</cffunction>

<cffunction name="deleteSet" access="public">
<cfargument name="ExtendSetID">
<cfset var extendSetBean=getExtendSetBean() />
			
			<cfset extendSetBean.setExtendSetID(ExtendSetID) />
			<cfset extendSetBean.delete() />
</cffunction>

<cffunction name="getSetsQuery" access="public" returntype="query">
<cfargument name="Inherit" required="true" default="false"/>
<cfargument name="doFilter" required="true" default="false"/>
<cfargument name="filter" required="true" default=""/>
<cfargument name="container" required="true" default=""/>
<cfargument name="activeOnly" required="true" default="false"/>
<cfset var rs=""/>
<cfset var rsFinal=""/>
<cfset var f=""/>
<cfset var rsDefault=""/>
<cfset var fLen=listLen(arguments.filter)/>

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select tclassextendsets.ExtendSetID,tclassextendsets.subTypeID,tclassextendsets.name,tclassextendsets.orderno,tclassextendsets.isActive,tclassextendsets.siteID,tclassextendsets.categoryID,tclassextendsets.orderno,0 as setlevel 
		from tclassextendsets
		inner join tclassextend on (tclassextendsets.subtypeid=tclassextend.subtypeID) 
		where tclassextendsets.subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtypeID()#">
		and tclassextendsets.siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
		<cfif arguments.activeOnly>
			and tclassextend.isActive=1
		</cfif>
		<cfif arguments.doFilter and fLen>
		and (
		<cfloop from="1" to="#fLen#" index="f">
		tclassextendsets.categoryID like '%#listGetAt(arguments.filter,f)#%' <cfif f lt fLen>or</cfif> 
		</cfloop>
		)
		<cfelseif arguments.doFilter>
		and tclassextendsets.categoryID is null
		</cfif>
		
		<cfif len(arguments.container)>
		and tclassextendsets.container=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.container#">
		</cfif>
		
		<cfif arguments.inherit>
			<cfif getSubType() neq "Default">
				Union All

				select tclassextendsets.ExtendSetID,tclassextendsets.subTypeID,tclassextendsets.name,tclassextendsets.orderno,tclassextendsets.isActive,tclassextendsets.siteID,tclassextendsets.categoryID,tclassextendsets.orderno,1 as setlevel from tclassextendsets 
			    Inner Join tclassextend
			    On (tclassextendsets.subTypeID=tclassextend.subTypeID)
				where
				tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getType()#">
				and tclassextend.subType=<cfqueryparam cfsqltype="cf_sql_varchar"  value="Default">
				and tclassextend.siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
				<cfif arguments.doFilter and fLen>
				and (
				<cfloop from="1" to="#fLen#" index="f">
				tclassextendsets.categoryID like '%#listGetAt(arguments.filter,f)#%' <cfif f lt fLen>or</cfif> 
				</cfloop>
				)
				<cfelseif arguments.doFilter>
				and tclassextendsets.categoryID is null
				</cfif>
				<cfif len(arguments.container)>
				and tclassextendsets.container=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.container#">
				</cfif>
			</cfif>
			
			<cfif not listFindNoCase("1,2,User,Group,Address,Site,Component,Form",getType())>
				Union All

				select tclassextendsets.ExtendSetID,tclassextendsets.subTypeID,tclassextendsets.name,tclassextendsets.orderno,tclassextendsets.isActive,tclassextendsets.siteID,tclassextendsets.categoryID,tclassextendsets.orderno,2 as setlevel from tclassextendsets 
				Inner Join tclassextend
				On (tclassextendsets.subTypeID=tclassextend.subTypeID)
				where
				tclassextend.type='Base'
				and (
					tclassextend.subType=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSubType()#">
					<cfif getType() neq "Default">
						or tclassextend.subType='Default'
					</cfif>
				)
				and tclassextend.siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
				<cfif arguments.doFilter and fLen>
				and (
				<cfloop from="1" to="#fLen#" index="f">
				tclassextendsets.categoryID like '%#listGetAt(arguments.filter,f)#%' <cfif f lt fLen>or</cfif> 
				</cfloop>
					)
				<cfelseif arguments.doFilter>
				and tclassextendsets.categoryID is null
				</cfif>
				<cfif len(arguments.container)>
				and tclassextendsets.container=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.container#">
				</cfif>
			</cfif>
		</cfif>
		</cfquery>

		<cfquery name="rsFinal" dbtype="query">
		select * from rs order by setlevel desc, orderno
		</cfquery>
		
	<cfreturn rsFinal />
</cffunction>

<cffunction name="getTypeAsString" returntype="string">

<cfif isNumeric(getType())>
	<cfif arguments.type eq 1>
	<cfreturn "User Group">
	<cfelse>
	<cfreturn "User">
	</cfif>
<cfelse>
	<cfreturn getType() />
</cfif>
</cffunction>

<cffunction name="getContentRenderer" output="false">
	<cfif not isObject(variables.contentRenderer)>
		<cfif structKeyExists(request,"servletEvent")>
			<cfset variables.contentRenderer=request.servletEvent.getContentRenderer()>
		<cfelseif structKeyExists(request,"event")>
			<cfset variables.contentRenderer=request.event.getContentRenderer()>
		<cfelseif len(getSiteID())>
			<cfset variables.contentRenderer=getBean("$").init(getSiteID()).getContentRenderer()>
		<cfelse>
			<cfset variables.contentRenderer=getBean("contentRenderer")>
		</cfif>
	</cfif>

	<cfreturn variables.contentRenderer>
</cffunction>

<cffunction name="getAllValues" ouput="false">
 	
 	<cfset var extensionData = {} />
	<cfset var set = "" />
	<cfset var sets = getExtendSets() />
	<cfset var setStruct = {} />
	<cfset var i = 0 />

	<cfset extensionData = duplicate(variables.instance) />
	<cfset structDelete(extensionData,"errors") />
	<cfset extensionData.sets = [] />
	
	<cfloop from="1" to="#ArrayLen(sets)#" index="i">
		<cfset setStruct = sets[i].getAllValues() />
		<cfset ArrayAppend(extensionData.sets, setStruct ) />
	</cfloop>

	<cfreturn extensionData />	

</cffunction>

<cffunction name="getAsXML" ouput="false" returntype="xml">
	<cfargument name="documentXML" default="#xmlNew(true)#" />
	<cfargument name="includeIDs" type="boolean" default="false" >
	
	<cfset var extensionData = {} />
	<cfset var set = "" />
	<cfset var sets = getExtendSets() />
	<cfset var setStruct = {} />
	<cfset var item = "" />
	<cfset var i = 0 />
	<cfset var xmlRoot = XmlElemNew( documentXML, "", "extension" ) />

	<cfset var xmlAttributeSet = "" />
	
	<cfset extensionData = duplicate(variables.instance) />
	<cfset structDelete(extensionData,"sets") />
	<cfset structDelete(extensionData,"errors") />
		
	<cfif not(arguments.includeIDs)>
		<cfset structDelete(extensionData,"SubTypeID") />
	</cfif>
	<cfset structDelete(extensionData,"isNew") />
	<cfset structDelete(extensionData,"isActive") />
	<cfset structDelete(extensionData,"siteid") />
	 
	<cfloop collection="#extensionData#" item="item">
		<cfif isSimpleValue(extensionData[item])>
			<cfset xmlRoot.XmlAttributes[lcase(item)] = extensionData[item] />
		</cfif>
	</cfloop>
	
	<cfloop from="1" to="#ArrayLen(sets)#" index="i">
		<cfset xmlAttributeSet = sets[i].getAsXML(documentXML) />
		<cfset ArrayAppend(
			xmlRoot.XmlChildren,
			xmlAttributeSet
			) />
			
	</cfloop>

	<cfreturn xmlRoot />	
</cffunction>


</cfcomponent>