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
<cfcomponent extends="mura.cfobject" output="false" hint="Provide extend type/subtype CRUD functionality">

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
<cfset variables.instance.adminonly=0/>
<cfset variables.instance.errors=structnew() />
<cfset variables.contentRenderer="" />
<cfset variables.extendsetArray=""/>

<cfset variables.iconsclasses="mi-500px,mi-adjust,mi-adn,mi-align-center,mi-align-justify,mi-align-left,mi-align-right,mi-amazon,mi-ambulance,mi-anchor,mi-android,mi-angellist,mi-angle-double-down,mi-angle-double-left,mi-angle-double-right,mi-angle-double-up,mi-angle-down,mi-angle-left,mi-angle-right,mi-angle-up,mi-apple,mi-archive,mi-area-chart,mi-arrow-circle-down,mi-arrow-circle-left,mi-arrow-circle-o-down,mi-arrow-circle-o-left,mi-arrow-circle-o-right,mi-arrow-circle-o-up,mi-arrow-circle-right,mi-arrow-circle-up,mi-arrow-down,mi-arrow-left,mi-arrow-right,mi-arrows,mi-arrows-alt,mi-arrows-h,mi-arrows-v,mi-arrow-up,mi-asterisk,mi-at,mi-automobile,mi-backward,mi-balance-scale,mi-ban,mi-bank,mi-bar-chart,mi-barcode,mi-bars,mi-battery-empty,mi-battery-full,mi-battery-half,mi-battery-quarter,mi-battery-three-quarters,mi-bed,mi-beer,mi-behance,mi-behance-square,mi-bell,mi-bell-slash,mi-bell-slash-o,mi-bicycle,mi-binoculars,mi-birthday-cake,mi-bitbucket,mi-bitbucket-square,mi-bitcoin,mi-black-tie,mi-bold,mi-bolt,mi-bomb,mi-book,mi-bookmark,mi-bookmark-o,mi-briefcase,mi-bug,mi-building,mi-bullhorn,mi-bullseye,mi-bus,mi-buysellads,mi-calculator,mi-calendar,mi-calendar-check-o,mi-calendar-minus-o,mi-calendar-o,mi-calendar-plus-o,mi-calendar-times-o,mi-camera,mi-camera-retro,mi-caret-down,mi-caret-left,mi-caret-right,mi-caret-up,mi-cart-arrow-down,mi-cart-plus,mi-cc-amex,mi-cc-diners-club,mi-cc-discover,mi-cc-jcb,mi-cc-mastercard,mi-cc-paypal,mi-cc-stripe,mi-cc-visa,mi-certificate,mi-chain,mi-check,mi-check-circle,mi-check-circle-o,mi-check-square,mi-chevron-circle-down,mi-chevron-circle-left,mi-chevron-circle-right,mi-chevron-circle-up,mi-chevron-down,mi-chevron-left,mi-chevron-right,mi-chevron-up,mi-child,mi-chrome,mi-circle,mi-circle-o-notch,mi-circle-thin,mi-clock-o,mi-clone,mi-cloud,mi-cloud-download,mi-cloud-upload,mi-cny,mi-code,mi-code-fork,mi-codepen,mi-coffee,mi-cog,mi-cogs,mi-columns,mi-comment,mi-commenting,mi-commenting-o,mi-comment-o,mi-comments,mi-comments-o,mi-compass,mi-compress,mi-connectdevelop,mi-contao,mi-copy,mi-copyright,mi-creative-commons,mi-credit-card,mi-crop,mi-crosshairs,mi-css3,mi-cube,mi-cubes,mi-cut,mi-cutlery,mi-dashboard,mi-dashcube,mi-database,mi-delicious,mi-desktop,mi-deviantart,mi-diamond,mi-digg,mi-dollar,mi-dot-circle-o,mi-download,mi-dribbble,mi-dropbox,mi-drupal,mi-edit,mi-eject,mi-ellipsis-h,mi-ellipsis-v,mi-empire,mi-envelope,mi-envelope-square,mi-eraser,mi-euro,mi-exchange,mi-exclamation,mi-expand,mi-expeditedssl,mi-external-link,mi-external-link-square,mi-eye,mi-eyedropper,mi-eye-slash,mi-facebook,mi-facebook-official,mi-fast-backward,mi-fast-forward,mi-fax,mi-female,mi-fighter-jet,mi-file,mi-file-o,mi-file-audio-o,mi-file-code-o,mi-file-excel-o,mi-file-image-o,mi-file-pdf-o,mi-file-powerpoint-o,mi-file-text,mi-file-text-o,mi-file-video-o,mi-file-word-o,mi-file-zip-o,mi-film,mi-filter,mi-fire,mi-fire-extinguisher,mi-firefox,mi-flag,mi-flag-checkered,mi-flag-o,mi-flask,mi-flickr,mi-folder,mi-folder-open,mi-folder-open-o,mi-font,mi-fonticons,mi-forumbee,mi-forward,mi-foursquare,mi-frown-o,mi-futbol-o,mi-gamepad,mi-gavel,mi-gbp,mi-genderless,mi-get-pocket,mi-gg,mi-gg-circle,mi-gift,mi-github,mi-github-alt,mi-git-square,mi-glass,mi-globe,mi-google,mi-google-wallet,mi-gratipay,mi-hand-grab-o,mi-hand-lizard-o,mi-hand-o-down,mi-hand-o-left,mi-hand-o-right,mi-hand-o-up,mi-hand-paper-o,mi-hand-peace-o,mi-hand-pointer-o,mi-hand-rock-o,mi-hand-scissors-o,mi-hand-spock-o,mi-hdd-o,mi-header,mi-headphones,mi-heart,mi-heartbeat,mi-heart-o,mi-history,mi-home,mi-hospital-o,mi-hourglass,mi-hourglass-end,mi-hourglass-half,mi-hourglass-start,mi-houzz,mi-h-square,mi-html5,mi-i-cursor,mi-image,mi-inbox,mi-indent,mi-industry,mi-info,mi-instagram,mi-internet-explorer,mi-ioxhost,mi-italic,mi-joomla,mi-jsfiddle,mi-key,mi-keyboard-o,mi-language,mi-laptop,mi-lastfm,mi-lastfm-square,mi-leaf,mi-leanpub,mi-lemon-o,mi-level-down,mi-level-up,mi-lightbulb-o,mi-line-chart,mi-linkedin,mi-linux,mi-list,mi-list-ol,mi-list-ul,mi-location-arrow,mi-lock,mi-long-arrow-down,mi-long-arrow-left,mi-long-arrow-right,mi-long-arrow-up,mi-magic,mi-magnet,mi-mail-forward,mi-male,mi-map,mi-map-o,mi-map-pin,mi-map-signs,mi-mars,mi-mars-double,mi-mars-stroke,mi-mars-stroke-h,mi-mars-stroke-v,mi-maxcdn,mi-meanpath,mi-medium,mi-medkit,mi-meh-o,mi-mercury,mi-microphone,mi-microphone-slash,mi-minus,mi-minus-square,mi-minus-square-o,mi-mobile,mi-money,mi-moon-o,mi-mortar-board,mi-motorcycle,mi-mouse-pointer,mi-music,mi-neuter,mi-newspaper-o,mi-object-group,mi-object-ungroup,mi-odnoklassniki,mi-odnoklassniki-square,mi-openid,mi-opera,mi-optin-monster,mi-outdent,mi-pagelines,mi-paint-brush,mi-paperclip,mi-paragraph,mi-paste,mi-pause,mi-paw,mi-paypal,mi-pencil,mi-phone,mi-phone-square,mi-pie-chart,mi-pied-piper,mi-pied-piper-alt,mi-pinterest,mi-pinterest-p,mi-pinterest-square,mi-plane,mi-play,mi-plug,mi-plus,mi-plus-square,mi-plus-square-o,mi-power-off,mi-print,mi-puzzle-piece,mi-qq,mi-qrcode,mi-question,mi-quote-left,mi-quote-right,mi-random,mi-rebel,mi-recycle,mi-reddit,mi-reddit-square,mi-refresh,mi-registered,mi-renren,mi-reply,mi-reply-all,mi-retweet,mi-road,mi-rocket,mi-rotate-left,mi-rotate-right,mi-rss,mi-rss-square,mi-ruble,mi-rupee,mi-safari,mi-save,mi-search,mi-search-minus,mi-search-plus,mi-sellsy,mi-send,mi-send-o,mi-server,mi-share,mi-share-alt,mi-share-alt-square,mi-sheqel,mi-shield,mi-ship,mi-shirtsinbulk,mi-shopping-cart,mi-signal,mi-sign-in,mi-sign-out,mi-simplybuilt,mi-sitemap,mi-skyatlas,mi-skype,mi-slack,mi-sliders,mi-slideshare,mi-smile-o,mi-sort,mi-sort-alpha-asc,mi-sort-alpha-desc,mi-sort-amount-asc,mi-sort-amount-desc,mi-sort-asc,mi-sort-desc,mi-sort-numeric-asc,mi-sort-numeric-desc,mi-soundcloud,mi-space-shuttle,mi-spinner,mi-spoon,mi-spotify,mi-square,mi-stack-exchange,mi-stack-overflow,mi-star,mi-star-half,mi-star-half-full,mi-star-o,mi-steam,mi-steam-square,mi-step-backward,mi-step-forward,mi-stethoscope,mi-sticky-note,mi-sticky-note-o,mi-stop,mi-street-view,mi-strikethrough,mi-stumbleupon,mi-subscript,mi-subway,mi-suitcase,mi-sun-o,mi-superscript,mi-support,mi-table,mi-tablet,mi-tag,mi-tags,mi-tasks,mi-taxi,mi-tencent-weibo,mi-terminal,mi-text-height,mi-text-width,mi-th,mi-th-list,mi-thumbs-down,mi-thumbs-o-down,mi-thumbs-o-up,mi-thumbs-up,mi-thumb-tack,mi-ticket,mi-times,mi-times-circle,mi-times-circle-o,mi-tint,mi-toggle-down,mi-toggle-left,mi-toggle-off,mi-toggle-on,mi-toggle-right,mi-toggle-up,mi-trademark,mi-train,mi-transgender,mi-transgender-alt,mi-trash,mi-tree,mi-trello,mi-tripadvisor,mi-trophy,mi-truck,mi-tty,mi-tumblr,mi-tumblr-square,mi-turkish-lira,mi-tv,mi-twitch,mi-twitter,mi-umbrella,mi-underline,mi-unlink,mi-unlock-alt,mi-upload,mi-user,mi-user-md,mi-user-plus,mi-users,mi-user-secret,mi-user-times,mi-venus,mi-venus-double,mi-venus-mars,mi-viacoin,mi-video-camera,mi-vimeo,mi-vine,mi-vk,mi-volume-down,mi-volume-off,mi-volume-up,mi-warning,mi-wechat,mi-weibo,mi-whatsapp,mi-wheelchair,mi-wifi,mi-wikipedia-w,mi-windows,mi-won,mi-wordpress,mi-wrench,mi-xing,mi-xing-square,mi-yahoo,mi-y-combinator,mi-yelp,mi-yen,mi-youtube,mi-youtube-play">

