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


<cfsilent>
<cfset options=arrayNew(2) />
<cfset criterias=arrayNew(2) />
<cfset rsParams=request.feedBean.getAdvancedParams()/>

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
<cfset options[8][1]="tcontent.metaDesc^varchar">
<cfset options[8][2]=application.rbFactory.getKeyValue(session.rb,'params.metadesc')>
<cfset options[9][1]="tcontent.metaKeywords^varchar">
<cfset options[9][2]=application.rbFactory.getKeyValue(session.rb,'params.metakeywords')>
<cfset options[10][1]="tcontent.type^varchar">
<cfset options[10][2]=application.rbFactory.getKeyValue(session.rb,'params.type')>
<cfset options[11][1]="tcontent.subType^varchar">
<cfset options[11][2]=application.rbFactory.getKeyValue(session.rb,'params.subtype')>
<cfset options[12][1]="tcontenttags.tag^varchar">
<cfset options[12][2]=application.rbFactory.getKeyValue(session.rb,'params.tag')>
<cfset options[13][1]="tcontent.displayStart^timestamp">
<cfset options[13][2]=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')>
<cfset options[14][1]="tcontent.displayStop^timestamp">
<cfset options[14][2]=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')>
<cfset options[15][1]="tcontent.expires^timestamp">
<cfset options[15][2]=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires')>
<cfset options[16][1]="tcontent.contentID^varchar">
<cfset options[16][2]="Content ID"/>
<cfset options[17][1]="tcontent.parentID^varchar">
<cfset options[17][2]="Parent ID"/>
<cfset options[18][1]="tcontent.path^varchar">
<cfset options[18][2]="Path"/>
<cfset options[19][1]="tcontentcategoryassign.categoryID^varchar">
<cfset options[19][2]="Category ID"/>


<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(siteID=attributes.siteid,baseTable="tcontent",activeOnly=true)>
<cfloop query="rsExtend">
<cfset options[rsExtend.currentRow + 17][1]="#rsExtend.attributeID#^varchar">
<cfset options[rsExtend.currentRow + 17][2]="#rsExtend.Type#/#rsExtend.subType# - #rsExtend.attribute#"/>
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

<cfif len(attributes.assignmentID)>
	<cfset rsDisplayObject=application.contentManager.readContentObject(attributes.assignmentID,attributes.regionID,attributes.orderno)>
	<cfset request.feedBean.setInstanceParams(rsDisplayObject.params)>
	
	<cfif not isJson(rsDisplayObject.params)>
		<cfset variables.contentListFields=request.feedBean.getDisplayList()>
			  
		<cfset variables.hasSummary=listFindNoCase("feed_slideshow_no_summary,feed_no_summary",rsDisplayObject.object) and listFindNoCase(variables.contentListFields,"Summary")>
		<cfif variables.hasSummary>
			<cfset  variables.contentListFields=listDeleteAt(variables.contentListFields,arguments.hasSummary)>
		 </cfif>
		
		<cfif listFindNoCase("feed_slideshow_no_summary,feed_slideshow",rsDisplayObject.object)>
			<cfset request.feedBean.setImageSize("medium")>
			<cfset request.feedBean.setImageHeight("AUTO")>	
			<cfset request.feedBean.setImageWidth("AUTO")>		
		</cfif>
		
		<cfset request.feedBean.setDisplayList(variables.contentListFields)>
	<cfelse>
		<cfset request.feedBean.set(deserializeJSON(rsDisplayObject.params))>
	</cfif>
	<cfset displaNamePrefix="instance">
	<cfset isObjectInstance=true>
<cfelse>
	<cfset displaNamePrefix="">
	<cfset isObjectInstance=false>
</cfif>

<cfset tablist="tabChoosecontent,tabAdvancedfilters,tabDisplay,tabRss">
<cfif isObjectInstance>
	<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.choosecontent')#,#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#,#application.rbFactory.getKeyValue(session.rb,'collections.displayinstance')#,#application.rbFactory.getKeyValue(session.rb,'collections.rss')#">
<cfelse>
	<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.choosecontent')#,#application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters')#,#application.rbFactory.getKeyValue(session.rb,'collections.displaydefaults')#,#application.rbFactory.getKeyValue(session.rb,'collections.rss')#">
</cfif>
</cfsilent>

<cfoutput><h2><cfif len(attributes.assignmentID)>#application.rbFactory.getKeyValue(session.rb,'collections.editlocalindexinstance')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'collections.editlocalindex')#</cfif></h2>
#application.utility.displayErrors(request.feedBean.getErrors())#

