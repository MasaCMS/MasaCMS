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
<cfset crumbdata=application.contentManager.getCrumbList(attributes.contentid,attributes.siteid)>
<cfset request.perm=application.permUtility.getnodeperm(crumbdata)> 
<cfset nodeLevelList="Page,Portal,Calendar,Gallery,Link,File"/>
<cfset hasChangesets=application.settingsManager.getSite(attributes.siteID).getHasChangesets() and attributes.moduleid eq '00000000000000000000000000000000000'>
<cfset stats=request.contentBean.getStats()>
<cfif request.contentBean.getType() eq 'File'>
<cfset rsFile=application.serviceFactory.getBean('fileManager').readMeta(request.contentBean.getFileID())>
<cfset fileExt=rsFile.fileExt>
<cfelse>
<cfset fileExt=''/>
</cfif>
<cfset isActiveRenderered=false>
<cfset request.deletable=((attributes.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all') or (attributes.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(attributes.siteid).getlocking() eq 'none')) and (request.perm eq 'editor' and attributes.contentid neq '00000000000000000000000000000000001') and request.contentBean.getIsLocked() neq 1>
</cfsilent>
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</h2>
<cfif attributes.compactDisplay neq 'true'>
<cfif attributes.moduleid eq '00000000000000000000000000000000000'>#application.contentRenderer.dspZoom(crumbdata,fileExt)#</cfif>
</cfif>
<ul id="navTask">
<!---<cfif request.contentBean.getFilename() neq '' or attributes.contentid eq '00000000000000000000000000000000001'>
	<cfswitch expression="#attributes.type#">
<cfcase value="Page,Portal,Calendar">
<li><a  href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.configBean.getStub()#/#attributes.siteid#/#request.contentBean.getFilename()##iif(request.contentBean.getFilename() neq '',de('/'),de(''))##application.configBean.getIndexFile()#','#request.contentBean.getTargetParams()#');">View Active #attributes.type#</a></li>
</cfcase>
<cfcase value="Link">
<li><a href="javascript:preview('#request.contentBean.getFilename()#');">View Active #attributes.type#</a></li>
</cfcase>
<cfcase value="File">
<li><a  href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/#attributes.siteid#/linkserv/#application.configBean.getIndexFile()#?contentid=#attributes.contentid#');">View Active #attributes.type#</a></li>
</cfcase>
</cfswitch>
</cfif>--->
<cfswitch expression="#attributes.type#">
<cfcase value="Form">
<cfif listFind(session.mura.memberships,'S2IsPrivate')>
<li><a  href="index.cfm?fuseaction=cArch.datamanager&contentid=#URLEncodedFormat(attributes.contentid)#&siteid=#URLEncodedFormat(attributes.siteid)#&topid=#URLEncodedFormat(attributes.topid)#&moduleid=#attributes.moduleid#&type=Form&parentid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</a></li>
</cfif>
</cfcase>
</cfswitch>
	<cfif request.perm neq 'none'><li><a href="index.cfm?fuseaction=cArch.update&action=deletehistall&contentid=#URLEncodedFormat(attributes.contentid)#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&compactDisplay=#attributes.compactDisplay#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.clearversionhistoryconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.clearversionhistory')#</a></li></cfif>
	<cfif request.deletable and attributes.compactDisplay neq 'true'><li><a href="index.cfm?fuseaction=cArch.update&action=deleteall&contentid=#URLEncodedFormat(attributes.contentid)#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&compactDisplay=#attributes.compactDisplay#" 
		<cfif listFindNoCase(nodeLevelList,request.contentBean.getType())>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),request.contentBean.getMenutitle()))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"</cfif> >#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontent')#</a></li></cfif>
	<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')><li><a href="index.cfm?fuseaction=cPerm.main&contentid=#URLEncodedFormat(attributes.contentid)#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li>
	</cfif>
</ul>
</cfoutput>
<cfoutput>
<table class="mura-table-grid stripe">
  <tr><th nowrap class="varWidth">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
<cfif request.contentBean.getType() eq "file" and stats.getMajorVersion()><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#</th></cfif>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.notes')#</th>
<cfif hasChangesets><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.changeset')#</th></cfif> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.status')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.display')#</th>
<cfif request.contentBean.getType() neq "file"><th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.objects')#</th></cfif> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.feature')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.nav')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.update')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.time')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.authoreditor')#</th> </cfoutput>
<th nowrap class="administration">&nbsp;</th> </tr> 
<cfoutput query="request.rshist">
<cfsilent>
<cfif request.rshist.active and request.rshist.approved>
	<cfset isActiveRenderered=true>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.published')>