<cffunction name="init" output="false">
	<cfargument name="configBean">

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
	<cfreturn this />
</cffunction>

<cffunction name="getIconClasses" output="false">
	<cfreturn variables.iconsclasses>
</cffunction>

<cffunction name="getExtendSetBean">
	<cfset var extendSetBean=createObject("component","mura.extend.extendSet").init(variables.configBean,getContentRenderer()) />
	<cfset extendSetBean.setSubTypeID(getSubTypeID()) />
	<cfset extendSetBean.setSiteID(getSiteID()) />
	<cfreturn extendSetBean />
</cffunction>

<cffunction name="getRelatedContentSetBean">
	<cfset var rcsBean = getBean('relatedContentSet') />
	<cfset rcsBean.setSubTypeID(getSubTypeID()) />
	<cfset rcsBean.setSiteID(getSiteID()) />
	<cfreturn rcsBean />
</cffunction>

<cffunction name="load">
	<cfset var rs=""/>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select subtypeid,siteID,baseTable,baseKeyField,dataTable,type,subtype,
		isActive,notes,lastUpdate,dateCreated,lastUpdateBy,hasSummary,hasBody,description,availableSubTypes,iconclass,hasassocfile,hasConfigurator,adminonly
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

<cffunction name="set" output="false">
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
			<cfset setAdminOnly(arguments.data.adminOnly)/>

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

