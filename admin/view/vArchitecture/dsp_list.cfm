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

<cfset crumbdata=application.contentManager.getCrumbList(attributes.topid,attributes.siteid)>

<cfif isdefined('attributes.nextN') and attributes.nextN gt 0>
  <cfset session.mura.nextN=attributes.nextN>
  <cfset attributes.startrow=1>
</cfif>

<cfif not isDefined('attributes.saveSort')>
  <cfset attributes.sortBy=request.rstop.sortBy />
  <cfset attributes.sortDirection=request.rstop.sortDirection />
</cfif>

<cfparam name="attributes.sortBy" default="#request.rstop.sortBy#" />
<cfparam name="attributes.sortDirection" default="#request.rstop.sortDirection#" />
<cfparam name="attributes.sorted" default="false" />
<cfparam name="attributes.lockid" default="" />
<cfparam name="attributes.assignments" default="false" />
<cfparam name="attributes.categoryid" default="" />
<cfparam name="attributes.tag" default="" />
<cfparam name="attributes.type" default="" />
<cfparam name="attributes.page" default="1" />
<cfparam name="attributes.subtype" default="" />
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">

<cfparam name="session.flatViewArgs" default="#structNew()#">
<cfparam name="session.flatViewArgs" default="#structNew()#">

<cfscript>
	if(not structKeyExists(session.flatViewArgs,session.siteid)){
		session.flatViewArgs["#session.siteid#"]=structNew();
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"moduleid")){
		session.flatViewArgs["#session.siteid#"].moduleid=attributes.moduleid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"sortby")){
		session.flatViewArgs["#session.siteid#"].sortby="lastupdate";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"sortdirection")){
		session.flatViewArgs["#session.siteid#"].sortdirection="desc";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"lockid")){
		session.flatViewArgs["#session.siteid#"].lockid=attributes.lockid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"assignments")){
		session.flatViewArgs["#session.siteid#"].assignments=attributes.assignments;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"categoryid")){
		session.flatViewArgs["#session.siteid#"].categoryid=attributes.categoryid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"tag")){
		session.flatViewArgs["#session.siteid#"].tag=attributes.tag;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"page")){
		session.flatViewArgs["#session.siteid#"].page=attributes.page;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"type")){
		session.flatViewArgs["#session.siteid#"].type="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"subtype")){
		session.flatViewArgs["#session.siteid#"].subtype=attributes.subtype;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"report")){
		session.flatViewArgs["#session.siteid#"].report="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"keywords")){
		session.flatViewArgs["#session.siteid#"].keywords="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"tab")){
		session.flatViewArgs["#session.siteid#"].tab=0;
	}
</cfscript>

<cfif not isdefined("url.activeTab")>
	<cfset attributes.activeTab=session.flatViewArgs["#session.siteID#"].tab/>
</cfif>
<cfif isdefined("url.keywords")>
	<cfif session.flatViewArgs["#session.siteID#"].keywords neq url.keywords>
		<cfset session.flatViewArgs["#session.siteID#"].page=1>
	</cfif>
	<cfset session.flatViewArgs["#session.siteID#"].keywords=url.keywords/>
	<cfset session.flatViewArgs["#session.siteID#"].report=""/>
	<cfset session.keywords=url.keywords/>
</cfif>
<cfhtmlhead text='<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-pulse.js?coreversion=#application.coreversion#" type="text/javascript"></script>'>

<cfif isdefined('attributes.orderperm') and (attributes.orderperm eq 'editor' or (attributes.orderperm eq 'author' and application.configBean.getSortPermission() eq "author"))>
	<cflock type="exclusive" name="editingContent#attributes.siteid#" timeout="60">
		
		<cfif attributes.sorted>
			<cfset current=application.serviceFactory.getBean("content").loadBy(contentID=attributes.topID, siteid=attributes.siteID)>
			<cfset current.setSortBy(attributes.sortBy)>
			<cfset current.setSortDirection(attributes.sortDirection)>
			<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
			<cfset variables.pluginEvent.setValue("contentBean")>
			<cfset application.pluginManager.announceEvent("onBeforeContentSort",pluginEvent)>
		</cfif>
		
		<cfif isdefined('attributes.orderid') >
			<cfloop from="1" to="#listlen(attributes.orderid)#" index="i">
				<cfset newOrderNo=(attributes.startrow+i)-1>
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
				update tcontent set orderno= #newOrderNo# where contentid ='#listgetat(attributes.orderid,i)#'
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
		update tcontent set sortBy='#attributes.sortBy#',sortDirection='#attributes.sortDirection#' where contentid ='#attributes.topid#'
		</cfquery>
		<cfif attributes.sortBy eq 'orderno' and  not isdefined('attributes.orderid')>
			<cfset rsSetOrder=application.contentManager.getNest('#attributes.topid#',attributes.siteid,request.rsTop.sortBy,request.rsTop.sortDirection)>
			<cfloop query="rsSetOrder">
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
				update tcontent set orderno= #rsSetOrder.currentrow# where contentid ='#rsSetOrder.contentID#'
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif attributes.sorted>
			<cfset application.pluginManager.announceEvent("onAfterContentSort",pluginEvent)>
		</cfif>
		
		<cfset application.settingsManager.getSite(attributes.siteid).purgeCache()>
	</cflock>