<cfif attributes.compactDisplay eq "true" and not isObjectInstance>
<p class="notice">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.globallyappliednotice")#</p>
</cfif>

<!-- This is plugin message targeting --->	
<span id="msg">
#application.pluginManager.renderEvent("onFeedEditMessageRender",event)#
</span>

<form novalidate="novalidate" action="index.cfm?fuseaction=cFeed.update&siteid=#URLEncodedFormat(attributes.siteid)#" method="post" name="form1" id="feedFrm" onsubmit="return validate(this);"<cfif len(attributes.assignmentID)> style="width: 412px"</cfif>>
<cfif not isObjectInstance>
	<cfif attributes.compactDisplay eq "true">
	<ul id="navTask">
		<li><a onclick="history.go(-1);">#application.rbFactory.getKeyValue(session.rb,'collections.back')#</a></li>
	</ul>
	</cfif>
	<dl class="oneColumn separate">
	<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.name')#</dt>
	<dd><input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'collections.namerequired')#" value="#HTMLEditFormat(request.feedBean.getName())#" maxlength="50"></dd>
	</dl>
<cfelse>
	<!---<h3>#HTMLEditFormat(request.feedBean.getName())#</h3>--->
	<cfsilent>
		<cfset editlink = "?fuseaction=cFeed.edit">
		<cfset editlink = editlink & "&amp;siteid=" & request.feedBean.getSiteID()>
		<cfset editlink = editlink & "&amp;feedid=" & request.feedBean.getFeedID()>
		<cfset editlink = editlink & "&amp;type=" & request.feedBean.getType()>
		<cfset editlink = editlink & "&amp;homeID=" & attributes.homeID>
		<cfset editlink = editlink & "&amp;compactDisplay=true">
	</cfsilent>
	<ul id="navTask">
		<li><a href="#editlink#">#application.rbFactory.getKeyValue(session.rb,'collections.editdefaultsettings')#</a></li>
	</ul>
</cfif>
</cfoutput>
<!-- Content Filters -->
<cfsavecontent variable="tabContent">
<cfoutput>
<cfif not isObjectInstance>
<div id="tabChoosecontent">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.choosecontentfromsection')#: <span id="selectFilter"><a href="javascript:;" onclick="javascript: loadSiteFilters('#attributes.siteid#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'collections.selectnewsection')#]</a></span>
</dt>
<table id="contentFilters" class="mura-table-grid stripe"> 
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'collections.section')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'collections.type')#</th>
<th>&nbsp;</th>
</tr>
<tbody id="ContentFilters">
<cfif request.rslist.recordcount>
<cfloop query="request.rslist">
<tr id="c#request.rslist.contentID#">
<td class="varWidth">#request.rslist.menuTitle#</td>
<td>#request.rslist.type#</td>
<td class="administration"><input type="hidden" name="contentID" value="#request.rslist.contentid#" /><ul class="clearfix"><li class="delete"><a title="Delete" href="##" onclick="return removeFilter('c#request.rslist.contentid#');">#application.rbFactory.getKeyValue(session.rb,'collections.delete')#</a></li></ul></td>
</tr></cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="4" id="noFilters"><em>#application.rbFactory.getKeyValue(session.rb,'collections.nocontentfilters')#</em></td>
</tr>
</cfif></tbody>
</table>
<cfif application.categoryManager.getCategoryCount(attributes.siteid)>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.categoryfilters')#</dt>
<dd>
<cf_dsp_categories_nest siteID="#attributes.siteID#" parentID="" nestLevel="0" feedID="#attributes.feedID#">
<dd>

</cfif>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.sortby')#</dt>
<dd><select name="sortBy" class="dropdown">
		<option value="lastUpdate" <cfif request.feedBean.getsortBy() eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.lastupdate')#</option>
		<option value="releaseDate" <cfif request.feedBean.getsortBy() eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.releasedate')#</option>
		<option value="displayStart" <cfif request.feedBean.getsortBy() eq 'displayStart'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</option>
		<option value="menuTitle" <cfif request.feedBean.getsortBy() eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.menutitle')#</option>
		<option value="title" <cfif request.feedBean.getsortBy() eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.longtitle')#</option>
		<option value="rating" <cfif request.feedBean.getsortBy() eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.rating')#</option>
		<option value="comments" <cfif request.feedBean.getsortBy() eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.comments')#</option>
		<option value="created" <cfif request.feedBean.getsortBy() eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.created')#</option>
		<option value="orderno" <cfif request.feedBean.getsortBy() eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.orderno')#</option>
		<option value="random" <cfif request.feedBean.getsortBy() eq 'random'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.random')#</option>
		<cfloop query="rsExtend"><option value="#HTMLEditFormat(rsExtend.attribute)#" <cfif request.feedBean.getsortBy() eq rsExtend.attribute>selected</cfif>>#rsExtend.Type#/#rsExtend.subType# - #rsExtend.attribute#</option>
		</cfloop>
	</select>
	</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.sortdirection')#</dt>
	<dd>
	<select name="sortDirection" class="dropdown">
		<option value="asc" <cfif request.feedBean.getsortDirection() eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.ascending')#</option>
		<option value="desc" <cfif request.feedBean.getsortDirection() eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.descending')#</option>
	</select>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.includefeaturesonly')#</dt>