<cffunction name="validate" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getSiteID" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getSubTypeID" output="false">
	<cfif not len(variables.instance.SubTypeID)>
		<cfset variables.instance.SubTypeID = createUUID() />
	</cfif>
	<cfreturn variables.instance.SubTypeID />
</cffunction>

<cffunction name="setSubTypeID" output="false">
	<cfargument name="SubTypeID" type="String" />
	<cfset variables.instance.SubTypeID = trim(arguments.SubTypeID) />
	<cfreturn this>
</cffunction>

<cffunction name="getType" output="false">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="setType" output="false">
	<cfargument name="Type" type="String" />
	<cfif arguments.type eq 'Portal'>
		<cfset arguments.type='Folder'>
	</cfif>
	<cfset variables.instance.Type = trim(arguments.Type) />
	<cfreturn this>
</cffunction>

<cffunction name="getSubType" output="false">
	<cfreturn variables.instance.SubType />
</cffunction>

<cffunction name="setSubType" output="false">
	<cfargument name="SubType" type="String" />
	<cfset variables.instance.SubType = trim(arguments.SubType) />
	<cfreturn this>
</cffunction>

<cffunction name="getDataTable" output="false">
	<cfreturn variables.instance.DataTable />
</cffunction>

<cffunction name="setDataTable" output="false">
	<cfargument name="DataTable" type="String" />
	<cfif len(trim(arguments.dataTable))>
		<cfset variables.instance.DataTable = trim(arguments.DataTable) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getBaseTable" output="false">
	<cfreturn variables.instance.BaseTable />
