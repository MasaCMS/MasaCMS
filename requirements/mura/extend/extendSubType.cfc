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
<cfset variables.instance.adminonly=0/>
<cfset variables.instance.errors=structnew() />
<cfset variables.contentRenderer="" />

<cfset variables.iconsclasses="mi-inverse,mi-glass,mi-music,mi-search,mi-envelope-o,mi-heart,mi-star,mi-star-o,mi-user,mi-film,mi-th-large,mi-th,mi-th-list,mi-check,mi-remove,mi-close,mi-times,mi-search-plus,mi-search-minus,mi-power-off,mi-signal,mi-gear,mi-cog,mi-trash-o,mi-home,mi-file-o,mi-clock-o,mi-road,mi-download,mi-arrow-circle-o-down,mi-arrow-circle-o-up,mi-inbox,mi-play-circle-o,mi-rotate-right,mi-repeat,mi-refresh,mi-list-alt,mi-lock,mi-flag,mi-headphones,mi-volume-off,mi-volume-down,mi-volume-up,mi-qrcode,mi-barcode,mi-tag,mi-tags,mi-book,mi-bookmark,mi-print,mi-camera,mi-font,mi-bold,mi-italic,mi-text-height,mi-text-width,mi-align-left,mi-align-center,mi-align-right,mi-align-justify,mi-list,mi-dedent,mi-outdent,mi-indent,mi-video-camera,mi-photo,mi-image,mi-picture-o,mi-pencil,mi-map-marker,mi-adjust,mi-tint,mi-edit,mi-pencil-square-o,mi-share-square-o,mi-check-square-o,mi-arrows,mi-step-backward,mi-fast-backward,mi-backward,mi-play,mi-pause,mi-stop,mi-forward,mi-fast-forward,mi-step-forward,mi-eject,mi-chevron-left,mi-chevron-right,mi-plus-circle,mi-minus-circle,mi-times-circle,mi-check-circle,mi-question-circle,mi-info-circle,mi-crosshairs,mi-times-circle-o,mi-check-circle-o,mi-ban,mi-arrow-left,mi-arrow-right,mi-arrow-up,mi-arrow-down,mi-mail-forward,mi-share,mi-expand,mi-compress,mi-plus,mi-minus,mi-asterisk,mi-exclamation-circle,mi-gift,mi-leaf,mi-fire,mi-eye,mi-eye-slash,mi-warning,mi-exclamation-triangle,mi-plane,mi-calendar,mi-random,mi-comment,mi-magnet,mi-chevron-up,mi-chevron-down,mi-retweet,mi-shopping-cart,mi-folder,mi-folder-open,mi-arrows-v,mi-arrows-h,mi-bar-chart-o,mi-bar-chart,mi-twitter-square,mi-facebook-square,mi-camera-retro,mi-key,mi-gears,mi-cogs,mi-comments,mi-thumbs-o-up,mi-thumbs-o-down,mi-star-half,mi-heart-o,mi-sign-out,mi-linkedin-square,mi-thumb-tack,mi-external-link,mi-sign-in,mi-trophy,mi-github-square,mi-upload,mi-lemon-o,mi-phone,mi-square-o,mi-bookmark-o,mi-phone-square,mi-twitter,mi-facebook-f,mi-facebook,mi-github,mi-unlock,mi-credit-card,mi-feed,mi-rss,mi-hdd-o,mi-bullhorn,mi-bell,mi-certificate,mi-hand-o-right,mi-hand-o-left,mi-hand-o-up,mi-hand-o-down,mi-arrow-circle-left,mi-arrow-circle-right,mi-arrow-circle-up,mi-arrow-circle-down,mi-globe,mi-wrench,mi-tasks,mi-filter,mi-briefcase,mi-arrows-alt,mi-group,mi-users,mi-chain,mi-link,mi-cloud,mi-flask,mi-cut,mi-scissors,mi-copy,mi-files-o,mi-paperclip,mi-save,mi-floppy-o,mi-square,mi-navicon,mi-reorder,mi-bars,mi-list-ul,mi-list-ol,mi-strikethrough,mi-underline,mi-table,mi-magic,mi-truck,mi-pinterest,mi-pinterest-square,mi-google-plus-square,mi-google-plus,mi-money,mi-caret-down,mi-caret-up,mi-caret-left,mi-caret-right,mi-columns,mi-unsorted,mi-sort,mi-sort-down,mi-sort-desc,mi-sort-up,mi-sort-asc,mi-envelope,mi-linkedin,mi-rotate-left,mi-undo,mi-legal,mi-gavel,mi-dashboard,mi-tachometer,mi-comment-o,mi-comments-o,mi-flash,mi-bolt,mi-sitemap,mi-umbrella,mi-paste,mi-clipboard,mi-lightbulb-o,mi-exchange,mi-cloud-download,mi-cloud-upload,mi-user-md,mi-stethoscope,mi-suitcase,mi-bell-o,mi-coffee,mi-cutlery,mi-file-text-o,mi-building-o,mi-hospital-o,mi-ambulance,mi-medkit,mi-fighter-jet,mi-beer,mi-h-square,mi-plus-square,mi-angle-double-left,mi-angle-double-right,mi-angle-double-up,mi-angle-double-down,mi-angle-left,mi-angle-right,mi-angle-up,mi-angle-down,mi-desktop,mi-laptop,mi-tablet,mi-mobile-phone,mi-mobile,mi-circle-o,mi-quote-left,mi-quote-right,mi-spinner,mi-circle,mi-mail-reply,mi-reply,mi-github-alt,mi-folder-o,mi-folder-open-o,mi-smile-o,mi-frown-o,mi-meh-o,mi-gamepad,mi-keyboard-o,mi-flag-o,mi-flag-checkered,mi-terminal,mi-code,mi-mail-reply-all,mi-reply-all,mi-star-half-empty,mi-star-half-full,mi-star-half-o,mi-location-arrow,mi-crop,mi-code-fork,mi-unlink,mi-chain-broken,mi-question,mi-info,mi-exclamation,mi-superscript,mi-subscript,mi-eraser,mi-puzzle-piece,mi-microphone,mi-microphone-slash,mi-shield,mi-calendar-o,mi-fire-extinguisher,mi-rocket,mi-maxcdn,mi-chevron-circle-left,mi-chevron-circle-right,mi-chevron-circle-up,mi-chevron-circle-down,mi-html5,mi-css3,mi-anchor,mi-unlock-alt,mi-bullseye,mi-ellipsis-h,mi-ellipsis-v,mi-rss-square,mi-play-circle,mi-ticket,mi-minus-square,mi-minus-square-o,mi-level-up,mi-level-down,mi-check-square,mi-pencil-square,mi-external-link-square,mi-share-square,mi-compass,mi-toggle-down,mi-caret-square-o-down,mi-toggle-up,mi-caret-square-o-up,mi-toggle-right,mi-caret-square-o-right,mi-euro,mi-eur,mi-gbp,mi-dollar,mi-usd,mi-rupee,mi-inr,mi-cny,mi-rmb,mi-yen,mi-jpy,mi-ruble,mi-rouble,mi-rub,mi-won,mi-krw,mi-bitcoin,mi-btc,mi-file,mi-file-text,mi-sort-alpha-asc,mi-sort-alpha-desc,mi-sort-amount-asc,mi-sort-amount-desc,mi-sort-numeric-asc,mi-sort-numeric-desc,mi-thumbs-up,mi-thumbs-down,mi-youtube-square,mi-youtube,mi-xing,mi-xing-square,mi-youtube-play,mi-dropbox,mi-stack-overflow,mi-instagram,mi-flickr,mi-adn,mi-bitbucket,mi-bitbucket-square,mi-tumblr,mi-tumblr-square,mi-long-arrow-down,mi-long-arrow-up,mi-long-arrow-left,mi-long-arrow-right,mi-apple,mi-windows,mi-android,mi-linux,mi-dribbble,mi-skype,mi-foursquare,mi-trello,mi-female,mi-male,mi-gittip,mi-gratipay,mi-sun-o,mi-moon-o,mi-archive,mi-bug,mi-vk,mi-weibo,mi-renren,mi-pagelines,mi-stack-exchange,mi-arrow-circle-o-right,mi-arrow-circle-o-left,mi-toggle-left,mi-caret-square-o-left,mi-dot-circle-o,mi-wheelchair,mi-vimeo-square,mi-turkish-lira,mi-try,mi-plus-square-o,mi-space-shuttle,mi-slack,mi-envelope-square,mi-wordpress,mi-openid,mi-institution,mi-bank,mi-university,mi-mortar-board,mi-graduation-cap,mi-yahoo,mi-google,mi-reddit,mi-reddit-square,mi-stumbleupon-circle,mi-stumbleupon,mi-delicious,mi-digg,mi-pied-piper,mi-pied-piper-alt,mi-drupal,mi-joomla,mi-language,mi-fax,mi-building,mi-child,mi-paw,mi-spoon,mi-cube,mi-cubes,mi-behance,mi-behance-square,mi-steam,mi-steam-square,mi-recycle,mi-automobile,mi-car,mi-cab,mi-taxi,mi-tree,mi-spotify,mi-deviantart,mi-soundcloud,mi-database,mi-file-pdf-o,mi-file-word-o,mi-file-excel-o,mi-file-powerpoint-o,mi-file-photo-o,mi-file-picture-o,mi-file-image-o,mi-file-zip-o,mi-file-archive-o,mi-file-sound-o,mi-file-audio-o,mi-file-movie-o,mi-file-video-o,mi-file-code-o,mi-vine,mi-codepen,mi-jsfiddle,mi-life-bouy,mi-life-buoy,mi-life-saver,mi-support,mi-life-ring,mi-circle-o-notch,mi-ra,mi-rebel,mi-ge,mi-empire,mi-git-square,mi-git,mi-y-combinator-square,mi-yc-square,mi-hacker-news,mi-tencent-weibo,mi-qq,mi-wechat,mi-weixin,mi-send,mi-paper-plane,mi-send-o,mi-paper-plane-o,mi-history,mi-circle-thin,mi-header,mi-paragraph,mi-sliders,mi-share-alt,mi-share-alt-square,mi-bomb,mi-soccer-ball-o,mi-futbol-o,mi-tty,mi-binoculars,mi-plug,mi-slideshare,mi-twitch,mi-yelp,mi-newspaper-o,mi-wifi,mi-calculator,mi-paypal,mi-google-wallet,mi-cc-visa,mi-cc-mastercard,mi-cc-discover,mi-cc-amex,mi-cc-paypal,mi-cc-stripe,mi-bell-slash,mi-bell-slash-o,mi-trash,mi-copyright,mi-at,mi-eyedropper,mi-paint-brush,mi-birthday-cake,mi-area-chart,mi-pie-chart,mi-line-chart,mi-lastfm,mi-lastfm-square,mi-toggle-off,mi-toggle-on,mi-bicycle,mi-bus,mi-ioxhost,mi-angellist,mi-cc,mi-shekel,mi-sheqel,mi-ils,mi-meanpath,mi-buysellads,mi-connectdevelop,mi-dashcube,mi-forumbee,mi-leanpub,mi-sellsy,mi-shirtsinbulk,mi-simplybuilt,mi-skyatlas,mi-cart-plus,mi-cart-arrow-down,mi-diamond,mi-ship,mi-user-secret,mi-motorcycle,mi-street-view,mi-heartbeat,mi-venus,mi-mars,mi-mercury,mi-intersex,mi-transgender,mi-transgender-alt,mi-venus-double,mi-mars-double,mi-venus-mars,mi-mars-stroke,mi-mars-stroke-v,mi-mars-stroke-h,mi-neuter,mi-genderless,mi-facebook-official,mi-pinterest-p,mi-whatsapp,mi-server,mi-user-plus,mi-user-times,mi-hotel,mi-bed,mi-viacoin,mi-train,mi-subway,mi-medium,mi-yc,mi-y-combinator,mi-optin-monster,mi-opencart,mi-expeditedssl,mi-battery-4,mi-battery-full,mi-battery-3,mi-battery-three-quarters,mi-battery-2,mi-battery-half,mi-battery-1,mi-battery-quarter,mi-battery-0,mi-battery-empty,mi-mouse-pointer,mi-i-cursor,mi-object-group,mi-object-ungroup,mi-sticky-note,mi-sticky-note-o,mi-cc-jcb,mi-cc-diners-club,mi-clone,mi-balance-scale,mi-hourglass-o,mi-hourglass-1,mi-hourglass-start,mi-hourglass-2,mi-hourglass-half,mi-hourglass-3,mi-hourglass-end,mi-hourglass,mi-hand-grab-o,mi-hand-rock-o,mi-hand-stop-o,mi-hand-paper-o,mi-hand-scissors-o,mi-hand-lizard-o,mi-hand-spock-o,mi-hand-pointer-o,mi-hand-peace-o,mi-trademark,mi-registered,mi-creative-commons,mi-gg,mi-gg-circle,mi-tripadvisor,mi-odnoklassniki,mi-odnoklassniki-square,mi-get-pocket,mi-wikipedia-w,mi-safari,mi-chrome,mi-firefox,mi-opera,mi-internet-explorer,mi-tv,mi-television,mi-contao,mi-500px,mi-amazon,mi-calendar-plus-o,mi-calendar-minus-o,mi-calendar-times-o,mi-calendar-check-o,mi-industry,mi-map-pin,mi-map-signs,mi-map-o,mi-map,mi-commenting,mi-commenting-o,mi-houzz,mi-vimeo,mi-black-tie,mi-fonticons ">

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

<cffunction name="getAdminOnly" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.adminonly />
</cffunction>

<cffunction name="setAdminOnly" access="public" output="false">
	<cfargument name="adminonly" />
	<cfif isNumeric(arguments.adminonly)>
	<cfset variables.instance.adminonly = arguments.adminonly />
	</cfif>
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

<cffunction name="setIconClass" access="public" output="false">
	<cfargument name="iconclass" type="String" />
	<cfif len(arguments.iconclass)>
		<cfset variables.instance.iconclass = replace(trim(arguments.iconclass),'icon-','mi-') />
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

	<cfloop from="1" to="#arrayLen(relatedContentSetArray)#" index="s">
		<cfset relatedContentSetArray[s].setIsNew(0)>
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
		<cfset extendSetBean = loadSet(sets[i].getExtendSetID()) />
		<cfset xmlAttributeSet = extendSetBean.getAsXML(documentXML) />
		<cfset ArrayAppend(
			xmlRoot.XmlChildren,
			xmlAttributeSet
			) />

	</cfloop>

	<cfreturn xmlRoot />
</cffunction>


</cfcomponent>
