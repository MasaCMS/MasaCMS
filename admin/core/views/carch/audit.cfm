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
<cfinclude template="js.cfm">
<cfsilent>
<cfset rc.item=$.getBean('content').loadBy(contenthistid=rc.contenthistid)> 
<cfset crumbdata=application.contentManager.getCrumbList(rc.contentid,rc.siteid)>
<cfset rc.perm=application.permUtility.getnodeperm(crumbdata)> 
<cfset nodeLevelList="Page,Folder,Calendar,Gallery,Link,File"/>
<cfset hasChangesets=application.settingsManager.getSite(rc.siteID).getHasChangesets()>
<cfset hasChangesetAccess=application.permUtility.getModulePerm("00000000000000000000000000000000014","#session.siteid#")>
<cfset stats=rc.contentBean.getStats()>
<cfset poweruser=$.currentUser().isSuperUser() or $.currentUser().isAdminUser()>
<cfset isLocked=$.siteConfig('hasLockableNodes') and len(stats.getLockID()) and stats.getLockType() eq 'node'>
<cfset isLockedBySomeoneElse=isLocked and stats.getLockID() neq session.mura.userid>
<cfif rc.contentBean.getType() eq 'File'>
<cfset rsFile=application.serviceFactory.getBean('fileManager').readMeta(rc.contentBean.getFileID())>
<cfset fileExt=rsFile.fileExt>
<cfelse>
<cfset fileExt=''/>
</cfif>
<cfset isActiveRenderered=false>
<cfset rc.deletable=((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and (rc.perm eq 'editor' and rc.contentid neq '00000000000000000000000000000000001') and rc.contentBean.getIsLocked() neq 1>
</cfsilent>
<cfoutput>
<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.audittrail')#</h1>

<cfif rc.compactDisplay neq 'true'>
	<cfinclude template="dsp_secondary_menu.cfm">

	<cfif rc.moduleid eq '00000000000000000000000000000000000'>
		#$.dspZoom(crumbdata=crumbdata,class="navZoom alt")#
	</cfif>
</cfif>

<cfinclude template="dsp_status.cfm">

<table class="mura-table-grid">
<thead>
<tr>
<cfif application.configBean.getJavaEnabled()>
<th colspan="2"><a class="btn" id="viewDiff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.compare')#</a></th> 
</cfif>
<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
<cfif rc.contentBean.getType() eq "file" and stats.getMajorVersion()><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#</th></cfif>
<th class="notes">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.notes')#</th>
<cfif hasChangesets><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.changeset')#</th></cfif> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.status')#</th>
<!---
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.display')#</th>
<cfif rc.contentBean.getType() neq "file"><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.objects')#</th></cfif> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.feature')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.nav')#</th> 
--->
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.update')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.time')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.authoreditor')#</th>
<th nowrap class="actions">&nbsp;</th> 
</cfoutput>
</tr> 
</thead>
<tbody>
<cfset started=false>
<cfloop condition="not rc.item.getIsNew()">
<cfoutput>
<cfsilent>
<cfif rc.item.getactive() and rc.item.getapproved()>
	<cfset isActiveRenderered=true>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.published')>
<cfelseif listFindNoCase('Pending,Rejected',rc.item.getapprovalstatus())>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.#rc.item.getapprovalstatus()#')>
<cfelseif not rc.item.getapproved() and len(rc.item.getchangesetID())>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.queued')>
<cfelseif not rc.item.getapproved()>
	<cfif rc.item.getApprovalStatus() eq 'Cancelled'>
		<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.canceled')>
	<cfelse>
		<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.draft')>
	</cfif>
<cfelse>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.archived')>
</cfif>
</cfsilent> 
<tr>
<cfif application.configBean.getJavaEnabled()>
<td>
	<input type="radio" name="compare1" value="#rc.item.getContentHistID()#"<cfif not started> checked</cfif>/>
</td>
<td>
	<input type="radio" name="compare2" value="#rc.item.getContentHistID()#"<cfif not started> checked</cfif>/>
