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
<cfset event=request.event>
<cfinclude template="js.cfm">
<cfif rc.type eq 'Local'>
<cfsilent>
<cfset options=arrayNew(2) />
<cfset criterias=arrayNew(2) />
<cfset rsParams=rc.feedBean.getAdvancedParams()/>

<cfset options[1][1]="tcontent.lastupdate^date">
<cfset options[1][2]=application.rbFactory.getKeyValue(session.rb,'params.lastupdate')>
<cfset options[2][1]="tcontent.releaseDate^date">
<cfset options[2][2]=application.rbFactory.getKeyValue(session.rb,'params.releasedate')>
<cfset options[3][1]="tcontent.created^date">
<cfset options[3][2]=application.rbFactory.getKeyValue(session.rb,'params.created')>
<cfset options[4][1]="tcontent.menuTitle^varchar">
<cfset options[4][2]=application.rbFactory.getKeyValue(session.rb,'params.menutitle')>
<cfset options[5][1]="tcontent.title^varchar">
<cfset options[5][2]=application.rbFactory.getKeyValue(session.rb,'params.title')>
<cfset options[6][1]="tcontent.Credits^varchar">
<cfset options[6][2]=application.rbFactory.getKeyValue(session.rb,'params.credits')>
<cfset options[7][1]="tcontent.summary^varchar">
<cfset options[7][2]=application.rbFactory.getKeyValue(session.rb,'params.summary')>
<cfset options[8][1]="tcontent.body^varchar">
<cfset options[8][2]=application.rbFactory.getKeyValue(session.rb,'params.body')>
<cfset options[9][1]="tcontent.metaDesc^varchar">
<cfset options[9][2]=application.rbFactory.getKeyValue(session.rb,'params.metadesc')>
<cfset options[10][1]="tcontent.metaKeywords^varchar">
<cfset options[10][2]=application.rbFactory.getKeyValue(session.rb,'params.metakeywords')>
<cfset options[11][1]="tcontent.type^varchar">
<cfset options[11][2]=application.rbFactory.getKeyValue(session.rb,'params.type')>
<cfset options[12][1]="tcontent.subType^varchar">
<cfset options[12][2]=application.rbFactory.getKeyValue(session.rb,'params.subtype')>
<cfset options[13][1]="tcontenttags.tag^varchar">
<cfset options[13][2]=application.rbFactory.getKeyValue(session.rb,'params.tag')>
<cfset options[14][1]="tcontent.displayStart^timestamp">
<cfset options[14][2]=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')>
<cfset options[15][1]="tcontent.displayStop^timestamp">
<cfset options[15][2]=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')>
<cfset options[16][1]="tcontent.expires^timestamp">
<cfset options[16][2]=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires')>
<cfset options[17][1]="tcontent.contentID^varchar">
<cfset options[17][2]="Content ID"/>
<cfset options[18][1]="tcontent.parentID^varchar">
<cfset options[18][2]="Parent ID"/>
<cfset options[19][1]="tcontent.path^varchar">
<cfset options[19][2]="Path"/>
<cfset options[20][1]="tcontentcategoryassign.categoryID^varchar">
<cfset options[20][2]="Category ID"/>
<cfset options[21][1]="tcontent.filename^varchar">
<cfset options[21][2]="Filename"/>

<cfset rc.feedBean.setSiteID(rc.siteid)>
<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(siteID=rc.siteid,baseTable="tcontent",activeOnly=true)>
<cfloop query="rsExtend">
<cfset options[rsExtend.currentRow + 20][1]="#rsExtend.attributeID#^varchar">
<cfset options[rsExtend.currentRow + 20][2]="#rsExtend.Type#/#rsExtend.subType# - #rsExtend.attribute#"/>
</cfloop>

<cfset criterias[1][1]="Equals">
<cfset criterias[1][2]=application.rbFactory.getKeyValue(session.rb,'params.equals')>
<cfset criterias[2][1]="GT">
<cfset criterias[2][2]=application.rbFactory.getKeyValue(session.rb,'params.gt')>
<cfset criterias[3][1]="GTE">
<cfset criterias[3][2]=application.rbFactory.getKeyValue(session.rb,'params.gte')>
<cfset criterias[4][1]="LT">
<cfset criterias[4][2]=application.rbFactory.getKeyValue(session.rb,'params.lt')>
<cfset criterias[5][1]="LTE">
<cfset criterias[5][2]=application.rbFactory.getKeyValue(session.rb,'params.lte')>
<cfset criterias[6][1]="NEQ">
<cfset criterias[6][2]=application.rbFactory.getKeyValue(session.rb,'params.neq')>
<cfset criterias[7][1]="Begins">
<cfset criterias[7][2]=application.rbFactory.getKeyValue(session.rb,'params.beginswith')>
<cfset criterias[8][1]="Contains">
<cfset criterias[8][2]=application.rbFactory.getKeyValue(session.rb,'params.contains')>
<cfset criterias[9][1]="IN">
<cfset criterias[9][2]=application.rbFactory.getKeyValue(session.rb,'params.in')>
<cfset criterias[10][1]="NOT IN">
<cfset criterias[10][2]=application.rbFactory.getKeyValue(session.rb,'params.notin')>

<cfset hasCategories=application.categoryManager.getCategoryCount(rc.siteid)>

<cfif len(rc.assignmentID)>
	<cfset rsDisplayObject=application.contentManager.readContentObject(rc.assignmentID,rc.regionID,rc.orderno)>
	<cfset rc.feedBean.setInstanceParams(rsDisplayObject.params)>

	<cfif not isJson(rsDisplayObject.params)>
		<cfset variables.contentListFields=rc.feedBean.getDisplayList()>

		<cfset variables.hasSummary=listFindNoCase("feed_slideshow_no_summary,feed_no_summary",rsDisplayObject.object) and listFindNoCase(variables.contentListFields,"Summary")>
		<cfif variables.hasSummary>
			<cfset  variables.contentListFields=listDeleteAt(variables.contentListFields,arguments.hasSummary)>
		 </cfif>

		<cfif listFindNoCase("feed_slideshow_no_summary,feed_slideshow",rsDisplayObject.object)>
			<cfset rc.feedBean.setImageSize("medium")>
			<cfset rc.feedBean.setImageHeight("AUTO")>
			<cfset rc.feedBean.setImageWidth("AUTO")>
		</cfif>

		<cfset rc.feedBean.setDisplayList(variables.contentListFields)>
	<cfelse>
		<cfset rc.feedBean.set(deserializeJSON(rsDisplayObject.params))>
	</cfif>
	<cfset displaNamePrefix="instance">
	<cfset isObjectInstance=true>
