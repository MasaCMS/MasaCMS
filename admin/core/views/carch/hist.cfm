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
<cfset crumbdata=application.contentManager.getCrumbList(rc.contentid,rc.siteid)>
<cfset rc.perm=application.permUtility.getnodeperm(crumbdata)> 
<cfset nodeLevelList="Page,Folder,Calendar,Gallery,Link,File"/>
<cfset hasChangesets=application.settingsManager.getSite(rc.siteID).getHasChangesets()>
<cfset stats=rc.contentBean.getStats()>
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
<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</h1>

<cfif rc.compactDisplay neq 'true'>
	<cfinclude template="dsp_secondary_menu.cfm">

	<cfif rc.moduleid eq '00000000000000000000000000000000000'>
		#application.contentRenderer.dspZoom(crumbdata=crumbdata,class="navZoom alt")#
	</cfif>
</cfif>

</cfoutput>
<cfoutput>
<table class="table table-striped table-condensed table-bordered mura-table-grid">
<thead>
  <tr><th class="var-width">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
<cfif rc.contentBean.getType() eq "file" and stats.getMajorVersion()><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#</th></cfif>
<th class="notes">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.notes')#</th>
<cfif hasChangesets><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.changeset')#</th></cfif> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.status')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.display')#</th>
<cfif rc.contentBean.getType() neq "file"><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.objects')#</th></cfif> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.feature')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.nav')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.update')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.time')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.authoreditor')#</th> </cfoutput>
<th nowrap class="actions">&nbsp;</th>
</tr> 
</thead>
<tbody>
<cfoutput query="rc.rshist">
<cfsilent>
<cfif rc.rshist.active and rc.rshist.approved>
	<cfset isActiveRenderered=true>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.published')>
<cfelseif not rc.rshist.approved and len(rc.rshist.changesetID)>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.queued')>
<cfelseif not rc.rshist.approved>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.draft')>
<cfelse>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.archived')>
</cfif>
</cfsilent> 
<tr>
<td class="title var-width">
	<a title="Edit" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rshist.ContenthistID#&contentid=#rc.rshist.ContentID#&type=#URLEncodedFormat(rc.type)#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#URLEncodedFormat(rc.startrow)#&moduleid=#URLEncodedFormat(rc.moduleid)#&return=hist&compactDisplay=#URLEncodedFormat(rc.compactdisplay)#">#HTMLEditFormat(left(rc.rshist.menutitle,90))#</a>
</td>
<cfif rc.contentBean.getType() eq "file" and stats.getMajorVersion()>
	<td>
	<cfif rc.rshist.majorversion>
		#rc.rshist.majorversion#.#rc.rshist.minorversion#
		<cfelse>&nbsp;
	</cfif>
	</td>
</cfif>
<td class="notes"><cfif rc.rsHist.notes neq ''><a rel="tooltip" data-original-title="#application.contentRenderer.setParagraphs(htmleditformat(rc.rshist.notes))#">View&nbsp;Note</a></cfif></td>
<cfif hasChangesets><td class="changeset"><cfif isDate(rc.rshist.changesetPublishDate)><a href="##" rel="tooltip" title="#HTMLEditFormat(LSDateFormat(rc.rshist.changesetPublishDate,"short"))#"> <i class="icon-question-sign"></i></a></cfif>#HTMLEditFormat(rc.rshist.changesetName)#</td></cfif> 
<td class="status">#versionStatus#</td> 

<td class="display<cfif rc.rshist.Display eq 2> scheduled</cfif>"> 
	<cfif rc.rshist.Display and (rc.rshist.Display eq 1 and rc.rshist.approved)>
		<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#"></i><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</span>
	<cfelseif(rc.rshist.Display eq 2 and rc.rshist.approved and rc.rshist.approved)>#LSDateFormat(rc.rshist.displaystart,"short")# - #LSDateFormat(rc.rshist.displaystop,"short")#
	<cfelse>
		<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#"></i><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</span>
	</cfif>
</td>
<cfif rc.contentBean.getType() neq "file">
	<td class="objects">
	<cfif inheritObjects eq 'cascade'>
				<i class="icon-arrow-down" title="#rc.rshist.inheritobjects#"></i>
				<cfelseif inheritObjects eq 'reject'>
					<i class="icon-ban-circle" title="#rc.rshist.inheritobjects#"></i>
				<cfelse>
					<span class="bullet" title="#rc.rshist.inheritobjects#">&bull;</span>
			</cfif>
			<span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.#lcase(rc.rshist.inheritobjects)#')#</span></td>
</cfif>
<td class="feature<cfif rc.rshist.isfeature eq 2>> scheduled</cfif>"> 
	<cfif rc.rshist.isfeature eq 1>
			<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#
		<cfelseif rc.rshist.isfeature eq 2>
			<a href="##" rel="tooltip" title="#HTMLEditFormat('#LSDateFormat(rc.rshist.featurestart,"short")#&nbsp;-&nbsp;#LSDateFormat(rc.rshist.featurestop,"short")#')#"> <i class="icon-calendar"></i></a>
		<cfelse>
			<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#"></i>
			<span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#</span>
		</cfif>
</td>
<td class="nav-display">
<cfif isnav>
<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(rc.rshist.isnav)#')#"></i>
<cfelse><i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(rc.rshist.isnav)#')#"></i>
</cfif>
<span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(rc.rshist.isnav)#')#</span>
			 </td>
<td class="last-updated">#LSDateFormat(rc.rshist.lastupdate,session.dateKeyFormat)#</td> 
<td class="time">#LSTimeFormat(rc.rshist.lastupdate,"short")#</td>
<td class="user">#HTMLEditFormat(rc.rshist.lastUpdateBy)#</td> 
<td class="actions"><ul><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rshist.ContenthistID#&contentid=#rc.rshist.ContentID#&type=#URLEncodedFormat(rc.type)#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#URLEncodedFormat(rc.startrow)#&moduleid=#URLEncodedFormat(rc.moduleid)#&return=hist&compactDisplay=#URLEncodedFormat(rc.compactdisplay)#"><i class="icon-pencil"></i></a></li>
<cfswitch expression="#rc.rsHist.type#">
<cfcase value="Page,Folder,Calendar,Gallery,Link,File">
	<cfset previewURL='http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,rc.contentBean.getFilename())#?previewid=#rc.rshist.contenthistid#'>
	<cfif rc.compactDisplay eq 'true'>
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="##" onclick="frontEndProxy.post({cmd:'setLocation',location:encodeURIComponent('#JSStringFormat(previewURL)#')});return false;"><i class="icon-globe"></i></a></li>
	<cfelse>
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="##" onclick="return preview('#previewURL#','#rc.rshist.TargetParams#');"><i class="icon-globe"></i></a></li>
	</cfif>
</cfcase>
</cfswitch>

<cfif not rc.rshist.active and (rc.perm neq 'none')><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?muraAction=cArch.update&contenthistid=#rc.rshist.ContentHistID#&action=delete&contentid=#URLEncodedFormat(rc.contentid)#&type=#URLEncodedFormat(rc.type)#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#URLEncodedFormat(rc.startrow)#&moduleid=#URLEncodedFormat(rc.moduleid)#&compactDisplay=#URLEncodedFormat(rc.compactdisplay)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteversionconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li><cfelse><li class="delete disabled"><span><i class="icon-remove-sign"></i></span></li></cfif></ul></td></tr></cfoutput></tbody></table>

<cfif rc.compactDisplay eq "true">
<script type="text/javascript">
jQuery(document).ready(function(){
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
});
</script>
</cfif> 
