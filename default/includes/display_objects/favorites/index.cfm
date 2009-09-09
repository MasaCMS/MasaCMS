<cfparam name="request.favoriteaction" default="">
<cfparam name="request.favoriteID" default="">
<cfsilent>
<cfparam name="request.userID" default="">
<cfparam name="request.siteID" default="">
<cfparam name="request.favoriteName" default="">
<cfparam name="request.favorite" default="">
<cfparam name="request.favoritetype" default="">
<cfparam name="request.usertools" default="false">
<cfset loadShadowBoxJS() />
<cfset rbFactory=getSite().getRBFactory()/>
<cfswitch expression="#getJsLib()#">
	<cfcase value="jquery">
		<cfset addToHTMLHeadQueue("favorites/htmlhead/favorites-jquery.cfm")>
	</cfcase>
	<cfdefaultcase>
		<cfset addToHTMLHeadQueue("favorites/htmlhead/favorites-prototype.cfm")>
	</cfdefaultcase>
</cfswitch>

<cfset currentPageFavoriteID = "">
</cfsilent>
<cfoutput>
<div id="svFavoritesList">
	<#getHeaderTag('subHead1')#>#rbFactory.getKey('favorites.favorites')#</#getHeaderTag('subHead1')#>
<cfif len(getPersonalizationID())>
	<!--- list the favorites --->
	<cfset rsFavorites = application.favoriteManager.getInternalContentFavorites(getPersonalizationID(), request.siteid) />
	<ul id="favoriteList">
	<cfif rsFavorites.recordCount>
		<!---<#getHeaderTag('subHead1')#>Favorites</#getHeaderTag('subHead1')#>--->
		<cfloop query="rsFavorites" startrow="1" endrow="5">
			<cfif request.contentBean.getContentID() eq rsFavorites.contentid>
				<cfset currentPageFavoriteID = favoriteID>
			</cfif>
			<cfset contentLink = "" />
			<cfset lid = replace(rsFavorites.favoriteID, "-", "", "ALL") />
			<cfset contentLink = createHref(rsFavorites.Type, rsFavorites.filename, request.siteid, rsFavorites.contentID, rsFavorites.target,rsFavorites.targetParams, '', '#application.configBean.getContext()#', '#application.configBean.getStub()#', '#application.configBean.getIndexFile()#', 'false') />
			<cfset contentLink = "<a href='#contentLink#'>#HTMLEditFormat(rsFavorites.menutitle)#</a>" />
			<li id="favorite#lid#"><a href="#application.configBean.getIndexFile()#" onClick="return deleteFavorite('#favoriteID#', 'favorite#lid#');" title="#xmlformat(rbFactory.getKey('favorites.removefromfavorites'))#" class="remove">[-]</a> #contentLink#</li>
		</cfloop>
		<cfif rsFavorites.recordCount gt 5>
			<li><a href="#application.configbean.getIndexFile()#" onClick="return effectFunction();"><span>#rbFactory.getKey('favorites.morefavorites')#</span></a>
				<ul id="favoriteListMore" style="display:none">
				<cfloop query="rsFavorites" startrow="6">
					<cfif request.contentBean.getContentID() eq rsFavorites.contentid>
						<cfset currentPageFavoriteID = favoriteID>
					</cfif>
					<cfset contentLink = "" />
					<cfset lid = replace(rsFavorites.favoriteID, "-", "", "ALL") />
				
					<cfset contentLink = createHref(rsFavorites.Type, rsFavorites.filename, request.siteid, rsFavorites.contentID, rsFavorites.target,rsFavorites.targetParams, '', '#application.configBean.getContext()#', '#application.configBean.getStub()#', '#application.configBean.getIndexFile()#', 'false') />
					<cfset contentLink = "<a href='#contentLink#'>#HTMLEditFormat(rsFavorites.menuTitle)#</a>" />
					<li id="favorite#lid#"><a href="#application.configBean.getIndexFile()#" onClick="return deleteFavorite('#rsFavorites.favoriteID#', 'favorite#lid#');" title="#xmlformat(rbFactory.getKey('favorites.removefromfavorites'))#" class="remove">[-]</a> #contentLink#</li>
				</cfloop>
				</ul>
			</li>
		</cfif>
		<li id="favoriteTip" class="defaultMsg" style="display:none;">#rbFactory.getKey('favorites.nofavorites')#</li>
	<cfelse>
		<li id="favoriteTip" class="defaultMsg">#rbFactory.getKey('favorites.nofavorites')#</li>	</cfif>
	</ul>
	
	<!--- add favorites --->
	<cfset userID = getPersonalizationID() />
	<cfset menuTitle = request.contentBean.getMenuTitle() />
	<cfset contentID = request.contentBean.getContentID() />
	<cfset favoriteType = 'internal_content' />
	<cfset favoriteExists = application.favoriteManager.checkForFavorite(userID, contentID) />
