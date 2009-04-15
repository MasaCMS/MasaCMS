<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
<cfset loadJSLib() />
<cfset addToHTMLHeadQueue("dragablefeeds/htmlhead/dragablefeeds.cfm")>	
<cfswitch expression="#getJsLib()#">
	<cfcase value="jquery">
		<cfset addToHTMLHeadQueue("dragablefeeds/htmlhead/dragablefeeds-jquery.cfm")>
	</cfcase>
	<cfdefaultcase>
		<cfset addToHTMLHeadQueue("dragablefeeds/htmlhead/dragablefeeds-prototype.cfm")>
	</cfdefaultcase>
</cfswitch>

<cfset rbFactory=getSite().getRBFactory() />
<cfset defaultFeeds = application.feedManager.getDefaultFeeds(request.siteid) />
<cfset remoteFeeds = application.feedManager.getFeeds(request.siteid, "remote") />
<cfset localFeeds = application.feedManager.getFeeds(request.siteid, "local") />

<cfquery dbtype="query" name="reorderedDefaultFeeds">
	select * from defaultFeeds
	where isActive = 1
	order by name desc
</cfquery>
</cfsilent>
<cfoutput>
<div id="svRSSFeeds">
<h3>#rbFactory.getKey('dragablefeeds.title')#</h3>
<cfif not len(getPersonalizationID()) and application.settingsManager.getSite(request.siteID).getExtranetPublicReg() eq 1><p class="rssBlurb"><a href="#application.settingsManager.getSite(request.siteid).getLoginURL()#&returnURL=#URLEncodedFormat(application.contentRenderer.getCurrentURL())#">#rbFactory.getKey('dragablefeeds.createaccount')#</a></p></cfif>
</div>


<h4 class="addFeeds">#rbFactory.getKey('dragablefeeds.wantmore')#</h4>
<div id="svAddNewFeed" class="clearfix">
	<form method="post" action="##">
		<dl id="rssInternal">
			<dt>#rbFactory.getKey('dragablefeeds.selectafeed')#</dt>
			<dd>
			<select name="rssURL">
				<option value="">#rbFactory.getKey('dragablefeeds.selectafeed')#</option>
				<cfoutput>
				<optgroup label="Our Favorites">
				<cfloop query="remoteFeeds">
					<cfset feedLink = "#channelLink#">
					<option value="#feedLink#">#name#</option>
				</cfloop>
				<optgroup label="#rbFactory.getResourceBundle().messageFormat(rbFactory.getKey('dragablefeeds.sitefeeds'),getSite().getSite())#">
				<cfloop query="localFeeds">
					<cfset feedLink = "http://#application.settingsManager.getSite(request.siteID).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/feed/?feedID=#feedID#">
					<option value="#feedLink#">#name#</option>
				</cfloop>
				</cfoutput>
			</select>
			<button class="submit" type="button" onclick="createFeed(this.form)" value="Create">#rbFactory.getKey('dragablefeeds.addfeed')#</button>
			</dd>
		</dl>
		<dl id="rssExternal">
			<dt>#rbFactory.getKey('dragablefeeds.addyourown')#</dt>
			<dd class="textField">
			<input type="text" name="rssURLtext" size="30" value="" maxlength="255">
			<button class="submit" type="button" onclick="createFeed(this.form)" value="Create">#rbFactory.getKey('dragablefeeds.addfeed')#</button>
			</dd>
		</dl>
	</form>
</div>

</cfoutput>
	
<cfoutput>
<script type="text/javascript">
	var siteID="#request.siteid#";
	var appContext="#application.configBean.getContext()#";
	addLoadEvent(initDragableBoxesScript);
	
	<cfif len(getPersonalizationID())>
		<cfset userFeeds = application.favoriteManager.getFavorites(getPersonalizationID(), "RSS", request.siteid)>
		userID = "#getPersonalizationID()#";
		siteID = "#request.siteid#";
		<cfif userFeeds.recordCount gt 0 >
			function createBoxes(){
			<cfloop query="userFeeds">
				//user
				createARSSBox('#favorite#','#columnNumber#',false,'#maxRssItems#',20);
			</cfloop>
			}
		<cfelse>
			<cfset middle = defaultFeeds.recordCount / 2>
			<cfset feedIndex = 1>
			function createBoxes(){
			<cfloop query="defaultFeeds">
				<cfif feedIndex lte middle>
					<cfset columnNumber = 1>
				<cfelse>
					<cfset columnNumber = 2>
				</cfif>
				<cfif type eq "Local">
					<cfset feedLink = "http://#application.settingsManager.getSite(request.siteID).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/feed/?feedID=#feedID#">
				<cfelse>
					<cfset feedLink = "#channelLink#">
				</cfif>
				// default non user
				createARSSBox('#feedLink#','#columnNumber#',false,5,60);
				<cfset feedIndex = feedIndex + 1>
			</cfloop>
			}
		</cfif>
	<cfelse>
		<!---<cfdump var="#defaultFeeds#">--->
		<cfset middle = defaultFeeds.recordCount / 2>
		<cfset feedIndex = 1>
		function createBoxes(){
		<cfloop query="reorderedDefaultFeeds">
			<cfif feedIndex gt middle>
				<cfset columnNumber = 1>
			<cfelse>
				<cfset columnNumber = 2>
			</cfif>
			<cfif type eq "Local">
				<cfset feedLink = "http://#application.settingsManager.getSite(request.siteID).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/feed/?feedID=#feedID#">
			<cfelse>
				<cfset feedLink = "#channelLink#">
			</cfif>
			// default
			createARSSBox('#feedLink#','#columnNumber#',false,5,60);
			<cfset feedIndex = feedIndex + 1>
		</cfloop>
		}
	</cfif>
</script>
</cfoutput>