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
<cfparam name="url.columnNumber" default="">
<cfparam name="url.rowNumber" default="">
<cfparam name="url.maxRssItems" default="">
<cfset rbFactory=application.settingsManager.getSite(url.siteid).getRBFactory()/>
<cfset favorite = application.favoriteManager.saveFavorite('', url.userID, url.siteid, url.favoriteName, url.favoriteLocation, url.favoritetype, url.columnNumber, url.rowNumber, url.maxRssItems) />
<cfset contentLink = "" />
<cfset lid = replace(favorite.getFavoriteID(), "-", "", "ALL") />
<cfset contentBean = application.contentManager.getActiveContent(favorite.getFavorite(), url.siteid) />
<cfset contentLink = application.contentRenderer.createHref(contentBean.getType(), contentBean.getFilename(), url.siteid, favorite.getfavorite(), '', '', '', '#application.configBean.getContext()#', '#application.configBean.getStub()#', '#application.configBean.getIndexFile()#', 'false') />
<cfset contentLink = "<a href='#contentLink#'>#favoriteName#</a>" />
<cfset contentLink = "<a href=""#application.configBean.getIndexFile()#"" onClick=""return deleteFavorite('#favorite.getfavoriteID()#', 'favorite#lid#');"" title=""#xmlformat(rbFactory.getKey('favorites.removefromfavorites'))#"" class=""remove"">[-]</a> " & contentLink />
<cfset favoriteStruct = structNew() />
<cfset favoriteStruct.lid = lid />
<cfset favoriteStruct.link = contentLink />
<cfset favoriteStruct.favoriteID = favorite.getFavoriteID() />
<cfoutput>#application.contentRenderer.jsonencode(favoriteStruct)#</cfoutput>