</cffunction>

<cffunction name="setBaseTable" output="false">
	<cfargument name="BaseTable" type="String" />
	<cfif len(trim(arguments.BaseTable))>
		<cfset variables.instance.BaseTable = trim(arguments.BaseTable) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getbaseKeyField" output="false">
	<cfreturn variables.instance.baseKeyField />
</cffunction>

<cffunction name="setbaseKeyField" output="false">
	<cfargument name="baseKeyField" type="String" />
	<cfif len(trim(arguments.baseKeyField))>
		<cfset variables.instance.baseKeyField = trim(arguments.baseKeyField) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIsActive" output="false">
	<cfreturn variables.instance.IsActive />
</cffunction>

<cffunction name="setIsActive" output="false">
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

<cffunction name="getHasSummary" output="false">
	<cfreturn variables.instance.hasSummary />
</cffunction>

<cffunction name="setHasSummary" output="false">
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

<cffunction name="getHasBody" output="false">
	<cfreturn variables.instance.hasBody />
</cffunction>

<cffunction name="setHasBody" output="false">
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

<cffunction name="getHasAssocFile" output="false">
	<cfreturn variables.instance.HasAssocFile />
</cffunction>

<cffunction name="setHasAssocFile" output="false">
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

<cffunction name="getHasConfigurator" output="false">
	<cfif listFindNoCase("Folder,Gallery,Calendar",getType())>
		<cfreturn variables.instance.HasConfigurator />
	<cfelse>
		<cfreturn 0 />
	</cfif>

</cffunction>

<cffunction name="setHasConfigurator" output="false">
	<cfargument name="HasConfigurator"/>
	<cfif isNumeric(arguments.HasConfigurator)>
		<cfset variables.instance.HasConfigurator = arguments.HasConfigurator />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDescription" output="false">
	<cfreturn variables.instance.description />
</cffunction>

<cffunction name="setDescription" output="false">
	<cfargument name="description" type="String" />
	<cfset variables.instance.description = trim(arguments.description) />
	<cfreturn this>