</cfif>
<cfif not len(crumbdata[1].siteid)>
  <cflocation url="index.cfm?fuseaction=cDashboard.main&siteid=#URLEncodedFormat(attributes.siteid)#&span=30" addtoken="false"/>
</cfif>
</cfsilent>

<cfoutput>
<script>	
siteID='#session.siteID#';
<cfif session.copySiteID eq attributes.siteID>
copyContentID = '#session.copyContentID#';
copySiteID = '#session.copySiteID#';
copyAll = '#session.copyAll#';
<cfelse>
copyContentID = '';
copySiteID = '';
copyAll = 'false';
</cfif>
</script>
 
<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sitemanager")#</h2>
<form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
    <!---<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.contentsearch")#</h3>--->
    <input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" align="absmiddle" />
    <input type="button" class="submit" onclick="submitForm(document.forms.siteSearch);" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.search")#" />
    <input type="hidden" name="fuseaction" value="cArch.list">
	<input type="hidden" name="activetab" value="1">
    <input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
    <input type="hidden" name="moduleid" value="#attributes.moduleid#">
</form>


<!---<img class="loadProgress tabPreloader" src="images/progress_bar.gif">--->

<div id="viewTabs" class="tabs initActiveTab" style="display:none">
		<ul>
			<li><a href="##tabArchitectual" onclick="return false;"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.architectural")#</span></a></li>
			<li><a href="##tabFlat" onclick="return false;"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.flat")#</span></a></li>
		</ul>
		<div id="tabArchitectual">
		<div id="gridContainer"><img class="loadProgress" src="images/progress_bar.gif"></div>
		</div>
		
		<div id="tabFlat">
			<img class="loadProgress" src="images/progress_bar.gif">
		</div>
		
</div>
<script type="text/javascript">
var archViewLoaded=false;
var flatViewLoaded=false;

function initFlatViewArgs(){
	return {siteid:'#JSStringFormat(session.siteID)#', 
			moduleid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].moduleid)#', 
			sortby:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].sortby)#', 
			sortdirection:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].sortdirection)#', 
			page:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].page)#',	
			tag:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].tag)#',
			categoryid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].categoryid)#',
			lockid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].lockid)#',
			type:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].type)#',
			subType:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].subtype)#',
			report:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].report)#',
			keywords:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].keywords)#'
			};
}

var flatViewArgs=initFlatViewArgs();

function initSiteManagerTabContent(index){
	
	jQuery.get("./index.cfm","fuseaction=carch.siteManagerTab&tab=" + index);
	
	switch(index){
		case 0:
		if (!archViewLoaded) {
			loadSiteManager('#JSStringFormat(attributes.siteID)#', '#JSStringFormat(attributes.topid)#', '#JSStringFormat(attributes.moduleid)#', '#JSStringFormat(attributes.sortby)#', '#JSStringFormat(attributes.sortdirection)#', '#JSStringFormat(attributes.ptype)#', '#JSStringFormat(attributes.startrow)#');
			archViewLoaded = true;
		}
		break;
		case 1:
		if (!flatViewLoaded) {
			loadSiteFlat(flatViewArgs);
			flatViewLoaded = true;
		}
	}
}

jQuery("##viewTabs").bind( "tabsselect", function(event,ui){
	initSiteManagerTabContent(ui.index)
});	

initSiteManagerTabContent(#attributes.activeTab#);			
</script>
</cfoutput>
<cfinclude template="draftpromptjs.cfm">