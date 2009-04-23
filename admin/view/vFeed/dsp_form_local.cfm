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
<cfset options[15][1]="tcontent.contentID^varchar">
<cfset options[15][2]="Content ID"/>
<cfset options[16][1]="tcontent.parentID^varchar">
<cfset options[16][2]="Parent ID"/>
<cfset options[17][1]="tcontent.path^varchar">
<cfset options[17][2]="Path"/>

<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(attributes.siteid)>
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
<cfset criterias[6][1]="Begins">
<cfset criterias[6][2]=application.rbFactory.getKeyValue(session.rb,'params.beginswith')>
<cfset criterias[7][1]="Contains">
<cfset criterias[7][2]=application.rbFactory.getKeyValue(session.rb,'params.contains')>

</cfsilent>


<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'collections.editlocalindex')#</h2>
#application.utility.displayErrors(request.feedBean.getErrors())#
<!--- <cfif attributes.feedID neq ''>
<ul id="navTask">
<li><a title="View" href="http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getContext()#/tasks/feed/?feedID=#attributes.feedID#" target="_blank">View Index</a></li>
</ul></cfif> --->

<!--- <script language="javascript">
function previewFeed(){
	var contentID='';
	var contentFilters= document.getElementById("feedFrm").contentID;
	if(contentFilters != 'undefined'){
	alert(typeof(contentFilters));	
	}else{
	alert("false");	
	}
	/*
	if(typeof($("feedFrm").contentID) != 'undefined'){
		for(var i=0;i<$("feedFrm").contentID.length;i++){
		
		}
	
	}
	*/
	
}
</script>  --->

<form action="index.cfm?fuseaction=cFeed.update&siteid=#attributes.siteid#" method="post" name="form1" id="feedFrm" onsubmit="return validate(this);">

<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.name')#</dt>
<dd><input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'collections.namerequired')#" value="#HTMLEditFormat(request.feedBean.getName())#"></dd>
</dl>
<div id="page_tabView">
<!-- Content Filters -->
<div class="page_aTab">
<cfoutput>
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.choosecontentfromsection')#: <span id="selectFilter"><a href="javascript:;" onclick="javascript: loadSiteFilters('#attributes.siteid#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'collections.selectnewsection')#]</a></span>
</dt>

</cfoutput>
<table id="contentFilters" class="stripe"> 
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

</cfif><dt>#application.rbFactory.getKeyValue(session.rb,'collections.includefeaturesonly')#</dt>
<dd>
<input name="isFeaturesOnly" type="radio" value="1" class="radio" <cfif request.feedBean.getIsFeaturesOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
<input name="isFeaturesOnly" type="radio" value="0" class="radio" <cfif not request.feedBean.getIsFeaturesOnly()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
</dd>
<!---<dt><button onclick="previewFeed();" type="button">Preview Index</button></dt>--->
</dl>
</div>

<div class="page_aTab">
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

<div class="page_aTab">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.altname')#</dt>
<dd><input name="altName" class="text" value="#HTMLEditFormat(request.feedBean.getAltName())#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</dt>
<dd><select name="nextN" class="dropdown">
	<cfloop list="1,2,3,4,5,6,7,8,9,10,15,20,25,50,100" index="r">
	<option value="#r#" <cfif r eq request.feedBean.getNextN()>selected</cfif>>#r#</option>
	</cfloop>
	<option value="100000" <cfif request.feedBean.getNextN() eq 100000>selected</cfif>>ALL</option>
	</select>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</dt>
<dd><select name="maxItems" class="dropdown">
<cfloop list="1,2,3,4,5,6,7,8,9,10,15,20,25,50,100" index="m">
<option value="#m#" <cfif request.feedBean.getMaxItems() eq m>selected</cfif>>#m#</option>
</cfloop>
<option value="100000" <cfif request.feedBean.getMaxItems() eq 100000>selected</cfif>>ALL</option>
</select>
</dd>
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
	</select>
	</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.sortdirection')#</dt>
	<dd>
	<select name="sortDirection" class="dropdown">
		<option value="asc" <cfif request.feedBean.getsortDirection() eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.ascending')#</option>
		<option value="desc" <cfif request.feedBean.getsortDirection() eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.descending')#</option>
	</select>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displayname')#</dt>
<dd>
<input name="displayName" type="radio" value="1" class="radio" <cfif request.feedBean.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
<input name="displayName" type="radio" value="0" class="radio" <cfif not request.feedBean.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displaycomments')#</dt>
<dd>
<input name="displayComments" type="radio" value="1" class="radio" <cfif request.feedBean.getDisplayComments()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
<input name="displayComments" type="radio" value="0" class="radio" <cfif not request.feedBean.getDisplayComments()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displayrating')#</dt>
<dd>
<input name="displayRatings" type="radio" value="1" class="radio" <cfif request.feedBean.getDisplayRatings()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
<input name="displayRatings" type="radio" value="0" class="radio" <cfif not request.feedBean.getDisplayRatings()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
</dd>
</dl>
</div>

<div class="page_aTab">
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
</div>

<cfif attributes.feedID eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'collections.add')#</span></a><input type=hidden name="feedID" value=""><cfelse> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.deletelocalconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'collections.delete')#</span></a> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'collections.update')#</span></a>
<input type=hidden name="feedID" value="#request.feedBean.getfeedID()#"></cfif><input type="hidden" name="action" value=""><input type="hidden" name="type" value="Local"><input name="isActive" type="hidden" value="1" /></form>
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<script type="text/javascript">
<cfif attributes.feedID neq ''>
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.choosecontent'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.display'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.rss'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.usagereport'))#"),0,0,0);
<cfelse>
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.choosecontent'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.advancedfilters'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.display'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.rss'))#"),0,0,0);
</cfif>
setSearchButtons();
</script>		
</cfoutput>