<cfelseif not request.rshist.approved and len(request.rshist.changesetID)>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.queued')>
<cfelseif not request.rshist.approved>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.draft')>
<cfelse>
	<cfset versionStatus=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.archived')>
</cfif>
</cfsilent> 
<tr><td class="varWidth">
<a title="Edit" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rshist.ContenthistID#&contentid=#request.rshist.ContentID#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&return=hist&compactDisplay=#attributes.compactDisplay#">#HTMLEditFormat(left(request.rshist.menutitle,90))#</a>
</td>
<cfif request.contentBean.getType() eq "file" and stats.getMajorVersion()><td><cfif request.rshist.majorversion>#request.rshist.majorversion#.#request.rshist.minorversion#<cfelse>&nbsp;</cfif></td></cfif>
<td class="title"><cfif request.rsHist.notes neq ''><a class="expand">View&nbsp;Note<span>#application.contentRenderer.setParagraphs(htmleditformat(request.rshist.notes))#</span></a></cfif></td>
<cfif hasChangesets><td class="changeset"><cfif isDate(request.rshist.changesetPublishDate)><a href="##" class="tooltip"><span>#LSDateFormat(request.rshist.changesetPublishDate,"short")#</span></a></cfif>#HTMLEditFormat(request.rshist.changesetName)#</td></cfif> 
<td nowrap class="status">#versionStatus#</td> 
<td class="display<cfif request.rshist.Display eq 2> scheduled</cfif>"> 
	<cfif request.rshist.Display eq 1>
      #application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#
    <cfelseif request.rshist.Display eq 2>
      <a href="##" class="tooltip"><span>#LSDateFormat(request.rshist.displaystart,"short")#&nbsp;-&nbsp;#LSDateFormat(request.rshist.displaystop,"short")#</span></a>
     <cfelse>
       #application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#
     </cfif>
</td>
<cfif request.contentBean.getType() neq "file"><td> #application.rbFactory.getKeyValue(session.rb,'sitemanager.#lcase(request.rshist.inheritobjects)#')#</td></cfif>
<td class="feature<cfif request.rshist.isfeature eq 2>> scheduled</cfif>"> 
	<cfif request.rshist.isfeature eq 1>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#
		<cfelseif request.rshist.isfeature eq 2>
			<a href="##" class="tooltip"><span>#LSDateFormat(request.rshist.featurestart,"short")#&nbsp;-&nbsp;#LSDateFormat(request.rshist.featurestop,"short")#</span></a>
		<cfelse>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#
		</cfif>
</td>
 <td> #application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(request.rshist.isnav)#')#</td>
<td>#LSDateFormat(request.rshist.lastupdate,session.dateKeyFormat)#</td> 
<td>#LSTimeFormat(request.rshist.lastupdate,"short")#</td>
<td>#HTMLEditFormat(request.rshist.lastUpdateBy)#</td> 
<td class="administration"><ul class="three"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rshist.ContenthistID#&contentid=#request.rshist.ContentID#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&return=hist&compactDisplay=#attributes.compactDisplay#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</a></li>
<cfswitch expression="#request.rsHist.type#">
<cfcase value="Page,Portal,Calendar,Gallery">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?previewid=#request.rshist.contenthistid#&contentid=#URLEncodedFormat(attributes.contentid)#','#request.rshist.TargetParams#');">#left(request.rshist.menutitle,90)#</a></li>
</cfcase>
<cfcase value="Link">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="javascript:preview('#request.rshist.filename#');">#left(request.rshist.menutitle,90)#</a></li></li>
</cfcase>
<cfcase value="File">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#request.rshist.fileid#');">#left(request.rshist.menutitle,90)#</a></li>
</cfcase>
</cfswitch>
<cfif not request.rshist.active and (request.perm neq 'none')><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?fuseaction=cArch.update&contenthistid=#request.rshist.ContentHistID#&action=delete&contentid=#URLEncodedFormat(attributes.contentid)#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&compactDisplay=#attributes.compactDisplay#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteversionconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</li></cfif></ul></td></tr></cfoutput></table>
</td></tr></table>