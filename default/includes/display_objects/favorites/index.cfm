<cfsilent>
<cfset variables.$.loadShadowBoxJS() />
<cfset variables.rbFactory=variables.$.siteConfig('RBFactory')/>
<cfswitch expression="#variables.$.getJsLib()#">
	<cfcase value="jquery">
		<cfset variables.$.addToHTMLHeadQueue("favorites/htmlhead/favorites-jquery.cfm")>
	</cfcase>
	<cfdefaultcase>
		<cfset variables.$.addToHTMLHeadQueue("favorites/htmlhead/favorites-prototype.cfm")>
	</cfdefaultcase>
</cfswitch>

<cfset variables.currentPageFavoriteID = "">
</cfsilent>
<cfoutput>
<div id="svFavoritesList">
	<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('favorites.favorites')#</#variables.$.getHeaderTag('subHead1')#>
<cfif len(getPersonalizationID())>
	<!--- list the favorites --->
	<cfset variables.rsFavorites = application.favoriteManager.getInternalContentFavorites(variables.$.getPersonalizationID(), variables.$.event('siteID')) />

	<ul id="favoriteList">
	<cfif variables.rsFavorites.recordcount>
		<!---<#variables.$.getHeaderTag('subHead1')#>Favorites</#variables.$.getHeaderTag('subHead1')#>--->
		<cfloop query="variables.rsFavorites" startrow="1" endrow="5">
			<cfif variables.$.content('contentID') eq variables.rsFavorites.contentid>
				<cfset variables.currentPageFavoriteID = variables.rsFavorites.favoriteID>
			</cfif>
			<cfset variables.contentLink = "" />
			<cfset variables.lid = replace(variables.rsFavorites.favoriteID, "-", "", "ALL") />
			<cfset variables.contentLink = createHref(variables.rsFavorites.Type, variables.rsFavorites.filename, variables.$.event('siteID'), variables.rsFavorites.contentID, variables.rsFavorites.target,variables.rsFavorites.targetParams, '', '#variables.$.globalConfig('context')#', '#variables.$.globalConfig('stub')#', '', 'false') />
			<cfset variables.contentLink = "<a href='#variables.contentLink#'>#HTMLEditFormat(variables.rsFavorites.menutitle)#</a>" />
			<li id="favorite#variables.lid#"><a href="" onclick="return deleteFavorite('#variables.rsFavorites.favoriteID#', 'favorite#variables.lid#');" title="#xmlformat(variables.$.rbKey('favorites.removefromfavorites'))#" class="remove">[-]</a> #variables.contentLink#</li>
		</cfloop>
		<cfif variables.rsFavorites.recordCount gt 5>
			<li><a href="" onclick="return effectFunction();"><span>#variables.$.rbKey('favorites.morefavorites')#</span></a>
				<ul id="favoriteListMore" style="display:none">
				<cfloop query="variables.rsFavorites" startrow="6">
					<cfif variables.$.content('contentID') eq variables.rsFavorites.contentid>
						<cfset variables.currentPageFavoriteID = variables.rsFavorites.favoriteID>
					</cfif>
					<cfset variables.contentLink = "" />
					<cfset variables.lid = replace(variables.rsFavorites.favoriteID, "-", "", "ALL") />
				
					<cfset variables.contentLink = variables.$.createHref(variables.rsFavorites.Type, variables.rsFavorites.filename, variables.$.event('siteID'), variables.rsFavorites.contentID, variables.rsFavorites.target,variables.rsFavorites.targetParams, '', '#variables.$.globalConfig('context')#', '#variables.$.globalConfig('stub')#', '', 'false') />
					<cfset variables.contentLink = "<a href='#variables.contentLink#'>#HTMLEditFormat(variables.rsFavorites.menuTitle)#</a>" />
					<li id="favorite#variables.lid#"><a href="" onclick="return deleteFavorite('#variables.rsFavorites.favoriteID#', 'favorite#variables.lid#');" title="#xmlformat(variables.$.rbKey('favorites.removefromfavorites'))#" class="remove">[-]</a> #variables.contentLink#</li>
				</cfloop>
				</ul>
			</li>
		</cfif>
		<li id="favoriteTip" class="defaultMsg" style="display:none;">#variables.$.rbKey('favorites.nofavorites')#</li>
	<cfelse>
		<li id="favoriteTip" class="defaultMsg">#variables.$.rbKey('favorites.nofavorites')#</li>	
	</cfif>
	</ul>
	
	<!--- add favorites --->
	<cfset variables.userID = getPersonalizationID() />
	<cfset variables.menuTitle = variables.$.content('menuTitle') />
	<cfset variables.contentID = variables.$.content('contentID') />
	<cfset variables.favoriteType = 'internal_content' />
	<cfset variables.favoriteExists = application.favoriteManager.checkForFavorite(variables.userID, variables.contentID) />
