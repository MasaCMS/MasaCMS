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
<cfoutput>
<h2><cfif attributes.categoryID neq ''>#application.rbFactory.getKeyValue(session.rb,'categorymanager.editcontentcategory')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'categorymanager.addcontentcategory')#</cfif></h2>
#application.utility.displayErrors(request.categoryBean.getErrors())#

<span id="msg">
#application.pluginManager.renderEvent("onCategoryEditMessageRender", event)#
</span>

<form novalidate="novalidate" action="index.cfm?fuseaction=cCategory.update&siteid=#URLEncodedFormat(attributes.siteid)#" method="post" name="form1" onsubmit="return validate(this);">
<dl class="oneColumn separate">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'categorymanager.name')#</dt>
<dd><input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'categorymanager.namerequired')#" value="#HTMLEditFormat(request.categoryBean.getName())#" maxlength="50"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'categorymanager.urltitle')#</dt>
<dd><input name="urltitle" class="text" value="#HTMLEditFormat(request.categoryBean.getURLTitle())#" maxlength="255"></dd>
<!---
<cfif attributes.categoryID neq ''>
</dl>
<div id="page_tabView">
<div class="page_aTab">
<dl class="oneColumn">
<dt class="first">
<cfelse>
--->
<dt>
<!---</cfif>--->
#application.rbFactory.getKeyValue(session.rb,'categorymanager.parentcategory')#</dt>
<dd><select name="parentID">
<option value="">#application.rbFactory.getKeyValue(session.rb,'categorymanager.primary')#</option>
<cf_dsp_parents siteID="#attributes.siteID#" categoryID="#attributes.categoryID#" parentID="" actualParentID="#attributes.parentID#" nestLevel="1" >
</select></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'categorymanager.isinterestgroup')#</dt>
<dd>
<input name="isInterestGroup" id="isInterestGroupYes" type="radio" value="1" <cfif request.categoryBean.getIsInterestGroup()>checked</cfif>> <label for="isInterestGroupYes">#application.rbFactory.getKeyValue(session.rb,'categorymanager.yes')#</label> 
<input name="isInterestGroup" id="isInterestGroupNo" type="radio" value="0" <cfif not request.categoryBean.getIsInterestGroup()>checked</cfif>> <label for="isInterestGroupNo">#application.rbFactory.getKeyValue(session.rb,'categorymanager.no')#</label>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'categorymanager.allowcontentassignments')#</dt>
<dd>
<input name="isOpen" id="isOpenYes" type="radio" value="1" <cfif request.categoryBean.getIsOpen()>checked</cfif>> <label for="isOpenYes">#application.rbFactory.getKeyValue(session.rb,'categorymanager.yes')#</label> 
<input name="isOpen" id="isOpenNo" type="radio" value="0" <cfif not request.categoryBean.getIsOpen()>checked</cfif>> <label for="isOpenNo">#application.rbFactory.getKeyValue(session.rb,'categorymanager.no')#</label> 
</dd>
<dt>Active?</dt>
<dd>
<input name="isActive" id="isActiveYes" type="radio" value="1" <cfif request.categoryBean.getIsActive()>checked</cfif>> <label for="isActiveYes">#application.rbFactory.getKeyValue(session.rb,'categorymanager.yes')#</label> 
<input name="isActive" id="isActiveNo" type="radio" value="0" <cfif not request.categoryBean.getIsActive()>checked</cfif>> <label for="isActiveNo">#application.rbFactory.getKeyValue(session.rb,'categorymanager.no')#</label> 
</dd>
<!--- <dt>Sort By/Sort Direction:</dt>
<dd>	<select name="sortBy" class="dropdown">
		 <option value="orderno" <cfif request.categoryBean.getSortBy() eq 'orderno'>selected</cfif>>Manually</option>
		<option value="releaseDate" <cfif request.categoryBean.getSortBy() eq 'releaseDate'>selected</cfif>>Release Date</option>
		<option value="lastUpdate" <cfif request.categoryBean.getSortBy() eq 'lastUpdate'>selected</cfif>>Update Date</option>
		<option value="menuTitle" <cfif request.categoryBean.getSortBy() eq 'menuTitle'>selected</cfif>>Menu Title</option>
		<option value="title" <cfif request.categoryBean.getSortBy() eq 'title'>selected</cfif>>Long Title</option>
		</select>
		<select name="sortDirection" class="dropdown">
		<option value="asc" <cfif request.categoryBean.getSortDirection() eq 'asc'>selected</cfif>>Ascending</option>
		<option value="desc" <cfif request.categoryBean.getSortDirection() eq 'desc'>selected</cfif>>Descending</option>
		</select></dd> --->
		
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#</dt>
	<dd>
	<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
	<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
	<option value="" <cfif request.categoryBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
	<option value="RestrictAll" <cfif request.categoryBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>	
	</optgroup>
	<cfquery dbtype="query" name="rsGroups">select * from request.rsrestrictgroups where isPublic=1</cfquery>	
	<cfif rsGroups.recordcount>
	<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
	<cfloop query="rsGroups">
	<option value="#rsGroups.groupname#" <cfif listFindNoCase(request.categoryBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
	</cfloop>
	</optgroup>
	</cfif>
	<cfquery dbtype="query" name="rsGroups">select * from request.rsrestrictgroups where isPublic=0</cfquery>	
	<cfif rsGroups.recordcount>
	<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
	<cfloop query="rsGroups">
	<option value="#rsGroups.groupname#" <cfif listFindNoCase(request.categoryBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
	</cfloop>
	</optgroup>
	</cfif>
	</select></dd>
<dt>CategoryID</dt>
<dd><cfif len(attributes.categoryID) and len(request.categoryBean.getCategoryID())>#request.categoryBean.getCategoryID()#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif></li>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'categorymanager.notes')#</dt>
<dd><textarea name="notes" class="alt">#HTMLEditFormat(request.categoryBean.getNotes())#</textarea></dd>
</dl>

<div id="actionButtons">
<cfif attributes.categoryID eq ''>

<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'categorymanager.add')#" /><input type=hidden name="categoryID" value=""><cfelse> <input type="button" class="submit" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'categorymanager.deleteconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'categorymanager.delete')#" /> <input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'categorymanager.update')#" />
<input type=hidden name="categoryID" value="#request.categoryBean.getCategoryID()#"></cfif>
<input type="hidden" name="action" value="">
</div>
</form>
</cfoutput>
<!---
<cfif attributes.categoryID neq ''>
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfoutput><script type="text/javascript">
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'categorymanager.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'categorymanager.usagereport'))#"),0,0,0);
</script></cfoutput>
</cfif>--->
<!---<ul id="features" style="height:150px;width:200px;">
<cfloop query="request.rslist">
<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
<li id="features_#request.rslist.currentrow#" style="cursor:n-resize">#application.contentRenderer.dspZoom(crumbdata)# #request.rslist.menutitle#<input type="hidden" name="orderID" value="#request.rslist.contentid#"/><input type="hidden" name="orderno" value="#request.rslist.currentRow#"/></li>
</cfloop>
</ul>--->
<!---<cfif request.rslist.recordcount and request.categoryBean.getSortBy() eq 'orderno'>
 <script type="text/javascript">
 // <![CDATA[
   Sortable.create("features",
     {dropOnEmpty:true,containment:["features"],constraint:true});
 // ]]>
 </script>
 </cfif>--->