</cffunction>

<cffunction name="getAdminOnly" output="false">
	<cfreturn variables.instance.adminonly />
</cffunction>

<cffunction name="setAdminOnly" output="false">
	<cfargument name="adminonly" />
	<cfif isNumeric(arguments.adminonly)>
	<cfset variables.instance.adminonly = arguments.adminonly />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIconClass" output="false">
	<cfargument name="includeDefault" default="false">
	<cfset var returnVar = variables.instance.iconclass>

	<cfif not len(returnVar) and includeDefault>
		<cfset returnVar=getDefaultIconClass()>
	</cfif>

	<cfreturn returnVar>
</cffunction>

<cffunction name="getDefaultIconClass" output="false">
	<cfset var returnVar="">

	<cfswitch expression="#getType()#">
		<cfcase value="page">
			<cfset returnVar = "mi-file">
		</cfcase>
		<cfcase value="folder">
			<cfset returnVar = "mi-folder-open-o">
		</cfcase>
		<cfcase value="file">
			<cfset returnVar = "mi-file-text-o">
		</cfcase>
		<cfcase value="link">
			<cfset returnVar = "mi-link">
		</cfcase>
		<cfcase value="calendar">
			<cfset returnVar = "mi-calendar">
		</cfcase>
		<cfcase value="gallery">
			<cfset returnVar = "mi-th">
		</cfcase>
		<cfcase value="1">
			<cfset returnVar = "mi-group">
		</cfcase>
		<cfcase value="2">
			<cfset returnVar = "mi-user">
		</cfcase>
		<cfdefaultcase>
			<cfset returnVar = "mi-cog">
		</cfdefaultcase>
	</cfswitch>

	<cfreturn returnVar>
</cffunction>

<cffunction name="setIconClass" output="false">
	<cfargument name="iconclass" type="String" />
	<cfif len(arguments.iconclass)>
		<cfset variables.instance.iconclass = replace(trim(arguments.iconclass),'icon-','mi-') />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAvailableSubTypes" output="false">
	<cfreturn variables.instance.availableSubTypes />
</cffunction>

<cffunction name="setAvailableSubTypes" output="false">
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

<cffunction name="exists" output="false">
	<cfreturn not variables.instance.isNew>
</cffunction>

<cffunction name="getExtendSets" returntype="array">
<cfargument name="Inherit" required="true" default="false"/>
<cfargument name="doFilter" required="true" default="false"/>
<cfargument name="filter" required="true" default=""/>
<cfargument name="container" required="true" default=""/>
<cfargument name="activeOnly" required="true" default="false"/>
<cfargument name="useCache" default=false>

	<cfset var rs=""/>
	<cfset var tempArray=""/>
	<cfset var extendSet=""/>
	<cfset var extendArray=arrayNew(1) />
	<cfset var rsSets=""/>
	<cfset var extendSetBean=""/>
	<cfset var s=0/>

	<cfif arguments.useCache and isArray(variables.extendsetArray)>
		<cfreturn variables.extendsetArray />
	<cfelse>
		<cfset rsSets=getSetsQuery(arguments.inherit,arguments.doFilter,arguments.filter,arguments.container,arguments.activeOnly)/>

		<cfif rsSets.recordcount>
			<cfset tempArray=createObject("component","mura.queryTool").init(rsSets).toArray() />

			<cfloop from="1" to="#rsSets.recordcount#" index="s">

				<cfset extendSetBean=getExtendSetBean() />
				<cfset extendSetBean.set(tempArray[s]) />
				<cfset extendSetBean.setIsNew(0) />
				<cfset arrayAppend(extendArray,extendSetBean)/>
			</cfloop>

		</cfif>

		<cfif arguments.useCache>
			<cfset variables.extendsetArray=extendArray>
		</cfif>

		<cfreturn extendArray/>
	</cfif>

</cffunction>

<cffunction name="getRelatedContentSets" returntype="array">
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

	<cfloop from="1" to="#arrayLen(relatedContentSetArray)#" index="s">
		<cfset relatedContentSetArray[s].setIsNew(0)>
	</cfloop>

	<cfreturn relatedContentSetArray />