<cfelse>
	<cfset displaNamePrefix="">
	<cfset isObjectInstance=false>
</cfif>

<cfif rc.$.getContentRenderer().useLayoutManager()>
	<cfif hasCategories>
		<cfset tablist="tabBasic,tabCategorization,tabAdvancedfilters,tabRss">
		<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.basic')#,#application.rbFactory.getKeyValue(session.rb,'collections.categorization')#,#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#,#application.rbFactory.getKeyValue(session.rb,'collections.rss')#">
	<cfelse>
		<cfset tablist="tabBasic,tabAdvancedfilters,tabRss">
		<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.basic')#,#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#,#application.rbFactory.getKeyValue(session.rb,'collections.rss')#">
	</cfif>

<cfelse>
	<cfif hasCategories>
		<cfset tablist="tabBasic,tabCategorization,tabAdvancedfilters,tabDisplay,tabRss">
		<cfif isObjectInstance>
			<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.basic')#,#application.rbFactory.getKeyValue(session.rb,'collections.categorization')#,#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#,#application.rbFactory.getKeyValue(session.rb,'collections.displayinstance')#,#application.rbFactory.getKeyValue(session.rb,'collections.rss')#">
		<cfelse>
			<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.basic')#,#application.rbFactory.getKeyValue(session.rb,'collections.categorization')#,#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#,#application.rbFactory.getKeyValue(session.rb,'collections.displaydefaults')#,#application.rbFactory.getKeyValue(session.rb,'collections.rss')#">
		</cfif>
	<cfelse>
		<cfset tablist="tabBasic,tabAdvancedfilters,tabDisplay,tabRss">
		<cfif isObjectInstance>
			<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.basic')#,#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#,#application.rbFactory.getKeyValue(session.rb,'collections.displayinstance')#,#application.rbFactory.getKeyValue(session.rb,'collections.rss')#">
		<cfelse>
			<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.basic')#,#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#,#application.rbFactory.getKeyValue(session.rb,'collections.displaydefaults')#,#application.rbFactory.getKeyValue(session.rb,'collections.rss')#">
		</cfif>
	</cfif>
</cfif>

<cfset endpoint=rc.$.siteConfig().getApi('feed','v1').getEndpoint()>
</cfsilent>

<div class="mura-header">
<cfoutput>
	<cfif rc.feedBean.getIsNew()>
		<h1>#application.rbFactory.getKeyValue(session.rb,'collections.createlocalindex')#</h1>
	<cfelse>
		<h1><cfif len(rc.assignmentID)>#application.rbFactory.getKeyValue(session.rb,'collections.editlocalindexinstance')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'collections.editlocalindex')#</cfif></h1>
	</cfif>

	<cfif rc.compactDisplay neq "true">
		<cfinclude template="dsp_secondary_menu.cfm">
	</cfif>
</div> <!-- /.mura-header -->


<cfif not structIsEmpty(rc.feedBean.getErrors())>
	<div class="alert alert-error"><span>#application.utility.displayErrors(rc.feedBean.getErrors())#</span></div>
</cfif>

<cfif rc.feedBean.exists() and rc.compactDisplay eq "true" and not isObjectInstance>
	<div class="alert alert-info"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.globallyappliednotice")#</span></div>
</cfif>

<!-- This is plugin message targeting --->
<span id="msg">
#application.pluginManager.renderEvent("onFeedEditMessageRender",event)#
</span>

<form novalidate="novalidate" action="./?muraAction=cFeed.update&siteid=#esapiEncode('url',rc.siteid)#" method="post" name="form1" id="feedFrm" onsubmit="return validate(this);"<cfif len(rc.assignmentID)> style="width: 412px"</cfif>>

<div class="block block-constrain">

<cfif not isObjectInstance>
	<!---
	<cfif rc.compactDisplay eq "true">
		<div class="nav-module-specific btn-group">
		<cfif rc.$.useLayoutManager()>
			<a class="btn" href="javascript:frontEndProxy.post({cmd:'close'});">
				<i class="mi-arrow-circle-left"></i>
				#application.rbFactory.getKeyValue(session.rb,'collections.back')#
			</a>
		<cfelse>
			<a class="btn" onclick="history.go(-1);">
				<i class="mi-arrow-circle-left"></i>
				#application.rbFactory.getKeyValue(session.rb,'collections.back')#
			</a>
		</cfif>
		</div>
	</cfif>
	--->
<cfelse>
	<!---<h2>#esapiEncode('html',rc.feedBean.getName())#</h2>--->
	<cfsilent>
		<cfset editlink = "?muraAction=cFeed.edit">
		<cfset editlink = editlink & "&amp;siteid=" & rc.feedBean.getSiteID()>
		<cfset editlink = editlink & "&amp;feedid=" & rc.feedBean.getFeedID()>
		<cfset editlink = editlink & "&amp;type=" & rc.feedBean.getType()>
		<cfset editlink = editlink & "&amp;homeID=" & rc.homeID>
		<cfset editlink = editlink & "&amp;compactDisplay=true">
	</cfsilent>
	<ul class="navTask nav nav-pills">
		<li><a href="#editlink#">#application.rbFactory.getKeyValue(session.rb,'collections.editdefaultsettings')#</a></li>
	</ul>
