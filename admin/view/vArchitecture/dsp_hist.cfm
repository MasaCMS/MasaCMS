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
<cfset crumbdata=application.contentManager.getCrumbList(attributes.contentid,attributes.siteid)>
<cfset request.perm=application.permUtility.getnodeperm(crumbdata)> 

<cfif request.contentBean.getType() eq 'File'>
<cfset rsFile=application.serviceFactory.getBean('fileManager').readMeta(request.contentBean.getFileID())>
<cfset fileExt=rsFile.fileExt>
<cfelse>
<cfset fileExt=''/>
</cfif>

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
<li><a  href="index.cfm?fuseaction=cArch.datamanager&contentid=#attributes.contentid#&siteid=#attributes.siteid#&topid=#attributes.topid#&moduleid=#attributes.moduleid#&type=Form&parentid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</a></li>
</cfcase>
</cfswitch>
	<cfif request.perm neq 'none'><li><a href="index.cfm?fuseaction=cArch.update&action=deletehistall&contentid=#attributes.contentid#&type=#attributes.type#&parentid=#attributes.parentid#&topid=#attributes.topid#&siteid=#attributes.siteid#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.clearversionhistoryconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.clearversionhistory')#</a></li></cfif>
	<cfif request.deletable and attributes.compactDisplay neq 'true'><li><a href="index.cfm?fuseaction=cArch.update&action=deleteall&contentid=#attributes.contentid#&type=#attributes.type#&parentid=#attributes.parentid#&topid=#attributes.topid#&siteid=#attributes.siteid#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontent')#</a></li></cfif>
	<cfif isUserInRole('Admin') or isUserInRole('S2')><li><a href="index.cfm?fuseaction=cPerm.main&contentid=#attributes.ContentID#&type=#attributes.type#&parentid=#attributes.parentID#&topid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li>
	</cfif>
</ul>
</cfoutput>
<cfoutput>
<table class="stripe">
  <tr><th nowrap class="varWidth">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.notes')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.status')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.display')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.objects')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.feature')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.nav')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.update')#</th> 
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.time')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.authoreditor')#</th> </cfoutput>
<th nowrap class="administration">&nbsp;</th> </tr> 
<cfoutput query="request.rshist"> 
<tr><td class="varWidth">
<a title="Edit" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rshist.ContenthistID#&contentid=#request.rshist.ContentID#&type=#attributes.type#&parentid=#attributes.parentid#&topid=#attributes.topid#&siteid=#attributes.siteid#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&return=hist&compactDisplay=#attributes.compactDisplay#">#HTMLEditFormat(left(request.rshist.menutitle,90))#</a>
</td> <td class="title"><cfif request.rsHist.notes neq ''><a class="expand">View&nbsp;Note<span>#application.contentRenderer.setParagraphs(htmleditformat(request.rshist.notes))#</span></a></cfif></td>
<td nowrap class="status"><cfif request.rshist.active and request.rshist.approved>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.published')#<cfelseif not request.rshist.approved>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.draft')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.archived')# </cfif></td> <td> <cfif request.rshist.Display and (request.rshist.Display eq 1 and request.rshist.approved and request.rshist.approved)> #application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')# <cfelseif(request.rshist.Display eq 2 and request.rshist.approved and request.rshist.approved)> #LSDateFormat(request.rshist.displaystart,session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(request.rshist.displaystop,session.dateKeyFormat)# <cfelse> #application.rbFactory.getKeyValue(session.rb,'sitemanager.no')# </cfif></td>
<td> #application.rbFactory.getKeyValue(session.rb,'sitemanager.#lcase(request.rshist.inheritobjects)#')#</td>
<td> #application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(request.rshist.isFeature)#')#</td>
 <td> #application.rbFactory.getKeyValue(session.rb,'sitemanager.#yesnoformat(request.rshist.isnav)#')#</td>
<td>#LSDateFormat(request.rshist.lastupdate,session.dateKeyFormat)#</td> 
<td>#LSTimeFormat(request.rshist.lastupdate,"short")#</td>
<td>#HTMLEditFormat(request.rshist.lastUpdateBy)#</td> 
<td class="administration"><ul class="three"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rshist.ContenthistID#&contentid=#request.rshist.ContentID#&type=#attributes.type#&parentid=#attributes.parentid#&topid=#attributes.topid#&siteid=#attributes.siteid#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&return=hist&compactDisplay=#attributes.compactDisplay#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</a></li>
<cfswitch expression="#request.rsHist.type#">
<cfcase value="Page,Portal,Calendar,Gallery">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?previewid=#request.rshist.contenthistid#&contentid=#attributes.contentid#','#request.rshist.TargetParams#');">#left(request.rshist.menutitle,90)#</a></li>
</cfcase>
<cfcase value="Link">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="javascript:preview('#request.rshist.filename#');">#left(request.rshist.menutitle,90)#</a></li></li>
</cfcase>
<cfcase value="File">
<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.preview')#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#request.rshist.fileid#');">#left(request.rshist.menutitle,90)#</a></li>
</cfcase>
</cfswitch>
<cfif not request.rshist.active and (request.perm neq 'none')><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?fuseaction=cArch.update&contenthistid=#request.rshist.ContentHistID#&action=delete&contentid=#attributes.contentid#&type=#attributes.type#&parentid=#attributes.parentid#&topid=#attributes.topid#&siteid=#attributes.siteid#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&compactDisplay=#attributes.compactDisplay#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteversionconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</li></cfif></ul></td></tr></cfoutput></table>
</td></tr></table>