</cffunction>

<cffunction name="save"  output="false">
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
		hasConfigurator=#getHasConfigurator()#,
		adminOnly=#getAdminOnly()#
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
		Insert into tclassextend (subTypeID,siteID,type,subType,baseTable,baseKeyField,dataTable,isActive,hasSummary,hasBody,description,availableSubTypes,iconclass,hasAssocFile,hasConfigurator,adminonly)
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
		#getHasConfigurator()#,
		#getAdminOnly()#
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

<cffunction name="getExtendSetByName" output="false">
<cfargument name="name">
<cfargument name="useCache" default=false>

<cfset var extendSets=getExtendSets(useCache=arguments.useCache)/>
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

<cffunction name="delete">
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

<cffunction name="loadSet">
<cfargument name="ExtendSetID">
<cfset var extendSetBean=getExtendSetBean() />

	<cfset extendSetBean.setExtendSetID(arguments.ExtendSetID)/>
	<cfset extendSetBean.load()/>
	<cfreturn extendSetBean/>

</cffunction>

<cffunction name="addExtendSet" output="false">
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

<cffunction name="deleteSet">
<cfargument name="ExtendSetID">
<cfset var extendSetBean=getExtendSetBean() />

			<cfset extendSetBean.setExtendSetID(ExtendSetID) />
			<cfset extendSetBean.delete() />
</cffunction>

<cffunction name="getSetsQuery">
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

<cffunction name="getTypeAsString">

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
		<cfif structKeyExists(request,"servletEvent") and request.servletEvent.getValue('siteid') eq getSiteID()>
			<cfset variables.contentRenderer=request.servletEvent.getContentRenderer()>
		<cfelseif structKeyExists(request,"event") and request.event.getValue('siteid') eq getSiteID()>
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
	<cfset var extendSetBean = "" />
	<cfset var relatedSetBean = "" />
	<cfset var set = "" />
	<cfset var extendsets = getExtendSets() />
	<cfset var relatecontentsets = getRelatedContentSets(false) />
	<cfset var setStruct = {} />
	<cfset var item = "" />
	<cfset var i = 0 />
	<cfset var xmlRoot = XmlElemNew( documentXML, "", "extension" ) />

	<cfset var xmlAttributeSet = "" />
	<cfset var xmlRelatedContentSet = "" />

	<cfset extensionData = duplicate(variables.instance) />
	<cfset structDelete(extensionData,"sets") />
	<cfset structDelete(extensionData,"errors") />

	<cfif not(arguments.includeIDs)>
		<cfset structDelete(extensionData,"SubTypeID") />
	</cfif>
	<cfset structDelete(extensionData,"isNew") />
	<cfset structDelete(extensionData,"isActive") />
	<cfset structDelete(extensionData,"siteid") />
	<cfset structDelete(extensionData,"fromMuraCache") />

	<cfloop collection="#extensionData#" item="item">
		<cfif isSimpleValue(extensionData[item])>
			<cfset xmlRoot.XmlAttributes[lcase(item)] = extensionData[item] />
		</cfif>
	</cfloop>

	<cfloop from="1" to="#ArrayLen(extendsets)#" index="i">
		<cfset extendSetBean = loadSet(extendsets[i].getExtendSetID()) />
		<cfset xmlAttributeSet = extendSetBean.getAsXML(documentXML) />
		<cfset ArrayAppend(
			xmlRoot.XmlChildren,
			xmlAttributeSet
			) />
	</cfloop>

	<cfloop from="1" to="#ArrayLen(relatecontentsets)#" index="i">
		<cfset relatedSetBean = relatecontentsets[i]/>
		<cfset xmlRelatedContentSet = relatedSetBean.getAsXML(documentXML) />
		<cfset ArrayAppend(
			xmlRoot.XmlChildren,
			xmlRelatedContentSet
			) />
	</cfloop>

	<cfreturn xmlRoot />
</cffunction>


</cfcomponent>