</cfif>
</cfoutput>
<!-- Content Filters -->
<cfsavecontent variable="tabContent">
<cfoutput>
<cfif not isObjectInstance>
<!--- Basic Tab --->
	<div id="tabBasic" class="tab-pane active">

		<div class="block block-bordered">
			<!-- block header -->
			<div class="block-header">
				<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'collections.basic')#</h3>
			</div> <!-- /.block header -->
			<div class="block-content">
			<!--- Name --->
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.name')#</label>
				<input type="text" name="name" required="true" message="#application.rbFactory.getKeyValue(session.rb,'collections.namerequired')#" value="#esapiEncode('html_attr',rc.feedBean.getName())#" maxlength="250"<cfif rc.feedBean.getIsLocked()> disabled="disabled"</cfif>>
			</div>


			<cfif listLen($.siteConfig('contentPoolID')) gt 1>
			<div class="mura-control-group">
				<label>
					#application.rbFactory.getKeyValue(session.rb,'collections.contentpool')#
				</label>
					<select id="contentPoolID" name="contentPoolID" multiple>
									<option value="#$.event('siteid')#" <cfif listFind(rc.feedBean.getContentPoolID(), $.event('siteid'))>selected</cfif>>This site</option>
									<cfloop list="#$.siteConfig('contentPoolID')#" index="p">
											<cfif p neq rc.feedBean.getSiteID()>
												<option value="#esapiEncode('html_attr',p)#" <cfif listFind(rc.feedBean.getContentPoolID(), p)>selected</cfif>>#HTMLEditFormat($.getBean('settingsManager').getSite(p).getSite())#</option>
										</cfif>
									</cfloop>
									</select>
				</div>
			<cfelse>
				<input type="hidden" id="contentPoolID" name="contentPoolID" value="#esapiEncode('html_attr',rc.feedBean.getContentPoolID())#"/>
			</cfif>

			<!--- Sections --->
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.basicfromsection')#: <span id="selectFilter"><a class="btn" href="javascript:;" onclick="javascript: feedManager.loadSiteFilters('#rc.siteid#','',1,$('##contentPoolID').val());return false;">#application.rbFactory.getKeyValue(session.rb,'collections.selectnewsection')#</a></span></label>
				<div class="mura-control justify">
					<table id="contentFilters" class="mura-table-grid">
						<thead>
							<tr>
								<th class="actions"></th>
								<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'collections.section')#</th>
								<th>#application.rbFactory.getKeyValue(session.rb,'collections.type')#</th>
							</tr>
						</thead>
						<tbody id="ContentFilters">
							<cfset started=false>
							<cfif rc.rslist.recordcount>
								<cfloop query="rc.rslist">
									<cfscript>
										item=$.getBean('content').loadBy(contentid=rc.rslist.contentid,siteid=rc.rslist.siteid);

									</cfscript>
									<cfif item.exists()>
										<cfset started=true>
										<tr id="c#rc.rslist.contentID#">
											<td class="actions"><input type="hidden" name="contentID" value="#rc.rslist.contentid#" /><ul class="clearfix"><li class="delete"><a title="Delete" href="##" onclick="feedManager.removeFilter('c#rc.rslist.contentid#'); return false;"><i class="mi-trash"></i></a></li></ul></td>
											<td class="var-width">#$.dspZoomNoLinks(item.getCrumbArray())#</td>
											<td>#rc.rslist.type#</td>
										</tr>
									</cfif>
								</cfloop>
							</cfif>
							<cfif not started>
								<tr>
									<td class="noResults" colspan="3" id="noFilters">#application.rbFactory.getKeyValue(session.rb,'collections.nocontentfilters')#</td>
								</tr>
							</cfif>
						</tbody>
					</table>
				</div>
			</div>

			<!--- Sort Options --->
			<div class="mura-control-group">
				<!--- Sort By --->
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.sortby')#</label>
						<select name="sortBy">
							<option value="lastUpdate" <cfif rc.feedBean.getsortBy() eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.lastupdate')#</option>
							<option value="releaseDate" <cfif rc.feedBean.getsortBy() eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.releasedate')#</option>
							<option value="displayStart" <cfif rc.feedBean.getsortBy() eq 'displayStart'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.displaystart')#</option>
							<option value="menuTitle" <cfif rc.feedBean.getsortBy() eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.menutitle')#</option>
							<option value="title" <cfif rc.feedBean.getsortBy() eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.longtitle')#</option>
							<option value="rating" <cfif rc.feedBean.getsortBy() eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.rating')#</option>
							<cfif isBoolean(application.settingsManager.getSite(session.siteid).getHasComments()) and application.settingsManager.getSite(session.siteid).getHasComments()>
								<option value="comments" <cfif rc.feedBean.getsortBy() eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.comments')#</option>
							</cfif>
							<option value="created" <cfif rc.feedBean.getsortBy() eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.created')#</option>
							<option value="orderno" <cfif rc.feedBean.getsortBy() eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.orderno')#</option>
							<option value="random" <cfif rc.feedBean.getsortBy() eq 'random'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.random')#</option>
							<cfif rc.$.getServiceFactory().containsBean('marketingManager')>
								<option value="mxpRelevance" <cfif rc.feedBean.getsortBy() eq 'mxpRelevance'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.mxpRelevance')#</option>
							</cfif>
							<option value="" <cfif rc.feedBean.getsortBy() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.donotapplysort')#</option>
							<cfloop query="rsExtend">
								<option value="#esapiEncode('html_attr',rsExtend.attribute)#" <cfif rc.feedBean.getsortBy() eq rsExtend.attribute>selected</cfif>>#rsExtend.Type#/#rsExtend.subType# - #rsExtend.attribute#</option>
							</cfloop>
						</select>
					</div>
				<!--- Sort Direction --->
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.sortdirection')#</label>
				<select name="sortDirection">
					<option value="asc" <cfif rc.feedBean.getsortDirection() eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.ascending')#</option>
					<option value="desc" <cfif rc.feedBean.getsortDirection() eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.descending')#</option>
				</select>
			</div>
			<cfif rc.$.getContentRenderer().useLayoutManager()>
				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</label>
					<select name="#displaNamePrefix#maxItems" data-displayobjectparam="maxItems">
						<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
						<option value="#m#" <cfif rc.feedBean.getMaxItems() eq m>selected</cfif>>#m#</option>
						</cfloop>
						<option value="100000" <cfif rc.feedBean.getMaxItems() eq 100000>selected</cfif>>All</option>
					</select>
				</div>
				<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</label>
					<select name="#displaNamePrefix#nextN" data-displayobjectparam="nextN">
						<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
						<option value="#r#" <cfif r eq rc.feedBean.getNextN()>selected</cfif>>#r#</option>
						</cfloop>
						<option value="100000" <cfif rc.feedBean.getNextN() eq 100000>selected</cfif>>All</option>
					</select>
				</div>
			</cfif>
			<!--- Features + Nav --->
			<div class="mura-control-group">
				<!--- Features Only --->
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.includefeaturesonly')#</label>
						<label class="radio inline">
							<input name="isFeaturesOnly" type="radio" value="1" class="radio" <cfif rc.feedBean.getIsFeaturesOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
						</label>
						<label class="radio inline">
							<input name="isFeaturesOnly" type="radio" value="0" class="radio" <cfif not rc.feedBean.getIsFeaturesOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
						</label>
					</div>
				<!--- Nav Only --->
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.shownavonly')#</label>
						<label class="radio inline">
							<input name="showNavOnly" type="radio" value="1" class="radio" <cfif rc.feedBean.getShowNavOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
						</label>
						<label class="radio inline">
							<input name="showNavOnly" type="radio" value="0" class="radio" <cfif not rc.feedBean.getShowNavOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
						</label>
					</div>

			<!--- Exclude From Site Search --->
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.showexcludesearch')#</label>
					<label class="radio inline">
						<input name="showExcludeSearch" type="radio" value="1" class="radio" <cfif rc.feedBean.getShowExcludeSearch()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
					</label>
					<label class="radio inline">
						<input name="showExcludeSearch" type="radio" value="0" class="radio" <cfif not rc.feedBean.getShowExcludeSearch()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
					</label>
				</div>

			<!--- Lock Name? --->
			<cfif listFind(session.mura.memberships,'S2')>
				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.isLocked')#</label>
						<label class="radio inline">
							<input name="islocked" type="radio" value="1" class="radio" <cfif rc.feedBean.getIsLocked()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
						</label>
						<label class="radio inline">
							<input name="islocked" type="radio" value="0" class="radio" <cfif not rc.feedBean.getIsLocked()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
						</label>
					</div>
			</cfif>

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.tab-pane -->

