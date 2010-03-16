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
<cfhtmlhead text="#session.dateKey#">
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(1,attributes.siteID) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>

<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'user.groupform')#</h2>
<cfif myfusebox.originalfuseaction eq "editgroup" and attributes.userid neq ''>
<ul id="navTask"><li><a href="javascript:extuserselect('#attributes.userid#',1,<cfif listFind(session.mura.memberships,'S2')>1<cfelse>0</cfif>,'#attributes.siteid#')">#application.rbFactory.getKeyValue(session.rb,'user.addmembertogroup')#</a></li></ul></cfif>

    <cfswitch expression="#request.userBean.getperm()#">
	  	<cfcase value="1">
		<!--topid form system groups---><h3><strong>Group:</strong> #request.userBean.getgroupname()#</h3>
		</cfcase><cfdefaultcase>
				<!--top form non-system groups--->

#application.utility.displayErrors(request.userBean.getErrors())#

			 <form action="index.cfm?fuseaction=cPublicUsers.update&userid=#attributes.userid#" enctype="multipart/form-data" method="post" name="form1" class="formclass" onsubmit="return validate(this);">
<cfif rsSubTypes.recordcount>
<div id="page_tabView">
<div class="page_aTab">
</cfif>
<dl class="oneColumn">
<cfif rsNonDefault.recordcount>
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.type')#</dt>
		<dd><select name="subtype" class="dropdown" onchange="resetExtendedAttributes('#request.userBean.getUserID()#','1',this.value,'#application.settingsManager.getSite(attributes.siteID).getPublicUserPoolID()#','#application.configBean.getContext()#','#application.settingsManager.getSite(application.settingsManager.getSite(attributes.siteID).getPublicUserPoolID()).getThemeAssetPath()#');">
			<option value="Default" <cfif  request.userBean.getSubType() eq "Default">selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.default')#</option>
				<cfloop query="rsNonDefault">
					<option value="#rsNonDefault.subtype#" <cfif request.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
				</cfloop>
			</select>
		</dd>
		<cfelse>
			<input type="hidden" name="subtype" value="Default"/>
		</cfif>
		
		<dt <cfif not  rsNonDefault.recordcount>class="first"</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.groupname')#</dt>
<dd><input type="text" class="text" name="groupname" value="#HTMLEditFormat(request.userBean.getgroupname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.groupname required')#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#</dt>
<dd><input type="text" class="text" name="email" value="#HTMLEditFormat(request.userBean.getemail())#" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#"></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'user.tablist')#</dt>
<dd>
<select name="tablist" multiple="true">
<option value=""<cfif not len(request.userBean.getTablist())> selected</cfif>>All</option>
<cfloop list="Basic,Meta Data,Content Objects,Categorization,Related Content,Advanced,Usage Report" index="t">
<option value="#t#"<cfif listFindNoCase(request.userBean.getTablist(),t)> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.#replace(t,' ','','all')#")#</option>
</cfloop>
</select>
</dd>

<dt class="alt"><input type="checkbox" name="contactform" value="#attributes.siteid#" <cfif request.userBean.getcontactform() eq attributes.siteid>checked</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.contactform')#</dt>

<span id="extendSetsBasic"></span>
</dl>

 <cfif rsSubTypes.recordcount>
	</div>
<div id="page_tabView">
<div class="page_aTab">
<span id="extendSetsDefault"></span>	
</div>
</div>

<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfhtmlhead text='<script type="text/javascript" src="js/user.js"></script>'>
<script type="text/javascript">
loadExtendedAttributes('#request.userbean.getUserID()#','1','#request.userbean.getSubType()#','#application.settingsManager.getSite(attributes.siteID).getPublicUserPoolID()#','#application.configBean.getContext()#','#application.settingsManager.getSite(application.settingsManager.getSite(attributes.siteID).getPublicUserPoolID()).getThemeAssetPath()#');	
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))#"),0,0,0);
</script>	
</cfif>

