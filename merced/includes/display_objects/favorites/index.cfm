<cfparam name="request.favoriteaction" default="">
<cfparam name="request.favoriteID" default="">
<cfsilent>
<cfparam name="request.userID" default="">
<cfparam name="$.event('siteID')" default="">
<cfparam name="request.favoriteName" default="">
<cfparam name="request.favorite" default="">
<cfparam name="request.favoritetype" default="">
<cfparam name="request.usertools" default="false">
<cfset $.loadShadowBoxJS() />
<cfset rbFactory=getSite().getRBFactory()/>
<cfswitch expression="#$.getJsLib()#">
	<cfcase value="jquery">
		<cfset $.addToHTMLHeadQueue("favorites/htmlhead/favorites-jquery.cfm")>
	</cfcase>
	<cfdefaultcase>
		<cfset $.addToHTMLHeadQueue("favorites/htmlhead/favorites-prototype.cfm")>
	</cfdefaultcase>
</cfswitch>

<cfset currentPageFavoriteID = "">
</cfsilent>
<cfoutput>
<div id="svFavoritesList">
	<#$.getHeaderTag('subHead1')#>#$.rbKey('favorites.favorites')#</#$.getHeaderTag('subHead1')#>
<cfif len(getPersonalizationID())>
	<!--- list the favorites --->
	<cfset rsFavorites = application.favoriteManager.getInternalContentFavorites(getPersonalizationID(), $.event('siteID')) />
	<ul id="favoriteList">
	<cfif rsFavorites.recordCount>
		<!---<#$.getHeaderTag('subHead1')#>Favorites</#$.getHeaderTag('subHead1')#>--->
		<cfloop query="rsFavorites" startrow="1" endrow="5">
			<cfif $.content('contentID') eq rsFavorites.contentid>
				<cfset currentPageFavoriteID = favoriteID>
			</cfif>
			<cfset contentLink = "" />
			<cfset lid = replace(rsFavorites.favoriteID, "-", "", "ALL") />
			<cfset contentLink = createHref(rsFavorites.Type, rsFavorites.filename, $.event('siteID'), rsFavorites.contentID, rsFavorites.target,rsFavorites.targetParams, '', '#$.globalConfig('context')#', '#$.globalConfig('stub')#', '', 'false') />
			<cfset contentLink = "<a href='#contentLink#'>#HTMLEditFormat(rsFavorites.menutitle)#</a>" />
			<li id="favorite#lid#"><a href="" onclick="return deleteFavorite('#favoriteID#', 'favorite#lid#');" title="#xmlformat($.rbKey('favorites.removefromfavorites'))#" class="remove">[-]</a> #contentLink#</li>
		</cfloop>
		<cfif rsFavorites.recordCount gt 5>
			<li><a href="" onclick="return effectFunction();"><span>#$.rbKey('favorites.morefavorites')#</span></a>
				<ul id="favoriteListMore" style="display:none">
				<cfloop query="rsFavorites" startrow="6">
					<cfif $.content('contentID') eq rsFavorites.contentid>
						<cfset currentPageFavoriteID = favoriteID>
					</cfif>
					<cfset contentLink = "" />
					<cfset lid = replace(rsFavorites.favoriteID, "-", "", "ALL") />
				
					<cfset contentLink = createHref(rsFavorites.Type, rsFavorites.filename, $.event('siteID'), rsFavorites.contentID, rsFavorites.target,rsFavorites.targetParams, '', '#$.globalConfig('context')#', '#$.globalConfig('stub')#', '', 'false') />
					<cfset contentLink = "<a href='#contentLink#'>#HTMLEditFormat(rsFavorites.menuTitle)#</a>" />
					<li id="favorite#lid#"><a href="" onclick="return deleteFavorite('#rsFavorites.favoriteID#', 'favorite#lid#');" title="#xmlformat($.rbKey('favorites.removefromfavorites'))#" class="remove">[-]</a> #contentLink#</li>
				</cfloop>
				</ul>
			</li>
		</cfif>
		<li id="favoriteTip" class="defaultMsg" style="display:none;">#$.rbKey('favorites.nofavorites')#</li>
	<cfelse>
		<li id="favoriteTip" class="defaultMsg">#$.rbKey('favorites.nofavorites')#</li>	</cfif>
	</ul>
	
	<!--- add favorites --->
	<cfset userID = getPersonalizationID() />
	<cfset menuTitle = $.content('menuTitle') />
	<cfset contentID = $.content('contentID') />
	<cfset favoriteType = 'internal_content' />
	<cfset favoriteExists = application.favoriteManager.checkForFavorite(userID, contentID) />
<!---	
	<cfif favoriteExists>
		<span id="favoriteStatus" style="display:none"><a href="" onclick="return saveFavorite('#userID#', '#siteID#', '#menuTitle#', '#contentID#', '#favoriteType#')">Add to favorites</a></span>
	<cfelse>
		<span id="favoriteStatus"><a href="" onclick="return saveFavorite('#userID#', '#siteID#', '#menuTitle#', '#contentID#', '#favoriteType#')">Add to favorites</a></span>
	</cfif>
--->	
	<script type="text/javascript">
		currentPageFavoriteID = '#currentPageFavoriteID#';
	</script>
<cfelse>
	<p class="loginMessage">#rbFactory.getResourceBundle().messageFormat($.rbKey('favorites.pleaselogin'),'#application.settingsManager.getSite($.event('siteID')).getLoginURL()#&returnURL=#getCurrentURL()#')#</p>
</cfif>
</div>
<cfif len(getPersonalizationID())>
<div id="svPageTools">
	<#$.getHeaderTag('subHead1')#>#$.rbKey('favorites.pagetools')#</#$.getHeaderTag('subHead1')#>
	<cfif favoriteExists>
		<cfset favoriteExistsStyle = "display:none;">
		<cfset addFavoriteStyle = "display:none;">
		<script type="text/javascript">
			favoriteExists = true;
		</script>
	<cfelse>
		<cfset favoriteExistsStyle = "display:none;">
		<cfset addFavoriteStyle = "">
	</cfif>
	<ul>
		<li id="favoriteExists" style="#favoriteExistsStyle#"><a href="" onclick="return false;">Stored in favorites</a></li>
		<li id="addFavorite" style="#addFavoriteStyle#"><a href="" onclick="return saveFavorite('#userID#', '#siteID#', '#JSStringFormat(menuTitle)#', '#contentID#', '#favoriteType#')">#$.rbKey('favorites.addtofavorites')#</a></li>
		<li id="sendToFriend"><a rel="shadowbox;width=600;height=500" href="http://#application.settingsManager.getSite($.event('siteID')).getDomain()##application.configBean.getServerPort()##$.globalConfig('context')#/#getSite().getDisplayPoolID()#/includes/display_objects/sendtofriend/index.cfm?link=#URLEncodedFormat(getCurrentURL())#&siteid=#$.event('siteID')#">#rbFactory.getResourceBundle().messageFormat($.rbKey('favorites.emailthis'),$.rbKey('sitemanager.content.type.#$.content('type')#'))#</a> </li>
		<li id="print"><a href="javascript:window.print();void(0);">#rbFactory.getResourceBundle().messageFormat($.rbKey('favorites.printthis'),$.rbKey('sitemanager.content.type.#$.content('type')#'))#</a></li>
		<!---<li id="discuss"><a href="/forum">Discuss #contentTypeString#</a></li>--->
	</ul>
</div>
</cfif>
</cfoutput>