<cfif hasCategories>
<div id="tabCategorization" class="tab-pane">
	<div class="block block-bordered">
			<!-- block header -->
			<div class="block-header">
				<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'collections.categorization')#</h3>
			</div> <!-- /.block header -->
			<div class="block-content">

				<div class="mura-control-group">
					<!--- Category Filters --->
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.categoryfilters')#</label>
					<div id="mura-list-tree" class="mura-control">
						<cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" nestLevel="0" feedID="#rc.feedID#" feedBean="#rc.feedBean#">
					</div>
				</div>
				<div class="mura-control-group">
					<!--- Match All Categories (Category Intersection) --->
					<label>
						<span data-toggle="popover" title="" data-placement="right"
							data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"collections.categoryintersectiontip"))#"
							data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"collections.categoryintersection"))#">
							#application.rbFactory.getKeyValue(session.rb,'collections.categoryintersection')#
							<i class="mi-question-circle"></i>
						</span>
					</label>
						<label class="radio inline">
						<input name="useCategoryIntersect" type="radio" value="1" <cfif rc.feedBean.getUseCategoryIntersect()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
						</label>
						<label class="radio inline">
						<input name="useCategoryIntersect" type="radio" value="0" <cfif not rc.feedBean.getUseCategoryIntersect()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
						</label>
					</div>

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.tab-pane -->
</cfif>

<div id="tabAdvancedfilters" class="tab-pane">
	<div class="block block-bordered">
		<!-- block header -->
		<div class="block-header">
			<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#</h3>
		</div> <!-- /.block header -->
		<div class="block-content">
			<div class="mura-control-group" id="searchParams">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.chooseadvancedfilters')#</label>
			<cfif not rsParams.recordcount>
				<div class="mura-control justify">
					<select name="paramRelationship1" style="display:none;" >
						<option value="and">#application.rbFactory.getKeyValue(session.rb,'params.and')#</option>
						<option value="or">#application.rbFactory.getKeyValue(session.rb,'params.or')#</option>
					</select>
					<input type="hidden" name="param" value="1" />
					<select name="paramField1">
						<option value="">#application.rbFactory.getKeyValue(session.rb,'params.selectfield')#</option>
						<cfloop from="1" to="#arrayLen(options)#" index="i">
						<option value="#options[i][1]#">#options[i][2]#</option>
						</cfloop>
					</select>
					<select name="paramCondition1">
						<cfloop from="1" to="#arrayLen(criterias)#" index="i">
						<option value="#criterias[i][1]#">#criterias[i][2]#</option>
						</cfloop>
					</select>
					<input type="text" name="paramCriteria1">
					<a class="criteria remove" href="javascript:;" onclick="$searchParams.removeSeachParam(this.parentNode);$searchParams.setSearchButtons();return false;" style="display:none;"><i class="mi-minus-circle"></i></a>
					<a class="criteria add" href="javascript:;" onclick="$searchParams.addSearchParam();$searchParams.setSearchButtons();return false;"><i class="mi-plus-circle"></i></a>
				</div>
			<cfelse>
				<cfloop query="rsParams">
					<div class="mura-control justify">
						<select name="paramRelationship#rsParams.currentRow#">
							<option value="and" <cfif rsParams.criteria eq '' or rsParams.relationship eq "and">selected</cfif> >And</option>
							<option value="or" <cfif rsParams.criteria neq '' and rsParams.relationship eq "or">selected</cfif> >Or</option>
						</select>
						<input type="hidden" name="param" value="#rsParams.currentRow#" />
						<select name="paramField#rsParams.currentRow#">
						<option value="">#application.rbFactory.getKeyValue(session.rb,'params.selectfield')#</option>
						<cfloop from="1" to="#arrayLen(options)#" index="i">
						<option value="#options[i][1]#" <cfif rsParams.criteria neq '' and "#rsParams.field#^#rsParams.dataType#" eq options[i][1]>selected</cfif>>#options[i][2]#</option>
						</cfloop>
						</select>
						<select name="paramCondition#rsParams.currentRow#">
						<cfloop from="1" to="#arrayLen(criterias)#" index="i">
						<option value="#criterias[i][1]#" <cfif rsParams.criteria neq '' and rsParams.condition eq criterias[i][1]>selected</cfif>>#criterias[i][2]#</option>
						</cfloop>
						</select>
						<input type="text" name="paramCriteria#rsParams.currentRow#" value="#esapiEncode('html_attr',rsParams.criteria)#" >
						<a class="criteria remove" href="javascript:;" onclick="$searchParams.removeSeachParam(this.parentNode);$searchParams.setSearchButtons();return false;"><i class="mi-minus-circle"></i></a>
						<a class="criteria add" href="javascript:;" onclick="$searchParams.addSearchParam();$searchParams.setSearchButtons();return false;" ><i class="mi-plus-circle"></i></a>
					</div>
				</cfloop>
			</cfif>
		</div>
	</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.tab-pane -->