<dd>
<input name="isFeaturesOnly" type="radio" value="1" class="radio" <cfif request.feedBean.getIsFeaturesOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
<input name="isFeaturesOnly" type="radio" value="0" class="radio" <cfif not request.feedBean.getIsFeaturesOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.shownavonly')#</dt>
<dd>
<input name="showNavOnly" type="radio" value="1" class="radio" <cfif request.feedBean.getShowNavOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
<input name="showNavOnly" type="radio" value="0" class="radio" <cfif not request.feedBean.getShowNavOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.showexcludesearch')#</dt>
<dd>
<input name="showExcludeSearch" type="radio" value="1" class="radio" <cfif request.feedBean.getShowExcludeSearch()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
<input name="showExcludeSearch" type="radio" value="0" class="radio" <cfif not request.feedBean.getShowExcludeSearch()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
</dd>
<!---<dt><button onclick="previewFeed();" type="button">Preview Index</button></dt>--->
</dl>
</div>

<div id="tabAdvancedfilters">
<dl class="oneColumn">
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.chooseadvancedfilters')#</dt>
		<dd>
		<ul id="searchParams">
		<cfif not rsParams.recordcount>
		<li><select name="paramRelationship1" style="display:none;" >
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
		<a class="removeCriteria" href="javascript:;" onclick="removeSeachParam(this.parentNode);setSearchButtons();return false;" style="display:none;">#application.rbFactory.getKeyValue(session.rb,'params.removecriteria')#</a>
		<a class="addCriteria" href="javascript:;" onclick="addSearchParam();setSearchButtons();return false;">#application.rbFactory.getKeyValue(session.rb,'params.addcriteria')#</a>
		</li>
		<cfelse>
		<cfloop query="rsParams">
		<li>
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
		<input type="text" name="paramCriteria#rsParams.currentRow#" value="#HTMLEditFormat(rsParams.criteria)#" >
			<a class="removeCriteria" href="javascript:;" onclick="removeSeachParam(this.parentNode);setSearchButtons();return false;">#application.rbFactory.getKeyValue(session.rb,'params.removecriteria')#</a>
		<a class="addCriteria" href="javascript:;" onclick="addSearchParam();setSearchButtons();return false;" >#application.rbFactory.getKeyValue(session.rb,'params.addcriteria')#</a>
		</li>
		</cfloop>
		</cfif>
		</ul>
	</dd>
</dl>
</div>
</cfif>
<div id="tabDisplay">
<dl class="oneColumn" id="configuratorTab">
<cfif isObjectInstance><h4>#HTMLEditFormat(request.feedBean.getName())#</h4></cfif>
	<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</dt>
	<dd><select name="#displaNamePrefix#imageSize" data-displayobjectparam="imageSize" class="dropdown" onchange="if(this.value=='custom'){jQuery('##feedCustomImageOptions').fadeIn('fast')}else{jQuery('##feedCustomImageOptions').hide();jQuery('##feedCustomImageOptions').find(':input').val('AUTO');}">
		<cfloop list="Small,Medium,Large,Custom" index="i">
		<option value="#lcase(i)#"<cfif i eq request.feedBean.getImageSize()> selected</cfif>>#I#</option>
		</cfloop>
	</select>
	</dd>
<dd id="feedCustomImageOptions"<cfif request.feedBean.getImageSize() neq "custom"> style="display:none"</cfif>>
	<dl>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</dt>
	<dd><input name="#displaNamePrefix#imageWidth" data-displayobjectparam="imageWidth" class="text" value="#request.feedBean.getImageWidth()#" /></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</dt>
	<dd><input name="#displaNamePrefix#imageHeight" data-displayobjectparam="imageHeight" class="text" value="#request.feedBean.getImageHeight()#" /></dd>
	</dl>
</dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displayname')#</dt>
<dd>
<input name="#displaNamePrefix#displayName" data-displayobjectparam="displayName" type="radio" value="1" class="radio" onchange="jQuery('##altNameContainer').toggle();"<cfif request.feedBean.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
<input name="#displaNamePrefix#displayName" data-displayobjectparam="displayName" type="radio" value="0" class="radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not request.feedBean.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
</dd>
<span id="altNameContainer"<cfif NOT request.feedBean.getDisplayName()> style="display:none;"</cfif>>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.altname')#</dt>
<dd><input name="#displaNamePrefix#altName" data-displayobjectparam="altName" class="text" value="#HTMLEditFormat(request.feedBean.getAltName())#" maxlength="50"></dd>
</span>

<dt>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</dt>
<dd><select name="#displaNamePrefix#maxItems" data-displayobjectparam="maxItems" class="dropdown">
<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
<option value="#m#" <cfif request.feedBean.getMaxItems() eq m>selected</cfif>>#m#</option>
</cfloop>
<option value="100000" <cfif request.feedBean.getMaxItems() eq 100000>selected</cfif>>ALL</option>
</select>
</dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</dt>
<dd><select name="#displaNamePrefix#nextN" data-displayobjectparam="nextN" class="dropdown">
	<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
	<option value="#r#" <cfif r eq request.feedBean.getNextN()>selected</cfif>>#r#</option>
	</cfloop>
	<option value="100000" <cfif request.feedBean.getNextN() eq 100000>selected</cfif>>ALL</option>
	</select>
</dd>

<dt id="availableFields"><span>Available Fields</span> <span>Selected Fields</span></dt>
<dd>
	<div class="sortableFields">
	<p class="dragMsg"><span class="dragFrom">Drag Fields from Here&hellip;</span><span>&hellip;and Drop Them Here.</span></p>	
	<cfset displayList=request.feedBean.getDisplayList()>
	<cfset availableList=request.feedBean.getAvailableDisplayList()>
					
	<ul id="availableListSort" class="displayListSortOptions">
		<cfloop list="#availableList#" index="i">
			<li class="ui-state-default">#i#</li>
		</cfloop>
	</ul>
					
	<ul id="displayListSort" class="displayListSortOptions">
		<cfloop list="#displayList#" index="i">
			<li class="ui-state-highlight">#i#</li>
		</cfloop>
	</ul>
	<input type="hidden" id="displayList" value="#displayList#" name="#displaNamePrefix#displayList"  data-displayobjectparam="displayList"/>
	</div>	
	<script>
		jQuery(document).ready(
			function(){
				setDisplayListSort();
			}
		);	
	</script>
</dd>
</dl>
</div>
<cfif not isObjectInstance>
	<div id="tabRss">
	<dl class="oneColumn">
	<cfif attributes.feedID neq ''>
	<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.url')#</dt>
	<dd><a title="#application.rbFactory.getKeyValue(session.rb,'collections.view')#" href="http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/feed/?feedID=#attributes.feedID#" target="_blank">http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/feed/?feedID=#attributes.feedID#</a></dd>
	</cfif>
	<dt<cfif attributes.feedID eq ''> class="first"</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.description')#</dt>
	<dd><input name="description" class="text" value="#HTMLEditFormat(request.feedBean.getDescription())#"/></dd> 
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.makedefault')#</dt>
	<dd>
	<input name="isDefault" type="radio" value="1" <cfif request.feedBean.getIsDefault()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
	<input name="isDefault" type="radio" value="0" <cfif not request.feedBean.getIsDefault()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
	</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.isPublic')#</dt>
	<dd>
	<input name="isPublic" type="radio" value="1" <cfif request.feedBean.getIsPublic()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
	<input name="isPublic" type="radio" value="0" <cfif not request.feedBean.getIsPublic()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
	</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.allowhtml')#</dt>
	<dd>
	<input name="allowHTML" type="radio" value="1" <cfif request.feedBean.getAllowHTML()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
	<input name="allowHTML" type="radio" value="0" <cfif not request.feedBean.getAllowHTML()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
	</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.version')#</dt>
	<dd><select name="version" class="dropdown">
	<cfloop list="RSS 2.0,RSS 0.920" index="v">
	<option value="#v#" <cfif request.feedBean.getVersion() eq v>selected</cfif>>#v#</option>
	</cfloop>
	</select>
	</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.language')#</dt>
	<dd><input name="lang" class="text" value="#htmlEditFormat(request.feedBean.getlang())#" maxlength="50">
	</dd>
	<cfif application.settingsManager.getSite(attributes.siteid).getextranet()>
	
	<dt><input name="restricted" type="CHECKBOX" value="1"   onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif request.feedBean.getrestricted() eq 1>checked </cfif> class="checkbox">
		#application.rbFactory.getKeyValue(session.rb,'collections.restrictaccess')#
		<div id="rg"  <cfif request.feedBean.getrestricted() NEQ 1>style="display:none;"</cfif>>
		<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
		<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
		<option value="RestrictAll" <cfif request.feedBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>
		<option value="" <cfif request.feedBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
		</optgroup>
		<cfquery dbtype="query" name="rsGroups">select * from request.rsrestrictgroups where isPublic=1</cfquery>	
		<cfif rsGroups.recordcount>
		<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
		<cfloop query="rsGroups">
		<option value="#rsGroups.userID#" <cfif listfind(request.feedBean.getrestrictgroups(),rsGroups.userID)>Selected</cfif>>#rsGroups.groupname#</option>
		</cfloop>
		</optgroup>
		</cfif>
		<cfquery dbtype="query" name="rsGroups">select * from request.rsrestrictgroups where isPublic=0</cfquery>	
		<cfif rsGroups.recordcount>
		<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
		<cfloop query="rsGroups">
		<option value="#rsGroups.userID#" <cfif listfind(request.feedBean.getrestrictgroups(),rsGroups.userID)>Selected</cfif>>#rsGroups.groupname#</option>
		</cfloop>
		</optgroup>
		</cfif>
		</select>
	
	</div>
	</dt></cfif>
	</dl>
	</div>
	<cfif attributes.feedID neq ''>
	<cfinclude template="dsp_tab_usage.cfm">
	</cfif>
