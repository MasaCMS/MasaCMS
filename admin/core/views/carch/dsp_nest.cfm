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
<cfscript>
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
</cfscript>
<cfparam name="attributes.parentid" default="00000000000000000000000000000000001">
<cfparam name="attributes.locking" default="none">
<cfparam name="attributes.isSectionRequest" default="false">
<cfparam name="session.openSectionList" default="">

<cfset rsnest=application.contentManager.getNest(attributes.parentid,session.siteid,attributes.sortBy,attributes.sortDirection)>

<cfset $=request.event.getValue('MuraScope')>

<cfif attributes.nestlevel neq 1>
	<cfset variables.startrow=1>
<cfelse>
	<cfset variables.startrow=attributes.startrow>
</cfif>

<cfset sortable=not attributes.isSectionRequest and attributes.nestlevel eq  1 and attributes.sortby eq 'orderno'>

<cfset currentPos=variables.startrow>

<cfset endRow=iif((currentPos + attributes.nextn) gt rsnest.recordcount,rsnest.recordcount,currentPos + attributes.nextn)>
</cfsilent>
<!--- Start Level UL List--->
<ul<cfif sortable> id='sortableKids'</cfif> class="mura-section">
<cfoutput query="rsnest" startrow="#variables.startrow#" maxrows="#attributes.nextN#">
<cfsilent>
<cfset request.menulist=listappend(request.menulist,rsnest.contentid)>
<cfset isLockedBySomeoneElse=$.siteConfig('hasLockableNodes') and len(rsnest.lockid) and rsnest.lockid neq session.mura.userid>
<cfset attributes.hasKids=application.contentManager.getKidsCount(rsnest.contentid,rsnest.siteid,false)>
<cfset isMore=attributes.hasKids gt attributes.nextN>

<cfset isOpenSection=listFind(session.openSectionList,rsnest.contentid)>

<cfset verdict=application.permUtility.getPerm(rsnest.contentid, attributes.siteid)>

<cfif verdict neq 'deny'>
	<cfif verdict eq 'none'>
		<cfset verdict=attributes.perm>
	</cfif>
<cfelse>
	<cfset verdict = "none">
</cfif>

<cfif attributes.locking neq 'all'>
	<cfset newcontent=verdict>
<cfelseif verdict neq 'none'>
	<cfset newcontent='read'>
<cfelse>
	<cfset newcontent='none'>
</cfif>

<cfset attop=rsnest.currentrow eq 1>

<cfset atbottom=rsnest.currentrow eq rsnest.recordcount>
	
<cfset neworder= ((attributes.parentid neq '00000000000000000000000000000000001' and attributes.locking neq 'all') or (attributes.parentid eq '00000000000000000000000000000000001' and attributes.locking eq 'none')) and attributes.perm eq 'editor'>

<cfset deletable=(((attributes.parentid neq '00000000000000000000000000000000001' and attributes.locking neq 'all') or (attributes.parentid eq '00000000000000000000000000000000001' and attributes.locking eq 'none')) and (verdict eq 'editor'))  and rsnest.IsLocked neq 1>


<cfif (attributes.restricted or rsnest.restricted)>
<cfset variables.restricted=1>
<cfelse>
<cfset variables.restricted=0>
</cfif>

<cfif rsnest.type eq 'File'>
	<cfset icon=application.classExtensionManager.getCustomIconClass(siteid=rsnest.siteid,type=rsnest.type,subtype=rsnest.subtype)>

	<cfif not len(icon)>
		<cfset icon=lcase(rsnest.fileExt)>
	</cfif>
	
	<cfif variables.restricted>
		<cfset icon=icon & " locked">
	</cfif>
<cfelse>
	<cfset icon=application.classExtensionManager.getCustomIconClass(siteid=rsnest.siteid,type=rsnest.type,subtype=rsnest.subtype)>
	<cfif not len(icon)>
		<cfset icon='icon-mura-' & rsnest.type>
	</cfif>

	<cfif variables.restricted>
		<cfset icon="#icon# locked">
	</cfif>
	<cfset icon=icon & " " & rsnest.subtype>