</cfif>
<cfif not rc.$.getContentRenderer().useLayoutManager()>
<div id="tabDisplay" class="tab-pane">

	<div class="block block-bordered">
		<!-- block header -->
		<div class="block-header">
			<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'collections.displaydefaults')#</h3>
		</div> <!-- /.block header -->
		<div class="block-content">
		<cfif isObjectInstance><h2>#esapiEncode('html',rc.feedBean.getName())#</h2></cfif>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
				<select name="#displaNamePrefix#imageSize" data-displayobjectparam="imageSize" onchange="if(this.value=='custom'){jQuery('##feedCustomImageOptions').fadeIn('fast')}else{jQuery('##feedCustomImageOptions').hide();jQuery('##feedCustomImageOptions').find(':input').val('AUTO');}">
					<cfloop list="Small,Medium,Large" index="i">
						<option value="#lcase(i)#"<cfif i eq rc.feedBean.getImageSize()> selected</cfif>>#I#</option>
					</cfloop>

					<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>

					<cfloop condition="imageSizes.hasNext()">
						<cfset image=imageSizes.next()>
						<option value="#lcase(image.getName())#"<cfif image.getName() eq rc.feedBean.getImageSize()> selected</cfif>>#esapiEncode('html',image.getName())#</option>
					</cfloop>
					<option value="custom"<cfif "custom" eq rc.feedBean.getImageSize()> selected</cfif>>Custom</option>
				</select>
		</div>

		<div id="feedCustomImageOptions" class="mura-control-group"<cfif rc.feedBean.getImageSize() neq "custom"> style="display:none"</cfif>>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</label>
				<input class="mura-constrain numeric" name="#displaNamePrefix#imageWidth" data-displayobjectparam="imageWidth" type="text" value="#rc.feedBean.getImageWidth()#" />
			</div>

			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
				<input class="mura-constrain numeric" name="#displaNamePrefix#imageHeight" data-displayobjectparam="imageHeight" type="text" value="#rc.feedBean.getImageHeight()#" />
			</div>
		</div>

	<div class="mura-control-group">
		<label>#application.rbFactory.getKeyValue(session.rb,'collections.displayname')#</label>
		<label class="radio inline">
			<input name="#displaNamePrefix#displayName" data-displayobjectparam="displayName" type="radio" value="1" class="radio" onchange="jQuery('##altNameContainer').toggle();"<cfif rc.feedBean.getDisplayName()>checked</cfif>>
			#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
		</label>
		<label class="radio inline">
			<input name="#displaNamePrefix#displayName" data-displayobjectparam="displayName" type="radio" value="0" class="radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not rc.feedBean.getDisplayName()>checked</cfif>>
			#application.rbFactory.getKeyValue(session.rb,'collections.no')#
		</label>
	</div>

	<div class="mura-control-group" id="altNameContainer" <cfif NOT rc.feedBean.getDisplayName()> style="display:none;"</cfif>>
		<label>#application.rbFactory.getKeyValue(session.rb,'collections.altname')#</label>
		<input name="#displaNamePrefix#altName" data-displayobjectparam="altName" type="text" value="#esapiEncode('html_attr',rc.feedBean.getAltName())#" maxlength="250">
	</div>

	<div class="mura-control-group">
		<label>
			#application.rbFactory.getKeyValue(session.rb,'collections.cssclass')#
		</label>
		<input name="cssclass"  data-displayobjectparam="cssclass" type="text" value="#esapiEncode('html_attr',rc.feedBean.getCssclass())#" maxlength="255">
	</div>

				<div class="mura-control-group">
					<label>
			#application.rbFactory.getKeyValue(session.rb,'collections.viewalllink')#
		</label>
						<input name="viewalllink" data-displayobjectparam="viewallink" type="text" value="#esapiEncode('html_attr',rc.feedBean.getViewAllLink())#" maxlength="255">
	</div>

				<div class="mura-control-group">
					<label>
			#application.rbFactory.getKeyValue(session.rb,'collections.viewalllabel')#
		</label>
					<input name="viewalllabel" data-displayobjectparam="viewalllabel" type="text" value="#esapiEncode('html_attr',rc.feedBean.getViewAllLabel())#" maxlength="100">
	</div>

				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</label>
					<select name="#displaNamePrefix#maxItems" data-displayobjectparam="maxItems">
			<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
			<option value="#m#" <cfif rc.feedBean.getMaxItems() eq m>selected</cfif>>#m#</option>
			</cfloop>
			<option value="100000" <cfif rc.feedBean.getMaxItems() eq 100000>selected</cfif>>All</option>
			</select>
		</div>

		<div class="mura-control-group">
				 <label>#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</label>
					<select name="#displaNamePrefix#nextN" data-displayobjectparam="nextN">
			<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
			<option value="#r#" <cfif r eq rc.feedBean.getNextN()>selected</cfif>>#r#</option>
			</cfloop>
			<option value="100000" <cfif rc.feedBean.getNextN() eq 100000>selected</cfif>>All</option>
			</select>
			</div>

				<div class="mura-control-group" id="availableFields">
						<label>
					<span class="half">Available Fields</span> <span class="half">Selected Fields</span>
				</label>
				<div id="sortableFields">
					<p class="dragMsg">
										<span class="dragFrom half">Drag Fields from Here&hellip;</span><span class="half">&hellip;and Drop Them Here.</span>
					</p>

					<cfset displayList=rc.feedBean.getDisplayList()>
					<cfset availableList=rc.feedBean.getAvailableDisplayList()>

					<ul id="availableListSort" class="displayListSortOptions">
						<cfloop list="#availableList#" index="i">
							<li class="ui-state-default">#trim(i)#</li>
						</cfloop>
					</ul>

					<ul id="displayListSort" class="displayListSortOptions">
						<cfloop list="#displayList#" index="i">
							<li class="ui-state-highlight">#trim(i)#</li>
						</cfloop>
					</ul>
					<input type="hidden" id="displayList" value="#displayList#" name="#displaNamePrefix#displayList"  data-displayobjectparam="displayList"/>
				</div>
				<script>
					jQuery(document).ready(
						function(){
							feedManager.setDisplayListSort();
						}
					);
				</script>
			</div>
			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
	</div> <!-- /.tab-pane -->