<!---	
	<cfif favoriteExists>
		<span id="favoriteStatus" style="display:none"><a href="" onclick="return saveFavorite('#userID#', '#siteID#', '#menuTitle#', '#contentID#', '#favoriteType#')">Add to favorites</a></span>
	<cfelse>
		<span id="favoriteStatus"><a href="" onclick="return saveFavorite('#userID#', '#siteID#', '#menuTitle#', '#contentID#', '#favoriteType#')">Add to favorites</a></span>
	</cfif>
--->	
	<script type="text/javascript">
		currentPageFavoriteID = '#variables.currentPageFavoriteID#';
	</script>
<cfelse>
	<p class="loginMessage">#rbFactory.getResourceBundle().messageFormat(variables.$.rbKey('favorites.pleaselogin'),'#variables.$.siteConfig('LoginURL')#&returnURL=#getCurrentURL()#')#</p>
</cfif>
</div>
<cfif len(getPersonalizationID())>
<div id="svPageTools">
	<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('favorites.pagetools')#</#variables.$.getHeaderTag('subHead1')#>
	<cfif variables.favoriteExists>
		<cfset variables.favoriteExistsStyle = "display:none;">
		<cfset variables.addFavoriteStyle = "display:none;">
		<script type="text/javascript">
			favoriteExists = true;
		</script>
	<cfelse>
		<cfset variables.favoriteExistsStyle = "display:none;">
		<cfset variables.addFavoriteStyle = "">
	</cfif>
	<ul>
		<li id="favoriteExists" style="#variables.favoriteExistsStyle#"><a href="" onclick="return false;">Stored in favorites</a></li>
		<li id="addFavorite" style="#addFavoriteStyle#"><a href="" onclick="return saveFavorite('#variables.userID#', '#arguments.siteID#', '#JSStringFormat(variables.menuTitle)#', '#variables.contentID#', '#variables.favoriteType#')">#variables.$.rbKey('favorites.addtofavorites')#</a></li>
		<!---<li id="sendToFriend"><a rel="shadowbox;width=600;height=500" href="http://#variables.$.siteConfig('domain')##variables.$.globalConfig('ServerPort')##variables.$.globalConfig('context')#/#getSite().getDisplayPoolID()#/includes/display_objects/sendtofriend/index.cfm?link=#URLEncodedFormat(getCurrentURL())#&siteid=#variables.$.event('siteID')#">#variables.rbFactory.getResourceBundle().messageFormat(variables.$.rbKey('favorites.emailthis'),variables.$.rbKey('sitemanager.content.type.#variables.$.content('type')#'))#</a> </li>--->
		<li id="print"><a href="javascript:window.print();void(0);">#rbFactory.getResourceBundle().messageFormat(variables.$.rbKey('favorites.printthis'),variables.$.rbKey('sitemanager.content.type.#variables.$.content('type')#'))#</a></li>
		<!---<li id="discuss"><a href="/forum">Discuss #contentTypeString#</a></li>--->
	</ul>
</div>
</cfif>
</cfoutput>