</cfif>
<cfset isFileIcon=rsnest.type eq 'File' and listFirst(icon,"-") neq "icon">
<cfset request.rowNum=request.rowNum+1>
</cfsilent>
<!--- Start LI for content Item --->
<li data-siteid="#esapiEncode('html_attr',rsnest.siteid)#" data-contentid="#rsnest.contentid#" data-contenthistid="#rsnest.contenthistid#" data-sortby="#esapiEncode('html_attr',rsnest.sortby)#" data-sortdirection="#esapiEncode('html_attr',rsnest.sortdirection)#" data-moduleid="#esapiEncode('html_attr',attributes.moduleid)#" data-type="#esapiEncode('html_attr',rsnest.type)#" class="#esapiEncode('html_attr',lcase(rsnest.type))# mura-node-data<cfif variables.restricted> restricted</cfif>" data-csrf="#attributes.muraScope.renderCSRFTOkens(context=rsnest.contentid & 'quickedit',format='url')#">
<cfif variables.restricted><div class="marker"></div></cfif>
<dl>
<dt>
	<!---<cfif (rsnest.type eq 'Page') or  (rsnest.type eq 'Folder')  or  (rsnest.type eq 'Calendar') or (rsnest.type eq 'Gallery')>--->

	
	<a class="add" href="javascript:;" onmouseover="siteManager.showMenu('newContentMenu','#esapiEncode('javascript',newcontent)#',this,'#rsnest.contentid#','#esapiEncode('javascript',attributes.topid)#','#rsnest.parentid#','#esapiEncode('javascript',attributes.siteid)#','#rsnest.type#');"><i class="icon-plus-sign"></i></a>	
	
	<cfif isNumeric(attributes.hasKids) and attributes.hasKids>
		<span <cfif isOpenSection>class="hasChildren open"<cfelse>class="hasChildren closed"</cfif> onclick="return siteManager.loadSiteSection( jQuery(this).parents('li:first') , 1 , true);"></span>
	</cfif>

	<cfsilent>
		<cfif verdict neq 'none' and listFindNoCase("jpg,jpeg,png,gif",listLast(rsnest.assocfilename,"."))>
			<cfset atooltip=true>
			<cfset atitle="<img class='image-preview' src='#$.getURLForImage(fileid=rsnest.fileid,size='small',siteid=rsnest.siteid,fileext=rsnest.fileExt)#'/>">
		<cfelse>
			<cfset atooltip=false>
			<cfset atitle=application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")>
		</cfif>
	</cfsilent>

	<cfif not listFindNoCase('none,read',verdict)>
		<a class="<cfif isFileIcon>file #lcase(icon)#<cfelse>#lcase(icon)#</cfif> title draftprompt" title="#atitle#" href="./?muraAction=cArch.edit&contenthistid=#rsnest.ContentHistID#&contentid=#rsnest.ContentID#&type=#rsnest.type#&parentid=#rsnest.parentID#&topid=#esapiEncode('url',attributes.topid)#&siteid=#esapiEncode('url',attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#esapiEncode('url',attributes.startrow)#"<cfif rsnest.type eq 'File'> data-filetype="#lcase(left(rsnest.fileExt,4))#"</cfif>  <cfif atooltip>rel="tooltip" data-html="true"</cfif>>
	<cfelse>
		<a class="<cfif rsnest.type eq 'File'>file #lcase(icon)#<cfelse>#lcase(icon)#</cfif> title"<cfif rsnest.type eq 'File'> data-filetype="#lcase(left(rsnest.fileExt,4))#"</cfif> <cfif atooltip>rel="tooltip" data-html="true" title="#atitle#"</cfif>>
	</cfif>
	#esapiEncode('html',left(rsnest.menutitle,75))#
	<cfif len(rsnest.menutitle) gt 75>&hellip;</cfif>
	<cfif isMore><span class="hasMore">&nbsp;(#application.rbFactory.getKeyValue(session.rb,"sitemanager.more")#)</span></cfif></a>
	<!--- <div class="mura-title-fade"></div> --->
</dt>	

<cfif attributes.locking neq 'all'>
	<dd class="objects">
		<cfif verdict eq 'editor' and request.hasLayoutObjectsTab>
		<a class="mura-quickEditItem" data-attribute="inheritObjects">
		</cfif>
			<cfif rsnest.inheritObjects eq 'cascade'>
				<i class="icon-arrow-down" title="#rsnest.inheritObjects#"></i>
				<cfelseif rsnest.inheritObjects eq 'reject'>
					<i class="icon-ban-circle" title="#rsnest.inheritObjects#"></i>
				<cfelse>
					<span class="bullet" title="#rsnest.inheritObjects#">&bull;</span>
			</cfif>
			 <span>#rsnest.inheritObjects#</span>
		<cfif verdict eq 'editor' and request.hasLayoutObjectsTab></a></cfif>
	</dd>
	
	<dd class="display<cfif rsnest.Display eq 2 and rsnest.approved> scheduled</cfif>">
		<cfif verdict eq 'editor' and request.hasPublishingTab>
		<a class="mura-quickEditItem" data-attribute="display">
		</cfif>
		
		<cfif rsnest.Display eq 1 and rsnest.approved>
		 <i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#"></i><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#</span> 
		
		<cfelseif rsnest.Display eq 2 and rsnest.approved>
			<cfif not (verdict eq 'editor' and request.hasPublishingTab)>
				<a href="##" rel="tooltip" title="#esapiEncode('html_attr',LSDateFormat(rsnest.displaystart,"short"))#&nbsp;-&nbsp;#LSDateFormat(rsnest.displaystop,"short")#">
			</cfif>
			<i class="icon-calendar"></i>
			<cfif not (verdict eq 'editor' and request.hasPublishingTab)></a></cfif>
		<cfelse>
		<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#"></i><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#</span>
		</cfif>
		<cfif verdict eq 'editor' and request.hasPublishingTab></a></cfif>
	</dd>
	
	<dd class="template">
	  	<cfif verdict eq 'editor' and request.hasLayoutObjectsTab><a class="mura-quickEditItem<cfif len(rsnest.template) or len(rsnest.childtemplate)> template-set</cfif>" data-attribute="template"></cfif>
		<cfif len(rsnest.template) or len(rsnest.template)>
			 <i class="icon-list-alt" title="#rsnest.template#"></i><span>#rsnest.template#</span>
		<cfelse>
			<span class="bullet" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.inherit")#">&bull;</span>
           	<span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.inherit")#</span>
          </cfif>
		<cfif verdict eq 'editor' and request.hasLayoutObjectsTab></a></cfif>
	</dd>
</cfif>
	<dd class="nav">
		 <cfif verdict eq 'editor' and request.hasPublishingTab><a class="mura-quickEditItem" data-attribute="isnav"></cfif>
			 <cfif rsnest.isnav><i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(rsnest.isNav)#")#"></i><cfelse><i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(rsnest.isNav)#")#"></i></cfif>
			 <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(rsnest.isNav)#")#</span>
		<cfif verdict eq 'editor' and request.hasPublishingTab></a></cfif>
	</dd>
    <dd class="updated">#LSDateFormat(rsnest.lastupdate,session.dateKeyFormat)# #LSTimeFormat(rsnest.lastupdate,"medium")#</dd>
    <dd class="actions">
    <ul>
    	<cfif not listFindNoCase('none,read',verdict)>
       <li class="edit<cfif isLockedBySomeoneElse> disabled</cfif>"><a class="draftprompt"  data-siteid="#attributes.siteid#" data-contentid="#rsnest.contentid#" data-contenthistid="#rsnest.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="./?muraAction=cArch.edit&contenthistid=#rsnest.ContentHistID#&contentid=#rsnest.ContentID#&type=#rsnest.type#&parentid=#rsnest.parentID#&topid=#esapiEncode('url',attributes.topid)#&siteid=#esapiEncode('url',attributes.siteid)#&moduleid=#esapiEncode('url',attributes.moduleid)#&startrow=#esapiEncode('url',attributes.startrow)#"><i class="icon-pencil"></i></a></li>
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('#application.settingsManager.getSite(attributes.siteid).getWebPath(complete=1)##$.getURLStem(attributes.siteid,rsNest.filename)#');"><i class="icon-globe"></i></a></li>
	   <li class="version-history"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#" href="./?muraAction=cArch.hist&contentid=#rsnest.ContentID#&type=#rsnest.type#&parentid=#rsnest.parentID#&topid=#esapiEncode('url',attributes.topid)#&siteid=#esapiEncode('url',attributes.siteid)#&moduleid=#esapiEncode('url',attributes.moduleid)#&startrow=#esapiEncode('url',attributes.startrow)#"><i class="icon-book"></i></a></li>
        <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
          <li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#" href="./?muraAction=cPerm.main&contentid=#rsnest.ContentID#&type=#rsnest.type#&parentid=#rsnest.parentID#&topid=#esapiEncode('url',attributes.topid)#&siteid=#esapiEncode('url',attributes.siteid)#&moduleid=#esapiEncode('url',attributes.moduleid)#&startrow=#esapiEncode('url',attributes.startrow)#"><i class="icon-group"></i></a></li>
        <cfelse>
		  <li class="permissions disabled"><a><i class="icon-group"></i></a></li>
		</cfif>
        <cfif deletable and not isLockedBySomeoneElse>
          <li class="delete"><a  title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.delete")#" href="./?muraAction=cArch.update&contentid=#rsnest.ContentID#&type=#rsnest.type#&action=deleteall&topid=#esapiEncode('url',attributes.topid)#&siteid=#esapiEncode('url',attributes.siteid)#&moduleid=#esapiEncode('url',attributes.moduleid)#&parentid=#esapiEncode('url',attributes.parentid)#&startrow=#esapiEncode('url',attributes.startrow)##attributes.muraScope.renderCSRFTokens(context=rsnest.contentid & 'deleteall',format='url')#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),rsnest.menutitle))#',this.href)"><i class="icon-remove-sign"></i></a></li>
          <cfelseif attributes.locking neq 'all'>
          <li class="delete disabled"><a><i class="icon-remove-sign"></i></a></li>
        </cfif>
        <cfelse>
        <li class="edit disabled"><a><i class="icon-pencil"></i></a></li>
		<cfswitch expression="#rsnest.type#">
		<cfcase value="Page,Folder,Calendar,Gallery">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('#application.settingsManager.getSite(attributes.siteid).getWebPath(complete=1)##$.getURLStem(attributes.siteid,rsnest.filename)#','#esapiEncode('javascript',rsnest.targetParams)#'));"><i class="icon-globe"></i></a></li>
		</cfcase>
		<cfcase value="File,Link">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('#application.settingsManager.getSite(attributes.siteid).getWebPath(complete=1)##$.getURLStem(attributes.siteid,"")#index.cfm?LinkServID=#rsnest.contentid#','#esapiEncode('javascript',rsnest.targetParams)#');"><i class="icon-globe"></i></a></li>
		</cfcase>
		</cfswitch>
		<li class="version-history disabled"><a><i class="icon-book"></i></a></li>
		<li class="permissions disabled"><a><i class="icon-group"></i></a></li>
		<li class="delete disabled"><a><i class="icon-remove-sign"></i></a></li>
      </cfif>
		<cfif  ListFindNoCase("Page,Folder,Calendar,Link,File,Gallery",rsnest.type)>
		#application.pluginManager.renderScripts("onContentList",attributes.siteid,attributes.pluginEvent)#
		</cfif>
		<cfset attributes.pluginEvent.setValue('type', rsnest.type)>
        <cfset attributes.pluginEvent.setValue('filename', rsnest.filename)>
        <cfset attributes.pluginEvent.setValue('contentid', rsnest.contentid)>
        <cfset attributes.pluginEvent.setValue('contenthistid', rsnest.contenthistid)>
		#application.pluginManager.renderScripts("on#rsnest.type#List",attributes.siteid,attributes.pluginEvent)#
		#application.pluginManager.renderScripts("on#rsnest.type##rsnest.subtype#List",attributes.siteid,attributes.pluginEvent)#
	</ul>
	</dd>
</dl>
   <cfif ((attributes.hasKids and attributes.nestlevel lt attributes.viewDepth)
   	 or isOpenSection) and attributes.hasKids>
   <cf_dsp_nest parentid="#rsnest.contentid#"  
   locking="#attributes.locking#" 
   nestlevel="#evaluate(attributes.nestlevel + 1)#" 
   perm="#verdict#"
   siteid="#attributes.siteid#"
   topid="#attributes.topid#"
   moduleid="#attributes.moduleid#"
   restricted="#variables.restricted#"
   viewdepth="#attributes.viewDepth#"
   nextn="#attributes.nextN#"
   startrow="#attributes.startrow#"
   sortBy="#attributes.sortBy#"
   sortDirection="#attributes.sortDirection#"
   pluginEvent="#attributes.pluginEvent#"
   muraScope="#attributes.muraScope#">
   </cfif>
   <cfset currentPos=currentPos+1>
   <cfif sortable>
   		<input type="hidden" name="orderid" value="#rsnest.contentID#"/>
   </cfif>
   <!--- Close LI for contentID--->
   </li>
   </cfoutput>
   <!--- Close UL --->
   </ul>
