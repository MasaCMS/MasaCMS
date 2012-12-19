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
<cfset event=request.event>
<cfhtmlhead text="#session.dateKey#">
<cfset userPoolID=application.settingsManager.getSite(rc.siteID).getPublicUserPoolID()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=1,siteID=userPoolID,activeOnly=true) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>
<cfoutput>
<!---
<cfsavecontent variable="actionButtons">
<cfoutput>
<div class="alt form-actions">
<cfif rc.userid eq ''>
<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'user.add')#" />
<cfelse>
<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','This');" value="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" /> 
<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
</cfif>
</div>
</cfoutput>
</cfsavecontent>
--->
<h1>#application.rbFactory.getKeyValue(session.rb,'user.groupform')#</h1>

<div id="nav-module-specific" class="btn-group">
  <a class="btn" href="##" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#" onclick="window.history.back(); return false;"><i class="icon-circle-arrow-left"></i> #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#</a>
</div>
<!---
<cfif listLast(request.action,".") eq "editgroup" and rc.userid neq ''>
  <div id="nav-module-specific" class="btn-group">
    <a class="btn" href="javascript:intuserselect('#rc.userid#',1,<cfif listFind(session.mura.memberships,'S2')>1<cfelse>0</cfif>,'#rc.siteid#')">#application.rbFactory.getKeyValue(session.rb,'user.addusertogroup')#</a>
  </div>
</cfif>
--->
</cfoutput>
<cfswitch expression="#rc.userBean.getperm()#">
	  <cfcase value="1">
  		<!---topid form system groups--->
  		<cfoutput>
  		<h2><strong>#application.rbFactory.getKeyValue(session.rb,'user.group')#:</strong> #rc.userBean.getgroupname()#</h2>
  		</cfoutput>
		</cfcase>
		<cfdefaultcase>
		<!---top form non-system groups--->
    <cfoutput>
      
      <cfif not structIsEmpty(rc.userBean.getErrors())>
       <p class="alert  alert-error">#application.utility.displayErrors(rc.userBean.getErrors())#</p>
      </cfif>

     <form class="fieldset-wrap" novalidate="novalidate" action="index.cfm?muraAction=cPublicUsers.update&userid=#URLEncodedFormat(rc.userid)#" enctype="multipart/form-data" method="post" name="form1" onsubmit="return validate(this);">
      <cfif rsSubTypes.recordcount>
        <div class="tabbable tabs-left">
        <ul class="nav nav-tabs tabs initActiveTab">
        <li><a href="##tabBasic" onclick="return false;"><span>#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'user.basic'))#</span></a></li>
        <li id="tabExtendedattributesLI" class="hide"><a href="##tabExtendedattributes" onclick="return false;"><span>#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))#</span></a></li>
        </ul>
        <div class="tab-content">
        <div id="tabBasic" class="tab-pane fade">
      </cfif>
          <div class="fieldset">

          <cfif rsNonDefault.recordcount>
          		<div class="control-group">
                <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.type')#</label>
                <div class="controls">
                  <select name="subtype"  onchange="userManager.resetExtendedAttributes('#rc.userBean.getUserID()#','1',this.value,'#userPoolID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
            			<option value="Default" <cfif  rc.userBean.getSubType() eq "Default">selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.default')#</option>
            				<cfloop query="rsNonDefault">
            					<option value="#rsNonDefault.subtype#" <cfif rc.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
            				</cfloop>
            			</select>
          	     </div>
              </div>
          </cfif>
        		
          <div class="control-group">
            <div class="span6">
                <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.groupname')#</label>
                <div class="controls"><input type="text" class="span12" name="groupname" value="#HTMLEditFormat(rc.userBean.getgroupname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.groupnamerequired')#"></div>
              </div>

            <div class="span6">
                <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.email')#</label>
                <div class="controls"><input type="text" class="span12" name="email" value="#HTMLEditFormat(rc.userBean.getemail())#"></div>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.tablist')#</label>
            <div class="controls">
              <select name="tablist" multiple="true">
              <option value=""<cfif not len(rc.userBean.getTablist())> selected</cfif>>All</option>
              <cfloop list="#application.contentManager.getTabList()#" index="t">
              <option value="#t#"<cfif listFindNoCase(rc.userBean.getTablist(),t)> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.#REreplace(t, "[^\\\w]", "", "all")#")#</option>
              </cfloop>
              </select>
            </div>
          </div>

          <!---
          <div class="control-group">
                <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.contactform')#</label>
                <div class="controls"><ul><cfloop collection="#application.settingsManager.getSites()#" item="site">
           <cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()>
           <li><input type="checkbox" name="ContactForm" value="#site#" <cfif listfind(rc.userBean.getcontactform(),site)>Checked</cfif>> #application.settingsManager.getSite(site).getSite()#</li>
           </cfif></cfloop></ul></div>
              </div>
          --->
          <span id="extendSetsBasic"></span>
         </div>
    
        
          <cfif rsSubTypes.recordcount>
            </div>
            <div id="tabExtendedattributes" class='tab-pane'>
                <span id="extendSetsDefault"></span>
            </div>


            <div class="form-actions">
              <cfif rc.userid eq ''>
              <input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'user.add')#" />
              <cfelse>
              <input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deletegroupconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" />
              <input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
              </cfif>
              <input type="hidden" name="action" value=""><input type="hidden" name="type" value="1"><input type="hidden" name="contact" value="0">
              <input type="hidden" name="isPublic" value="1">
              <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
            </div>
           </div>
        
            <!---
            <cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
            <cfhtmlhead text='<script type="text/javascript" src="assets/js/tab-view.js"></script>'>
            --->
            <cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>
            <script type="text/javascript">
            userManager.loadExtendedAttributes('#rc.userbean.getUserID()#','1','#rc.userbean.getSubType()#','#userPoolID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');	
            //initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))#"),0,0,0);
            </script>	
         <cfelse>
          <div class="form-actions">
            <cfif rc.userid eq ''>
            <input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'user.add')#" />
            <cfelse>
            <input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deletegroupconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" />
            <input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
            </cfif>
            <input type="hidden" name="action" value="">
            <input type="hidden" name="type" value="1">
            <input type="hidden" name="contact" value="0">
            <input type="hidden" name="isPublic" value="1">
            <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
            <input type="hidden" name="returnurl" value="#HTMLEditFormat(rc.returnurl)#">
            <cfif not rsNonDefault.recordcount><input type="hidden" name="subtype" value="Default"/></cfif>
          </div>
       </cfif>
    </cfoutput>
    </form>
  </cfdefaultcase>