<!---	
	<cfif favoriteExists>
		<span id="favoriteStatus" style="display:none"><a href="#application.configbean.getIndexFile()#" onClick="return saveFavorite('#userID#', '#siteID#', '#menuTitle#', '#contentID#', '#favoriteType#')">Add to favorites</a></span>
	<cfelse>
		<span id="favoriteStatus"><a href="#application.configbean.getIndexFile()#" onClick="return saveFavorite('#userID#', '#siteID#', '#menuTitle#', '#contentID#', '#favoriteType#')">Add to favorites</a></span>
	</cfif>
--->	
	<script>
		currentPageFavoriteID = '#currentPageFavoriteID#';
	</script>
<cfelse>
	#rbFactory.getResourceBundle().messageFormat(rbFactory.getKey('favorites.pleaselogin'),'#application.settingsManager.getSite(request.siteid).getLoginURL()#&returnURL=#getCurrentURL()#')#
</cfif>
</div>
<cfif len(getPersonalizationID())>
<div id="svPageTools">
	<#getHeaderTag('subHead1')#>#rbFactory.getKey('favorites.pagetools')#</#getHeaderTag('subHead1')#>
	<ul>
		<cfif favoriteExists>
			<cfset favoriteExistsStyle = "display:none;">
			<cfset addFavoriteStyle = "display:none;">
			<script>
				favoriteExists = true;
			</script>
		<cfelse>
			<cfset favoriteExistsStyle = "display:none;">
			<cfset addFavoriteStyle = "">
		</cfif>
		<li id="favoriteExists" style="#favoriteExistsStyle#"><a href="#application.configbean.getIndexFile()#" onClick="return false;">Stored in favorites</a></li>
		<li id="addFavorite" style="#addFavoriteStyle#"><a href="#application.configbean.getIndexFile()#" onClick="return saveFavorite('#userID#', '#siteID#', '#menuTitle#', '#contentID#', '#favoriteType#')">Add to favorites</a></li>
		<li id="sendToFriend"><a rel="shadowbox;width=600;height=500" href="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/#getSite().getDisplayPoolID()#/includes/display_objects/sendtofriend/index.cfm?link=#URLEncodedFormat(getCurrentURL())#&siteid=#request.siteid#">#rbFactory.getResourceBundle().messageFormat(rbFactory.getKey('favorites.emailthis'),rbFactory.getKey('sitemanager.content.type.#request.contentbean.getType()#'))#</a> </li>
		<li id="print"><a href="javascript:window.print();void(0);">#rbFactory.getResourceBundle().messageFormat(rbFactory.getKey('favorites.printthis'),rbFactory.getKey('sitemanager.content.type.#request.contentbean.getType()#'))#</a></li>
		<!---<li id="discuss"><a href="/forum">Discuss #contentTypeString#</a></li>--->
	</ul>
</div>
</cfif>
</cfoutput>