</td>
</cfif>
<td class="title var-width">
	<cfif not isLockedBySomeoneElse or poweruser>
	<a title="Edit" href="./?muraAction=cArch.edit&contenthistid=#rc.item.getContenthistID()#&contentid=#rc.item.getContentID()#&type=#esapiEncode('url',rc.type)#&parentid=#esapiEncode('url',rc.parentid)#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&startrow=#esapiEncode('url',rc.startrow)#&moduleid=#esapiEncode('url',rc.moduleid)#&return=hist&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" class="draftprompt"  data-targetversion="true" data-siteid="#rc.item.getSiteID()#" data-contentid="#rc.item.getContentID()#" data-contenthistid="#rc.item.getContentHistID()#">
	</cfif>
	#esapiEncode('html',left(rc.item.getmenutitle(),90))#
	<cfif not isLockedBySomeoneElse or poweruser>
	</a>
	</cfif>
</td>
<cfif rc.contentBean.getType() eq "file" and stats.getMajorVersion()>
	<td>
	<cfif rc.item.getmajorversion()>
		#rc.item.getmajorversion()#.#rc.item.getminorversion()#
		<cfelse>&nbsp;
	</cfif>
	</td>
</cfif>
<td class="notes"><cfif rc.item.getnotes() neq ''><a rel="tooltip" data-original-title="#esapiEncode('html_attr',rc.item.getnotes())#">View&nbsp;Note</a></cfif></td>
<cfif hasChangesets>
	<td class="changeset">
		<cfif len(rc.item.getchangesetID())>
		<cfset changeset=$.getBean('changeset').loadby(changesetID=rc.item.getChangesetID())>
		
		<cfif isDate(changeset.getPublishDate())><a href="##" rel="tooltip" title="#esapiEncode('html_attr',LSDateFormat(changeset.getPublishDate(),"short"))#"> <i class="icon-calendar"></i></a></cfif>
		<cfif hasChangesetAccess>
			<a href="./?muraAction=cChangesets.assignments&siteID=#rc.item.getsiteid()#&changesetID=#rc.item.getchangesetID()#">		#esapiEncode('html',changeset.getName())#
			</a>
		<cfelse>
			#esapiEncode('html',changeset.getName())#
		</cfif>
		</cfif>
	</td>
</cfif> 
<td class="status">#versionStatus#</td>
<!--- 
<td class="display<cfif rc.item.getDisplay() eq 2> scheduled</cfif>"> 
	<cfif rc.item.getDisplay() and (rc.item.getDisplay() eq 1 and rc.item.getapproved())>	
 		<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#"></i><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</span>
 	<cfelseif(rc.item.getDisplay() eq 2 and rc.item.getapproved() and rc.item.getapproved())>#LSDateFormat(rc.item.getdisplaystart(),"short")# - #LSDateFormat(rc.item.getdisplaystop(),"short")#	
  <cfelse>
    <i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#"></i><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</span>
  </cfif>
</td>

<cfif rc.contentBean.getType() neq "file">
	<td class="objects">
	<cfif rc.item.getinheritObjects() eq 'cascade'>
				<i class="icon-arrow-down" title="#rc.item.getinheritobjects()#"></i>
				<cfelseif rc.item.getinheritObjects() eq 'reject'>
					<i class="icon-ban-circle" title="#rc.item.getinheritobjects()#"></i>
				<cfelse>
					<span class="bullet" title="#rc.item.getinheritobjects()#">&bull;</span>
			</cfif>
			<span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.#lcase(rc.item.getinheritobjects())#')#</span></td>
</cfif>
<td class="feature<cfif rc.item.getisfeature() eq 2>> scheduled</cfif>"> 
	<cfif rc.item.getisfeature() eq 1>
			<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#
		<cfelseif rc.item.getisfeature() eq 2>
			<a href="##" rel="tooltip" title="#esapiEncode('html_attr','#LSDateFormat(rc.item.getfeaturestart(),"short")#&nbsp;-&nbsp;#LSDateFormat(rc.item.getfeaturestop(),"short")#')#"> <i class="icon-calendar"></i></a>
		<cfelse>
			<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#"></i>
			<span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#</span>
		</cfif>