</cfif>
<cfif not isObjectInstance>
<div id="tabRss" class="tab-pane">

	<div class="block block-bordered">
		<!-- block header -->
		<div class="block-header">
			<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'collections.rss')#</h3>
		</div> <!-- /.block header -->
		<div class="block-content">

		<cfif rc.feedID neq ''>
			<div class="mura-control-group">
			 <label>#application.rbFactory.getKeyValue(session.rb,'collections.url')#</label>
			 <a title="#application.rbFactory.getKeyValue(session.rb,'collections.view')#" href="#endpoint#/?feedID=#rc.feedBean.getFeedID()#" target="_blank">#endpoint#/?feedID=#rc.feedBean.getFeedID()#</a>
			</div>
		</cfif>

		<div class="mura-control-group">
			<label>#application.rbFactory.getKeyValue(session.rb,'collections.description')#</label>
			<textarea rows="6" name="description">#esapiEncode('html_attr',rc.feedBean.getDescription())#</textarea>
		</div>

		<div class="mura-control-group">
			<label>#application.rbFactory.getKeyValue(session.rb,'collections.allowhtml')#</label>
			<label class="radio inline">
			<input name="allowHTML" type="radio" value="1" <cfif rc.feedBean.getAllowHTML()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
			</label>
			<label class="radio inline">
			<input name="allowHTML" type="radio" value="0" <cfif not rc.feedBean.getAllowHTML()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
			</label>
		</div>

		<div class="mura-control-group">
			<label>#application.rbFactory.getKeyValue(session.rb,'collections.isPublic')#</label>
			<label class="radio inline">
			<input name="isPublic" type="radio" value="1" <cfif rc.feedBean.getIsPublic()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
			</label>
			<label class="radio inline">
			<input name="isPublic" type="radio" value="0" <cfif not rc.feedBean.getIsPublic()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
			</label>
		</div>

		<div class="mura-control-group">
			<label>#application.rbFactory.getKeyValue(session.rb,'collections.version')#</label>
			<select name="version" class="dropdown">
			<cfloop list="RSS 2.0,RSS 0.920" index="v">
			<option value="#v#" <cfif rc.feedBean.getVersion() eq v>selected</cfif>>#v#</option>
			</cfloop>
			</select>
		</div>

		<div class="mura-control-group">
			<label>#application.rbFactory.getKeyValue(session.rb,'collections.language')#</label>
			<input name="lang" type="text" value="#esapiEncode('html_attr',rc.feedBean.getlang())#" maxlength="50">
		</div>

		<cfif application.settingsManager.getSite(rc.siteid).getextranet()>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.access')#</label>
				<label class="checkbox">
					<input name="restricted" type="checkbox" value="1"   onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif rc.feedBean.getrestricted() eq 1>checked </cfif> class="checkbox">
						#application.rbFactory.getKeyValue(session.rb,'collections.restrictaccess')#
				</label>
				<div id="rg" class="mura-control" <cfif rc.feedBean.getrestricted() NEQ 1>style="display:none;"</cfif>>
					<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
					<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
					<option value="RestrictAll" <cfif rc.feedBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>
					<option value="" <cfif rc.feedBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
					</optgroup>
					<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=1</cfquery>
					<cfif rsGroups.recordcount>
					<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
					<cfloop query="rsGroups">
					<option value="#rsGroups.userID#" <cfif listfind(rc.feedBean.getrestrictgroups(),rsGroups.userID)>Selected</cfif>>#rsGroups.groupname#</option>
					</cfloop>
					</optgroup>
					</cfif>
					<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=0</cfquery>
					<cfif rsGroups.recordcount>
					<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
					<cfloop query="rsGroups">
					<option value="#rsGroups.userID#" <cfif listfind(rc.feedBean.getrestrictgroups(),rsGroups.userID)>Selected</cfif>>#rsGroups.groupname#</option>
					</cfloop>
					</optgroup>
					</cfif>
					</select>
				</div> <!-- /##rg.mura-control -->
			</div> <!-- mura-control-group -->
		</cfif>

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.tab-pane -->

<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and rc.feedID neq ''>
	<cfinclude template="dsp_tab_usage.cfm">
</cfif>
</cfif>
</cfoutput>
</cfsavecontent>
<cfsavecontent variable="actionButtons">
<cfoutput>
<div class="mura-actions">
	<div class="clearfix form-actions">
	<cfif rc.feedID eq ''>
		<button class="btn mura-primary" onclick="submitForm(document.forms.form1,'add');"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'collections.add')#</button>
		<input type="hidden" name="feedID" value="">
		<input type="hidden" name="action" value="add">
	<cfelse>
		<cfif rc.compactDisplay neq "true">
			<button class="btn" onclick="submitForm(document.forms.form1,'delete','#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'collections.deletelocalconfirm'))#');return false;"><i class="mi-trash"></i>#application.rbFactory.getKeyValue(session.rb,'collections.delete')#</button>
		</cfif>
		<cfif isObjectInstance>
			<button class="btn" onclick="updateInstanceObject();submitForm(document.forms.form1,'update');return false;"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'collections.update')#</button>
		<cfelse>
			<button class="btn mura-primary" onclick="submitForm(document.forms.form1,'update');return false;"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'collections.update')#</button>
		</cfif>
		<cfif rc.compactDisplay eq "true">
			<input type="hidden" name="homeID" value="#rc.homeID#" />
		</cfif>
		<input type=hidden name="feedID" value="#rc.feedBean.getfeedID()#">
		<input type="hidden" name="action" value="update">
	</cfif>
	<input type="hidden" name="type" value="Local"><input name="isActive" type="hidden" value="1" />
	<input type="hidden" id="instanceParams" value='#rc.feedBean.getInstanceParams()#' name="instanceParams" />
	<input type="hidden" name="assignmentID" value="#esapiEncode('html_attr',rc.assignmentID)#" />
	<input type="hidden" name="orderno" value="#esapiEncode('html_attr',rc.orderno)#" />
	<input type="hidden" name="regionid" value="#esapiEncode('html_attr',rc.regionID)#" />
	<input type=hidden name="instanceid" value="#esapiEncode('html_attr',rc.instanceid)#">
	<input type="hidden" name="closeCompactDisplay" value="#esapiEncode('html_attr',rc.compactDisplay)#" />
	#rc.$.renderCSRFTokens(context=rc.feedBean.getFeedID(),format="form")#
	</div>
