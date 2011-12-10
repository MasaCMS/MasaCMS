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

<cfset tabLabellist="#application.rbFactory.getKeyValue(session.rb,'collections.basic')#,#application.rbFactory.getKeyValue(session.rb,'collections.categorization')#">
<cfset tablist="tabBasic,tabCategorization">
<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'collections.editremotefeed')#</h2>

#application.utility.displayErrors(request.feedBean.getErrors())#
<cfif attributes.feedID neq ''>
<ul id="navTask">
<cfif attributes.compactDisplay eq "true">
		<li><a onclick="history.go(-1);">#application.rbFactory.getKeyValue(session.rb,'collections.back')#</a></li>
</cfif>
<li><a title="#application.rbFactory.getKeyValue(session.rb,'collections.view')#" href="#request.feedBean.getChannelLink()#" target="_blank">#application.rbFactory.getKeyValue(session.rb,'collections.viewfeed')#</a></li>
</ul></cfif>

<cfif attributes.compactDisplay eq "true">
<p class="notice">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.globallyappliednotice")#</p>
</cfif>

<span id="msg">
#application.pluginManager.renderEvent("onFeedEditMessageRender", event)#
</span>

<form novalidate="novalidate" action="index.cfm?fuseaction=cFeed.update&siteid=#URLEncodedFormat(attributes.siteid)#" method="post" name="form1" onsubmit="return validate(this);">
<dl class="oneColumn separate">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.name')#</dt>
<dd><input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'collections.namerequired')#" value="#HTMLEditFormat(request.feedBean.getName())#" maxlength="50"></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'collections.url')#</dt>
<dd><input name="channelLink" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'collections.urlrequired')#" value="#HTMLEditFormat(request.feedBean.getChannelLink())#" maxlength="250"></dd>
</dl>
<p class="divide" /></p>
</cfoutput>
<cfsavecontent variable='tabContent'>
<cfoutput>
<div id="tabBasic">
	<dl class="oneColumn">
	<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</dt>
	<dd><select name="maxItems" class="dropdown">
	<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
	<option value="#m#" <cfif request.feedBean.getMaxItems() eq m>selected</cfif>>#m#</option>
	</cfloop>
	<option value="100000" <cfif request.feedBean.getMaxItems() eq 100000>selected</cfif>>ALL</option>
	</select>
	</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.version')#</dt>
	<dd><select name="version" class="dropdown">
	<cfloop list="RSS 0.920,RSS 2.0,Atom" index="v">
	<option value="#v#" <cfif request.feedBean.getVersion() eq v>selected</cfif>>#v#</option>
	</cfloop>
	</select></dd>
	
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.isactive')#</dt>
	<dd>
	<input name="isActive" type="radio" value="1" <cfif request.feedBean.getIsActive()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
	<input name="isActive" type="radio" value="0" <cfif not request.feedBean.getIsActive()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
	</dd>
	
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.ispublic')#</dt>
	<dd>
	<input name="isPublic" type="radio" value="1" <cfif request.feedBean.getIsPublic()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
	<input name="isPublic" type="radio" value="0" <cfif not request.feedBean.getIsPublic()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
	</dd>
	
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.makedefault')#</dt>
	<dd>
	<input name="isDefault" type="radio" value="1" <cfif request.feedBean.getIsDefault()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
	<input name="isDefault" type="radio" value="0" <cfif not request.feedBean.getIsDefault()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
	</dd>
	
	</dl>
</div>

<div id="tabCategorization">
	<dl class="oneColumn">
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.categoryassignments')#</dt>
	<dd>
	<cf_dsp_categories_nest siteID="#attributes.siteID#" parentID="" nestLevel="0" feedID="#attributes.feedID#">
	<dd>
	</dl>
</div>

<cfif listFind(session.mura.memberships,'S2')>
	<cfset tabLabellist=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,'collections.importlocation')) >
	<cfset tabList=listAppend(tabList,"tabImportlocation")>
	<div id="tabImportlocation">
	<dl class="oneColumn">
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.importlocation')#:<span id="move" class="text"> <cfif request.feedbean.getparentid() neq ''>"#application.contentManager.getActiveContent(request.feedBean.getParentID(),request.feedBean.getSiteID()).getMenuTitle()#"<cfelse>"#application.rbFactory.getKeyValue(session.rb,'collections.noneselected')#"</cfif>
				&nbsp;&nbsp;<a href="javascript:##;" onclick="javascript: loadSiteParents('#attributes.siteid#','#request.feedbean.getparentid()#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'collections.selectnewlocation')#]</a>
				<input type="hidden" name="parentid" value="#request.feedbean.getparentid()#">
		</span>
	</dt>
	
	</dl>
	</div>
</cfif>

<cfif attributes.feedID neq ''>
	<cfinclude template="dsp_tab_usage.cfm">
</cfif>
</cfoutput>
</cfsavecontent>
<cfoutput>
<img class="loadProgress tabPreloader" src="images/progress_bar.gif">
<div class="tabs initActiveTab" style="display:none">
<ul>
<cfloop from="1" to="#listlen(tabList)#" index="t">
<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
</cfloop>
</ul>
#tabContent#
</div>
<div id="actionButtons">
<cfif attributes.feedID eq ''>
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'collections.add')#" />
	<input type=hidden name="feedID" value="">
	<input type="hidden" name="action" value="add">
<cfelse>
	<cfif attributes.compactDisplay neq "true">
		<input type="button" class="submit" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.deleteremoteconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'collections.delete')#" /> 
	</cfif>
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'collections.update')#" />
	<cfif attributes.compactDisplay eq "true">
		<input type="hidden" name="closeCompactDisplay" value="true" />
		<input type="hidden" name="homeID" value="#attributes.homeID#" />
	</cfif>
	<input type=hidden name="feedID" value="#request.feedBean.getfeedID()#">
	<input type="hidden" name="action" value="update">
</cfif>
<input type="hidden" name="type" value="Remote">
</div>
</form>
<!---
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>

<script type="text/javascript">
initTabs(Array(#tablist#),0,0,0);
</script>---></cfoutput>
<cfsavecontent variable="headerStr">
<cfoutput>
<script type="text/javascript">
jQuery(document).ready(function(){
	if (top.location != self.location) {
		if(jQuery("##ProxyIFrame").length){
			jQuery("##ProxyIFrame").load(
				function(){
					frontEndProxy.postMessage("cmd=setWindowMode&mode=standard");
				}
			);	
		} else {
			frontEndProxy.postMessage("cmd=setWindowMode&mode=standard");
		}
	}
});
</script>
</cfoutput>
</cfsavecontent>	
<cfhtmlhead text="#headerStr#">	