</td>

<td class="nav-display">
<cfif rc.item.getisnav()>
<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(rc.item.getisnav())#')#"></i>
<cfelse><i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(rc.item.getisnav())#')#"></i>
</cfif>
<span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(rc.item.getisnav())#')#</span>
</td>
--->
<td class="last-updated">#LSDateFormat(rc.item.getlastupdate(),session.dateKeyFormat)#</td> 
<td class="time">#LSTimeFormat(rc.item.getlastupdate(),"short")#</td>
<td class="user">#esapiEncode('html',rc.item.getlastUpdateBy())#</td> 
<td class="actions"><ul>
	<cfif not isLockedBySomeoneElse or poweruser>
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" href="./?muraAction=cArch.edit&contenthistid=#rc.item.getContenthistID()#&contentid=#rc.item.getContentID()#&type=#esapiEncode('url',rc.type)#&parentid=#esapiEncode('url',rc.parentid)#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&startrow=#esapiEncode('url',rc.startrow)#&moduleid=#esapiEncode('url',rc.moduleid)#&return=hist&compactDisplay=#esapiEncode('url',rc.compactDisplay)#" class="draftprompt" data-targetversion="true" data-siteid="#rc.item.getSiteID()#" data-contentid="#rc.item.getContentID()#" data-contenthistid="#rc.item.getContentHistID()#" ><i class="icon-pencil"></i></a>
	<cfelse>
		<li class="edit disabled">
		<i class="icon-pencil"></i>
	</cfif>
	</li>
<cfswitch expression="#rc.item.gettype()#">
<cfcase value="Page,Folder,Calendar,Gallery,Link,File">
	<cfset previewURL='#rc.contentBean.getURL(complete=1,queryString="previewid=#rc.item.getcontenthistid()#")#'>
	<cfif rc.compactDisplay eq 'true'>
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="##" onclick="frontEndProxy.post({cmd:'setLocation',location:encodeURIComponent('#esapiEncode('javascript',previewURL)#')});return false;"><i class="icon-globe"></i></a></li>
	<cfelse>
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="##" onclick="return preview('#previewURL#','#rc.item.getTargetParams()#');"><i class="icon-globe"></i></a></li>
	</cfif>
</cfcase>
</cfswitch>

<cfif (not rc.item.getactive() and (rc.perm neq 'none' and application.configBean.getPurgeDrafts() or (listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')))) and not isLockedBySomeoneElse><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="./?muraAction=cArch.update&contenthistid=#rc.item.getContentHistID()#&action=delete&contentid=#esapiEncode('url',rc.contentid)#&type=#esapiEncode('url',rc.type)#&parentid=#esapiEncode('url',rc.parentid)#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&startrow=#esapiEncode('url',rc.startrow)#&moduleid=#esapiEncode('url',rc.moduleid)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)##rc.$.renderCSRFTokens(context=rc.item.getContentHistID() & 'delete',format='url')#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteversionconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li><cfelse><li class="delete disabled"><span><i class="icon-remove-sign"></i></span></li></cfif></ul></td></tr></cfoutput>
<cfset rc.item=rc.item.getSource()>
<cfset started=true>
</cfloop> 
</tbody></table>


<script type="text/javascript">
jQuery(document).ready(function(){
	<cfif rc.compactDisplay eq "true">
	if (top.location != self.location) {
		if(jQuery("#ProxyIFrame").length){
			jQuery("#ProxyIFrame").load(
				function(){
					frontEndProxy.post({cmd:'setWidth',width:'standard'});
				}
			);	
		} else {
			frontEndProxy.post({cmd:'setWidth',width:'standard'});
		}
	}
	</cfif>

	$('#viewDiff').click(function(e){
		e.preventDefault();
		siteManager.openContentDiff($('input[name="compare1"]:checked').val(),$('input[name="compare2"]:checked').val(),siteid);
	}); 
});
</script>
<cfif $.siteConfig('hasLockableNodes')>
<cfinclude template="draftpromptjs.cfm">	
</cfif>