</div>
</cfoutput>
</cfsavecontent>
<cfoutput>
<cfif not isObjectInstance>
		<ul class="mura-tabs nav-tabs" data-toggle="tabs">
		<cfloop from="1" to="#listlen(tabList)#" index="t">
		<li<cfif t eq 1> class="active"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
		</cfloop>
		</ul>
		<div class="block-content tab-content">
			#tabContent#
			<div class="load-inline tab-preloader"></div>
			<script>$('.tab-preloader').spin(spinnerArgs2);</script>
		</div>
<cfelse>
	#tabContent#
</cfif>


			#actionButtons#
</div> <!-- /.block-constrain -->
</form>
<!---
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/tab-view.js"></script>'>
--->
<script type="text/javascript">
$searchParams.setSearchButtons();
</script>
</cfoutput>
<cfif rc.compactDisplay eq 'true'>
<cfsavecontent variable="headerStr">
<cfoutput>
<script type="text/javascript">
jQuery(document).ready(function(){
	if (top.location != self.location) {
		if(jQuery("##ProxyIFrame").length){
			jQuery("##ProxyIFrame").load(
				function(){
					<cfif len(rc.assignmentID)>frontEndProxy.post({cmd:'setWidth',width:'configurator'});<cfelse>frontEndProxy.post({cmd:'setWidth',width:'standard'});</cfif>
				}
			);
		} else {
			<cfif len(rc.assignmentID)>frontEndProxy.post({cmd:'setWidth',width:'configurator'});<cfelse>frontEndProxy.post({cmd:'setWidth',width:'standard'});</cfif>
		}
	}
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#headerStr#">
</cfif>

<cfelse>

<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.basic')#,#application.rbFactory.getKeyValue(session.rb,'collections.categorization')#">
<cfset tablist="tabBasic,tabCategorization">
<cfoutput>

<div class="mura-header">
		<cfif rc.feedBean.getIsNew()>
			<h1>#application.rbFactory.getKeyValue(session.rb,'collections.createremotefeed')#</h1>
		<cfelse>
			<h1>#application.rbFactory.getKeyValue(session.rb,'collections.editremotefeed')#</h1>
		</cfif>

		<cfif rc.compactDisplay eq "true">
			<!---
			<div class="nav-module-specific btn-group">
				<a class="btn" onclick="history.go(-1);"><i class="mi-arrow-circle-left"></i>  #application.rbFactory.getKeyValue(session.rb,'collections.back')#</a>
			</div>
		--->
		<cfelse>
			<cfinclude template="dsp_secondary_menu.cfm">
		</cfif>

</div> <!-- /.mura-header -->

<cfif not structIsEmpty(rc.feedBean.getErrors())>
	<div class="alert alert-error"><span>#application.utility.displayErrors(rc.feedBean.getErrors())#</span></div>
</cfif>

<cfif rc.compactDisplay eq "true">
	<div class="alert alert-info"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.globallyappliednotice")#</span></div>
</cfif>

<span id="msg">
#application.pluginManager.renderEvent("onFeedEditMessageRender", event)#
</span>

<form novalidate="novalidate" action="./?muraAction=cFeed.update&siteid=#esapiEncode('url',rc.siteid)#" method="post" name="form1" onsubmit="return validate(this);">

<div class="block block-constrain">
	<cfif rc.feedID neq ''>
		<ul class="navTask nav nav-pills">
		<cfif rc.compactDisplay eq "true">
			<li><a onclick="history.go(-1);">#application.rbFactory.getKeyValue(session.rb,'collections.back')#</a></li>
		</cfif>
		<!--- <li><a title="#application.rbFactory.getKeyValue(session.rb,'collections.view')#" href="#rc.feedBean.getChannelLink()#" target="_blank">#application.rbFactory.getKeyValue(session.rb,'collections.viewfeed')#</a></li> --->
		</ul>
	</cfif>

<cfsavecontent variable='tabContent'>
<div id="tabBasic" class="tab-pane active">
	<div class="block block-bordered">
		<!-- block header -->
		<div class="block-header">
			<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'collections.basic')#</h3>
		</div> <!-- /.block header -->
		<div class="block-content">

			<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.name')#</label>
					<input name="name" type="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'collections.namerequired')#" value="#esapiEncode('html_attr',rc.feedBean.getName())#" maxlength="50">
			</div>
			<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.url')#</label>
					<input name="channelLink" type="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'collections.urlrequired')#" value="#esapiEncode('html_attr',rc.feedBean.getChannelLink())#">
			</div>
			<cfif not rc.$.getContentRenderer().useLayoutManager()>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.viewalllink')#</label>
				<input name="viewalllink" type="text" value="#esapiEncode('html_attr',rc.feedBean.getViewAllLink())#" maxlength="255">
			</div>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.viewalllabel')#</label>
				<input name="viewalllabel" type="text" value="#esapiEncode('html_attr',rc.feedBean.getViewAllLabel())#" maxlength="100">
			</div>
			</cfif>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.isactive')#</label>
				<label class="radio inline">
					<input name="isActive" type="radio" value="1" <cfif rc.feedBean.getIsActive()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
				</label>
				<label class="radio inline">
				<input name="isActive" type="radio" value="0" <cfif not rc.feedBean.getIsActive()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
				</label>
			</div>

			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.ispublic')#</label>
				<label class="radio inline">
				<input name="isPublic" type="radio" value="1" <cfif rc.feedBean.getIsPublic()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
				</label>
				<label class="radio inline">
				<input name="isPublic" type="radio" value="0" <cfif not rc.feedBean.getIsPublic()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
				</label>
			</div>

			<!--- <div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.makedefault')#</label>
				<label class="radio inline">
				<input name="isDefault" type="radio" value="1" <cfif rc.feedBean.getIsDefault()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
				</label>
				<label class="radio inline">
					<input name="isDefault" type="radio" value="0" <cfif not rc.feedBean.getIsDefault()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
				</label>
			</div> --->

			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</label>
				<select name="maxItems">
					<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
					<option value="#m#" <cfif rc.feedBean.getMaxItems() eq m>selected</cfif>>#m#</option>
					</cfloop>
					<option value="100000" <cfif rc.feedBean.getMaxItems() eq 100000>selected</cfif>>ALL</option>
				</select>
				</div>
				<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.version')#</label>
				<select name="version">
					<cfloop list="RSS 0.920,RSS 2.0,Atom" index="v">
					<option value="#v#" <cfif rc.feedBean.getVersion() eq v>selected</cfif>>#v#</option>
					</cfloop>
				</select>

				<cfif len(rc.$.globalConfig('proxyserver')) or len(rc.$.globalConfig('proxyuser'))>
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.authtype')#</label>
					<select name="authtype">
						<option value="DEFAULT">DEFAULT</option>
						<option value="BASIC" <cfif rc.feedBean.getAuthType() eq 'BASIC'>selected</cfif>>BASIC</option>
						<cfif len(rc.$.globalConfig('proxyserver'))>
							<option value="PROXY" <cfif rc.feedBean.getAuthType() eq 'PROXY'>selected</cfif>>PROXY</option>
						</cfif>
						<cfif len(rc.$.globalConfig('proxyuser'))>
							<option value="NTLM" <cfif rc.feedBean.getAuthType() eq 'NTLM'>selected</cfif>>NTLM</option>
						</cfif>
					</select>
				</cfif>
				</div>
			<cfif not rc.$.getContentRenderer().useLayoutManager()>
			<div class="mura-control-group">
			<label>#application.rbFactory.getKeyValue(session.rb,'collections.cssclass')#</label>
			<input name="cssclass"  data-displayobjectparam="cssclass" type="text" value="#esapiEncode('html_attr',rc.feedBean.getCssclass())#" maxlength="255">
			</div>
			</cfif>

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.tab-pane -->

<div id="tabCategorization" class="tab-pane">
	<div class="block block-bordered">
		<!-- block header -->
		<div class="block-header">
			<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'collections.categorization')#</h3>
		</div> <!-- /.block header -->
		<div class="block-content">
			<div  class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.categoryassignments')#</label>
				<div id="mura-list-tree" class="mura-control">
				<cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" nestLevel="0" feedID="#rc.feedID#" feedBean="#rc.feedBean#">
				</div>
			</div>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.tab-pane -->

