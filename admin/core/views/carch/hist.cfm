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
<cfinclude template="ajax.cfm">
<cfsilent>
<cfset crumbdata=application.contentManager.getCrumbList(rc.contentid,rc.siteid)>
<cfset rc.perm=application.permUtility.getnodeperm(crumbdata)> 
<cfset nodeLevelList="Page,Portal,Calendar,Gallery,Link,File"/>
<cfset hasChangesets=application.settingsManager.getSite(rc.siteID).getHasChangesets() and rc.moduleid eq '00000000000000000000000000000000000'>
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
<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</h2>
<cfif rc.compactDisplay neq 'true'>
<cfif rc.moduleid eq '00000000000000000000000000000000000'>#application.contentRenderer.dspZoom(crumbdata,fileExt)#</cfif>
</cfif>
<ul id="navTask">
<!---<cfif rc.contentBean.getFilename() neq '' or rc.contentid eq '00000000000000000000000000000000001'>
	<cfswitch expression="#rc.type#">
<cfcase value="Page,Portal,Calendar">
<li><a  href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.configBean.getStub()#/#rc.siteid#/#rc.contentBean.getFilename()##iif(rc.contentBean.getFilename() neq '',de('/'),de(''))##application.configBean.getIndexFile()#','#rc.contentBean.getTargetParams()#');">View Active #rc.type#</a></li>
</cfcase>
<cfcase value="Link">
<li><a href="##" onclick="return preview('#rc.contentBean.getFilename()#');">View Active #rc.type#</a></li>
</cfcase>
<cfcase value="File">
<li><a  href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/#rc.siteid#/linkserv/#application.configBean.getIndexFile()#?contentid=#rc.contentid#');">View Active #rc.type#</a></li>
</cfcase>
</cfswitch>
</cfif>--->
<cfswitch expression="#rc.type#">
<cfcase value="Form">
<cfif listFind(session.mura.memberships,'S2IsPrivate')>
<li><a  href="index.cfm?muraAction=cArch.datamanager&contentid=#URLEncodedFormat(rc.contentid)#&siteid=#URLEncodedFormat(rc.siteid)#&topid=#URLEncodedFormat(rc.topid)#&moduleid=#rc.moduleid#&type=Form&parentid=#rc.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</a></li>
</cfif>
</cfcase>
</cfswitch>
	<cfif rc.perm neq 'none'><li><a href="index.cfm?muraAction=cArch.update&action=deletehistall&contentid=#URLEncodedFormat(rc.contentid)#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#&compactDisplay=#rc.compactDisplay#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.clearversionhistoryconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.clearversionhistory')#</a></li></cfif>
	<cfif rc.deletable and rc.compactDisplay neq 'true'><li><a href="index.cfm?muraAction=cArch.update&action=deleteall&contentid=#URLEncodedFormat(rc.contentid)#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#&compactDisplay=#rc.compactDisplay#" 
		<cfif listFindNoCase(nodeLevelList,rc.contentBean.getType())>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),rc.contentBean.getMenutitle()))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"</cfif> >#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontent')#</a></li></cfif>
	<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')><li><a href="index.cfm?muraAction=cPerm.main&contentid=#URLEncodedFormat(rc.contentid)#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li>
	</cfif>
</ul>
</cfoutput>
<cfoutput>
<table class="mura-table-grid stripe">
  <tr><th nowrap class="varWidth">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