</cfif>
</cfoutput>
</cfsavecontent>
<cfoutput>
<cfif not isObjectInstance>
	<img class="loadProgress tabPreloader" src="images/progress_bar.gif">
	<div class="tabs initActiveTab" style="display:none">
	<ul>
	<cfloop from="1" to="#listlen(tabList)#" index="t">
	<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
	</cfloop>
	</ul>
	#tabContent#
	</div>
<cfelse>
	#tabCOntent#
</cfif>

<input type="hidden" id="instanceParams" value='#request.feedBean.getInstanceParams()#' name="instanceParams" />		
<input type="hidden" name="assignmentID" value="#HTMLEditFormat(attributes.assignmentID)#" />
<input type="hidden" name="orderno" value="#HTMLEditFormat(attributes.orderno)#" />
<input type="hidden" name="regionid" value="#HTMLEditFormat(attributes.regionID)#" />
<!--- Button Begins --->
<div id="actionButtons" class="clearfix">
<cfif attributes.feedID eq ''>
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'collections.add')#" />
	<input type="hidden" name="feedID" value="">
	<input type="hidden" name="action" value="add">
<cfelse>
	<cfif attributes.compactDisplay neq "true">
		<input type="button" class="submit" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.deletelocalconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'collections.delete')#" /> 
	</cfif>
	<cfif isObjectInstance>
		<input type="button" class="submit" onclick="updateInstanceObject();submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'collections.update')#" />
	<cfelse>
		<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'collections.update')#" />
	</cfif>
	<cfif attributes.compactDisplay eq "true">
		<input type="hidden" name="closeCompactDisplay" value="true" />
		<input type="hidden" name="homeID" value="#attributes.homeID#" />
	</cfif>
	<input type=hidden name="feedID" value="#request.feedBean.getfeedID()#">
	<input type="hidden" name="action" value="update">
</cfif>
<input type="hidden" name="type" value="Local"><input name="isActive" type="hidden" value="1" />
</div>
</form>
<!---
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
--->
<script type="text/javascript">
setSearchButtons();
</script>
</cfoutput>

<cfsavecontent variable="headerStr">
<cfoutput>
<script type="text/javascript">
jQuery(document).ready(function(){
	if (top.location != self.location) {
		if(jQuery("##ProxyIFrame").length){
			jQuery("##ProxyIFrame").load(
				function(){
					<cfif len(attributes.assignmentID)>frontEndProxy.postMessage("cmd=setWindowMode&mode=configurator");<cfelse>frontEndProxy.postMessage("cmd=setWindowMode&mode=standard");</cfif>
				}
			);	
		} else {
			<cfif len(attributes.assignmentID)>frontEndProxy.postMessage("cmd=setWindowMode&mode=configurator");<cfelse>frontEndProxy.postMessage("cmd=setWindowMode&mode=standard");</cfif>
		}
	}
});
</script>
</cfoutput>
</cfsavecontent>	
<cfhtmlhead text="#headerStr#">	