<cfif attributes.userid eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'user.add')#</span></a><cfelse>
					<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','This');"><span>#application.rbFactory.getKeyValue(session.rb,'user.delete')#</span></a> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'user.update')#</span></a>
					</cfif><input type="hidden" name="action" value=""><input type="hidden" name="type" value="1"><input type="hidden" name="contact" value="0">
					<input type="hidden" name="isPublic" value="1">
					<input type="hidden" name="siteid" value="#attributes.siteid#">
		</cfdefaultcase>
			 </cfswitch>
</cfoutput>
				</form>
      <cfif attributes.userid neq ''><cfoutput><h3 class="separate">#application.rbFactory.getKeyValue(session.rb,'user.groupmembers')#</h3> 
        <table class="stripe">
            <tr> 
              <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'user.name')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.email')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.update')#</th>
			  <th>#application.rbFactory.getKeyValue(session.rb,'user.time')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.authoreditor')#</th>
              <th>&nbsp;</th>
            </tr></cfoutput>
          <cfif request.rsgrouplist.recordcount>
            <cfoutput query="request.rsgrouplist" maxrows="#request.nextN.recordsperPage#" startrow="#attributes.startrow#"> 
			  <tr> 
                <td class="varWidth"><a href="index.cfm?fuseaction=#iif(request.rsgrouplist.isPublic,de('cPublicUsers'),de('cPrivateUsers'))#.edituser&userid=#request.rsgrouplist.UserID#&routeid=#attributes.userid#&siteid=#attributes.siteid#">#HTMLEditFormat(lname)#, #HTMLEditFormat(fname)# <cfif company neq ''> (#HTMLEditFormat(company)#)</cfif></a></td>
                <td><cfif request.rsgrouplist.email gt ""><a href="mailto:#request.rsgrouplist.email#">#email#</a><cfelse>&nbsp;</cfif></td>
                <td>#LSDateFormat(lastupdate,session.dateKeyFormat)#</td>
				<td>#LSTimeFormat(lastupdate,"short")#</td>
              <td>#LastUpdateBy#</td>
                <td class="administration"><ul class="group"><li class="edit"><a href="index.cfm?fuseaction=#iif(request.rsgrouplist.isPublic,de('cPublicUsers'),de('cPrivateUsers'))#.edituser&userid=#request.rsgrouplist.UserID#&routeid=#attributes.userid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li><li class="delete"><a href="index.cfm?fuseaction=cPublicUsers.removefromgroup&userid=#request.rsgrouplist.UserID#&routeid=#attributes.userid#&groupid=#attributes.userid#&siteid=#attributes.siteid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.removeconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'user.remove')#</a></li></ul></td>
              </tr>
            </cfoutput> 
	
		<cfelse>
			<tr> 
              <td class="noResults" colspan="6"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.nogroupmembers')#</cfoutput></td>
            </tr>
          </cfif>
		   </table>
      </cfif>
	
	 <cfif request.nextN.numberofpages gt 1>
	  <p class="moreResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.moreresults')#: 
			<cfif request.nextN.currentpagenumber gt 1>
			<a href="index.cfm?fuseaction=cPublicUsers.editgroup&startrow=#request.nextn.previous#&userid=#attributes.userid#&siteid=#attributes.siteid#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'user.prev')#</a> 
			</cfif>
		  <cfloop from="#request.nextn.firstPage#"  to="#request.nextN.lastPage#" index="i"><cfif request.nextN.currentpagenumber eq i> <strong>#i#</strong><cfelse> <a href="index.cfm?fuseaction=cPublicUsers.editgroup&startrow=#evaluate('(#i#*#request.nextN.recordsperpage#)-#request.nextN.recordsperpage#+1')#&userid=#attributes.userid#&siteid=#attributes.siteid#">#i#</a> </cfif></cfloop>
           <cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages>
			<a href="index.cfm?fuseaction=cPublicUsers.editgroup&startrow=#request.nextn.next#&userid=#attributes.userid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'user.next')#&nbsp;&raquo;</a> 
			</cfif> 
		</cfoutput>
	 </p></cfif>