</cfswitch>


      <cfif rc.userid neq ''>
      <cfoutput>
      <h2>#application.rbFactory.getKeyValue(session.rb,'user.groupmembers')#</h2> 
        <table class="table table-striped table-condensed table-bordered mura-table-grid">
            <tr> 
              <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'user.name')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.email')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.update')#</th>
			  <th>#application.rbFactory.getKeyValue(session.rb,'user.time')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.authoreditor')#</th>
              <th>&nbsp;</th>
            </tr></cfoutput>
          <cfif rc.rsgrouplist.recordcount>
            <cfoutput query="rc.rsgrouplist" maxrows="#rc.nextN.recordsperPage#" startrow="#rc.startrow#"> 
			  <tr> 
                <td class="var-width"><a href="index.cfm?muraAction=#iif(rc.rsgrouplist.isPublic,de('cPublicUsers'),de('cPrivateUsers'))#.edituser&userid=#rc.rsgrouplist.UserID#&routeid=#rc.userid#&siteid=#URLEncodedFormat(rc.siteid)#">#HTMLEditFormat(rc.rsgrouplist.lname)#, #HTMLEditFormat(rc.rsgrouplist.fname)# <cfif rc.rsgrouplist.company neq ''> (#HTMLEditFormat(rc.rsgrouplist.company)#)</cfif></a></td>
                <td><cfif rc.rsgrouplist.email gt ""><a href="mailto:#rc.rsgrouplist.email#">#email#</a><cfelse>&nbsp;</cfif></td>
                <td>#LSDateFormat(rc.rsgrouplist.lastupdate,session.dateKeyFormat)#</td>
				<td>#LSTimeFormat(rc.rsgrouplist.lastupdate,"short")#</td>
              <td>#rc.rsgrouplist.LastUpdateBy#</td>
                <td class="actions"><ul class="group"><li class="edit"><a href="index.cfm?muraAction=#iif(rc.rsgrouplist.isPublic,de('cPublicUsers'),de('cPrivateUsers'))#.edituser&userid=#rc.rsgrouplist.UserID#&routeid=#rc.userid#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i></a></li><li class="delete"><a href="index.cfm?muraAction=cPublicUsers.removefromgroup&userid=#rc.rsgrouplist.UserID#&routeid=#rc.userid#&groupid=#rc.userid#&siteid=#URLEncodedFormat(rc.siteid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.removeconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li></ul></td>
              </tr>
            </cfoutput> 
	
		<cfelse>
			<tr> 
              <td class="noResults" colspan="6"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.nogroupmembers')#</cfoutput></td>
            </tr>
          </cfif>
		   </table>
      </cfif>
  <cfif rc.nextN.numberofpages gt 1> 
    <cfoutput>
      <cfset args=arrayNew(1)>
    <cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
    <cfset args[2]=rc.nextn.totalrecords>
    <div class="mura-results-wrapper">
    <p class="clearfix search-showing">
      #application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#
    </p> 
    <ul class="pagination">
      <cfif rc.nextN.currentpagenumber gt 1>
        <li>
       <a href="index.cfm?muraAction=cPublicUsers.editgroup&startrow=#rc.nextN.previous#&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'user.prev')#</a>
       </li> 
      </cfif>
      <cfloop from="#rc.nextn.firstPage#"  to="#rc.nextN.lastPage#" index="i">
        <cfif rc.nextN.currentpagenumber eq i><li class="active"><a href="##">#i#</a></li> 
      <cfelse> 
        <li>
        <a href="index.cfm?muraAction=cPublicUsers.editgroup&startrow=#evaluate('(#i#*#rc.nextN.recordsperpage#)-#rc.nextN.recordsperpage#+1')#&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#">#i#</a> 
        </li>
      </cfif></cfloop>
            <cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
      <li>
      <a href="index.cfm?muraAction=cPublicUsers.editgroup&startrow=#rc.nextN.next#&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#">#application.rbFactory.getKeyValue(session.rb,'user.next')#&nbsp;&raquo;</a> 
      </li>
      </cfif>
    </ul>
  </div></cfoutput>
  </cfif>