<cfif rc.contentBean.getType() eq "file" and stats.getMajorVersion()><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#</th></cfif>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.notes')#</th>
<cfif hasChangesets><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.changeset')#</th></cfif> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.status')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.display')#</th>
<cfif rc.contentBean.getType() neq "file"><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.objects')#</th></cfif> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.feature')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.nav')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.update')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.time')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.authoreditor')#</th> </cfoutput>
<th nowrap class="administration">&nbsp;</th> </tr> 
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
<tr><td class="varWidth">
<a title="Edit" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rshist.ContenthistID#&contentid=#rc.rshist.ContentID#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#&return=hist&compactDisplay=#rc.compactDisplay#">#HTMLEditFormat(left(rc.rshist.menutitle,90))#</a>
</td>
<cfif rc.contentBean.getType() eq "file" and stats.getMajorVersion()><td><cfif rc.rshist.majorversion>#rc.rshist.majorversion#.#rc.rshist.minorversion#<cfelse>&nbsp;</cfif></td></cfif>
<td class="title"><cfif rc.rsHist.notes neq ''><a class="expand">View&nbsp;Note<span>#application.contentRenderer.setParagraphs(htmleditformat(rc.rshist.notes))#</span></a></cfif></td>
<cfif hasChangesets><td class="changeset"><cfif isDate(rc.rshist.changesetPublishDate)><a href="##" class="tooltip"><span>#LSDateFormat(rc.rshist.changesetPublishDate,"short")#</span></a></cfif>#HTMLEditFormat(rc.rshist.changesetName)#</td></cfif> 
<td nowrap class="status">#versionStatus#</td> 
<td class="display<cfif rc.rshist.Display eq 2> scheduled</cfif>"> 
	<cfif rc.rshist.Display eq 1>
      #application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#
    <cfelseif rc.rshist.Display eq 2>
      <a href="##" class="tooltip"><span>#LSDateFormat(rc.rshist.displaystart,"short")#&nbsp;-&nbsp;#LSDateFormat(rc.rshist.displaystop,"short")#</span></a>
     <cfelse>
       #application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#
     </cfif>
</td>
<cfif rc.contentBean.getType() neq "file"><td> #application.rbFactory.getKeyValue(session.rb,'sitemanager.#lcase(rc.rshist.inheritobjects)#')#</td></cfif>
<td class="feature<cfif rc.rshist.isfeature eq 2>> scheduled</cfif>"> 
	<cfif rc.rshist.isfeature eq 1>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#
		<cfelseif rc.rshist.isfeature eq 2>
			<a href="##" class="tooltip"><span>#LSDateFormat(rc.rshist.featurestart,"short")#&nbsp;-&nbsp;#LSDateFormat(rc.rshist.featurestop,"short")#</span></a>
		<cfelse>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#
		</cfif>
</td>
 <td> #application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(rc.rshist.isnav)#')#</td>
<td>#LSDateFormat(rc.rshist.lastupdate,session.dateKeyFormat)#</td> 
<td>#LSTimeFormat(rc.rshist.lastupdate,"short")#</td>
<td>#HTMLEditFormat(rc.rshist.lastUpdateBy)#</td> 
<td class="administration"><ul class="three"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rshist.ContenthistID#&contentid=#rc.rshist.ContentID#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#&return=hist&compactDisplay=#rc.compactDisplay#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</a></li>
<cfswitch expression="#rc.rsHist.type#">
<cfcase value="Page,Portal,Calendar,Gallery">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?previewid=#rc.rshist.contenthistid#&contentid=#URLEncodedFormat(rc.contentid)#','#rc.rshist.TargetParams#');">#left(rc.rshist.menutitle,90)#</a></li>
</cfcase>
<cfcase value="Link">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="##" onclick="return preview('#rc.rshist.filename#');">#left(rc.rshist.menutitle,90)#</a></li></li>
</cfcase>
<cfcase value="File">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#rc.rshist.fileid#');">#left(rc.rshist.menutitle,90)#</a></li>
</cfcase>
</cfswitch>
<cfif not rc.rshist.active and (rc.perm neq 'none')><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?muraAction=cArch.update&contenthistid=#rc.rshist.ContentHistID#&action=delete&contentid=#URLEncodedFormat(rc.contentid)#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#&compactDisplay=#rc.compactDisplay#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteversionconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</li></cfif></ul></td></tr></cfoutput></table>
</td></tr></table>