<cfif listFind(session.mura.memberships,'S2')>
	<cfset tabLabellist=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,'collections.importlocation')) >
	<cfset tabList=listAppend(tabList,"tabImportlocation")>
	<div id="tabImportlocation" class="tab-pane">

		<div class="block block-bordered">
			<!-- block header -->
		<div class="block-header">
			<h3 class="block-title">application.rbFactory.getKeyValue(session.rb,'collections.importlocation')</h3>
			</div> <!-- /.block header -->
			<div class="block-content">

				<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'collections.importlocation')#:</label>
					<span id="move" class="text">
								<cfif rc.feedbean.getparentid() neq ''>"#application.contentManager.getActiveContent(rc.feedBean.getParentID(),rc.feedBean.getSiteID()).getMenuTitle()#"<cfelse>"#application.rbFactory.getKeyValue(session.rb,'collections.noneselected')#"</cfif>
							&nbsp;&nbsp;<a class="btn btn-small"href="javascript:##;" onclick="javascript: feedManager.loadSiteParents('#rc.siteid#','#rc.feedbean.getparentid()#','',1);return false;">#application.rbFactory.getKeyValue(session.rb,'collections.selectnewlocation')#</a>
							<input type="hidden" name="parentid" value="#rc.feedbean.getparentid()#">
					</span>
				</div>

				<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.autoimport')#</label>
				<label class="radio inline">
					<input name="autoImport" type="radio" value="1" <cfif rc.feedBean.getAutoImport()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
				</label>
				<label class="radio inline">
					<input name="autoImport" type="radio" value="0" <cfif not rc.feedBean.getAutoImport()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')#
				</label>
				</div>

			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
	</div> <!-- /.tab-pane -->

</cfif>

<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and rc.feedID neq ''>
	<cfinclude template="dsp_tab_usage.cfm">
</cfif>
</cfsavecontent>

<ul class="mura-tabs nav-tabs" data-toggle="tabs">
	<cfloop from="1" to="#listlen(tabList)#" index="t">
		<li<cfif t eq 1> class="active"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
	</cfloop>
</ul>
	<div class="tab-content block-content">
		#tabContent#
	<div class="load-inline tab-preloader"></div>
	<script>$('.tab-preloader').spin(spinnerArgs2);</script>

		<div class="mura-actions">
			<div class="form-actions">
				<cfif rc.feedID eq ''>
					<button type="button" class="btn mura-primary" onclick="submitForm(document.forms.form1,'add');"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'collections.add')#</button>
					<input type=hidden name="feedID" value="">
					<input type="hidden" name="action" value="add">
				<cfelse>
					<cfif rc.compactDisplay neq "true">
						<button type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'collections.deleteremoteconfirm'))#');"><i class="mi-trash"></i>#application.rbFactory.getKeyValue(session.rb,'collections.delete')#</button>
					</cfif>
					<button type="button" class="btn mura-primary" onclick="submitForm(document.forms.form1,'update');"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'collections.update')#</button>
					<cfif rc.compactDisplay eq "true">
						<input type="hidden" name="homeID" value="#rc.homeID#" />
					</cfif>
					<input type=hidden name="feedID" value="#rc.feedBean.getfeedID()#">
					<input type="hidden" name="action" value="update">
				</cfif>
				<input type=hidden name="instanceid" value="#esapiEncode('html_attr',rc.instanceid)#">
				<input type="hidden" name="closeCompactDisplay" value="#esapiEncode('html_attr',rc.compactDisplay)#" />
				<input type="hidden" name="type" value="Remote">
				#rc.$.renderCSRFTokens(context=rc.feedBean.getFeedID(),format="form")#
				</div>
			</div>

		</div> <!-- /.block-content.tab-content -->
	</div> <!-- /.block-constrain -->
</form>
</cfoutput>
<cfif rc.compactDisplay eq 'true'>
<cfsavecontent variable="headerStr">
<cfoutput>
<script type="text/javascript">
jQuery(document).ready(function(){
	if (top.location != self.location) {
		if(jQuery("##ProxyIFrame").length){
			jQuery("##ProxyIFrame").load(
				function(){
					frontEndProxy.post({cmd:'setWidth',width:'standard'});
				}
			);
		} else {
			frontEndProxy.post({cmd:'setWidth',width:'standard'});
		}
	}
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#headerStr#">
</cfif>
</cfif>
