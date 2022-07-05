<!---
  
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

  You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
  under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
  requires distribution of source code.

  For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
  modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
  version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfset rc.groups=application.permUtility.getGroupList(rc) />
<cfset rc.rslist=rc.groups.privateGroups />
<cfset rc.crumbdata=application.contentManager.getCrumbList(rc.contentid,rc.siteid)>
<cfset chains=$.getBean('approvalChainManager').getChainFeed(rc.siteID).getIterator()>
<cfset assignment=$.getBean('approvalChainAssignment').loadBy(siteID=rc.siteID, contentID=rc.contentID)>
<cfset isModule=(rc.moduleid eq rc.contentid) or rc.contentid eq '00000000000000000000000000000000001'>
<cfset colspan=6>
<cfif rc.moduleID eq '00000000000000000000000000000000000'>
  <cfset colspan=colspan+1>
</cfif>
<cfif chains.hasNext()>
  <cfset colspan=colspan+1>
</cfif>
<cfif chains.hasNext()>
  <cfset adminGroup=rc.$.getBean('group').loadBy(groupname='Admin',isPublic=0)>
</cfif>
<cfoutput>

<div class="mura-header">
  <h1><cfif listFindNoCase('Component,Form',rc.type)>#esapiencode('html',rc.type)#<cfelse>#application.rbFactory.getKeyValue(session.rb,'layout.contentmanager')#</cfif> #application.rbFactory.getKeyValue(session.rb,'permissions')#</h1>
  <div class="nav-module-specific btn-group">
    <a class="btn" href="##" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#" onclick="window.history.back(); return false;"><i class="mi-arrow-circle-left"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#</a>
  </div>

  <cfif rc.moduleid eq '00000000000000000000000000000000000'>#$.dspZoom(crumbdata=rc.crumbdata,class="breadcrumb")#</cfif>

</div> <!-- /.mura-header -->

<div class="block block-constrain">
  <div class="block block-bordered">
    <div class="block-content">
		  <form novalidate="novalidate" method="post" name="form1" action="./?muraAction=cPerm.update&contentid=#esapiEncode('url',rc.contentid)#&parentid=#esapiEncode('url',rc.parentid)#">
		    <h2>#application.rbFactory.getKeyValue(session.rb,'user.adminusergroups')#</h2>
		    <p>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"permissions.nodetext"),rc.rscontent.title)#</p>

		    <cfif chains.hasNext() or rc.rslist.recordcount>
		    <table class="mura-table-grid<cfif rc.rslist.recordcount lt 2> no-stripe</cfif>">
		      <tr>
		        <cfif chains.hasNext()>
		          <th>#application.rbFactory.getKeyValue(session.rb,'permissions.approvalchainexempt')#</th>
		        </cfif>
		        <th>#application.rbFactory.getKeyValue(session.rb,'permissions.editor')#</th>
		        <th>#application.rbFactory.getKeyValue(session.rb,'permissions.author')#</th>
		        <cfif not isModule><th>#application.rbFactory.getKeyValue(session.rb,'permissions.inherit')#</th></cfif>
		        <cfif rc.moduleid eq "00000000000000000000000000000000000"><th>#application.rbFactory.getKeyValue(session.rb,'permissions.readonly')#</th></cfif>
		        <th>#application.rbFactory.getKeyValue(session.rb,'permissions.deny')#</th>
		        <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
		      </tr>

		      <cfif chains.hasNext()>
		        <tr>
		          <td><input name="exemptID" type="checkbox" class="checkbox" value="#adminGroup.getUserID()#" checked disabled></td>
		          <td><input type="radio" class="checkbox" disabled checked></td>
		          <td><input type="radio" class="checkbox"disabled></td>
		          <td><input type="radio" class="checkbox"disabled></td>
		          <cfif not isModule><td><input type="radio" class="checkbox"disabled></td></cfif>
		          <cfif rc.moduleid eq "00000000000000000000000000000000000"><td><input type="radio" class="checkbox" disabled></td></cfif>
		          <td nowrap class="var-width">Admin</td>
		        </tr>
		    </cfif>

		      <cfif rc.rslist.recordcount>
		          <cfloop query="rc.rslist">
								<cfsilent>
			            <cfset perm=application.permUtility.getGroupPerm(rc.rslist.userid,rc.contentid,rc.siteid)/>
									<cfif isModule and listFindNoCase('inherit,none',perm)>
										<cfif rc.moduleid eq "00000000000000000000000000000000000">
											<cfset perm="read">
										<cfelse>
											<cfset perm="deny">
										</cfif>
									</cfif>
								</cfsilent>
		            <tr>
		            <cfif chains.hasNext()><td><input name="exemptID" type="checkbox" class="checkbox" value="#rc.rslist.userid#"<cfif perm eq 'editor' and len(assignment.getExemptID()) and listFindNoCase(assignment.getExemptID(),rc.rslist.userid)> checked</cfif><cfif perm neq 'editor'> disabled</cfif>></td></cfif>
		            <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="editor" <cfif perm eq 'Editor'>checked</cfif>></td>
		            <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="author" <cfif perm eq 'Author'>checked</cfif>></td>
		            <cfif not isModule><td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="none" <cfif perm eq 'None'>checked</cfif><cfif isModule>disabled</cfif>></td></cfif>
		            <cfif rc.moduleid eq "00000000000000000000000000000000000"><td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="read" <cfif perm eq 'Read'>checked</cfif>></td></cfif>
		            <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="deny" <cfif perm eq 'Deny'>checked</cfif>></td>
		            <td nowrap class="var-width">#esapiEncode('html',rc.rslist.GroupName)#</td>
		            </tr>
		        </cfloop>
		    </cfif>
		    </table>
		    <cfelse>
		        <div class="help-block-empty">#application.rbFactory.getKeyValue(session.rb,'permissions.nogroups')#</div>
		    </cfif>

		    <cfset rc.rslist=rc.groups.publicGroups />
		    <h2>#application.rbFactory.getKeyValue(session.rb,'user.membergroups')#</h2>
		    <p>#application.rbFactory.getKeyValue(session.rb,'permissions.memberpermscript')#<br>#application.rbFactory.getKeyValue(session.rb,'permissions.memberpermnodescript')#</p>
		    <cfif rc.rslist.recordcount>
		      <table class="mura-table-grid<cfif rc.rslist.recordcount lt 2> no-stripe</cfif>">
		        <tr>
		        <cfif chains.hasNext()><th>#application.rbFactory.getKeyValue(session.rb,'permissions.approvalchainexempt')#</th></cfif>
		        <th>#application.rbFactory.getKeyValue(session.rb,'permissions.editor')#</th>
		        <th>#application.rbFactory.getKeyValue(session.rb,'permissions.author')#</th>
		        <cfif not isModule><th>#application.rbFactory.getKeyValue(session.rb,'permissions.inherit')#</th></cfif>
		        <cfif rc.moduleid eq "00000000000000000000000000000000000"><th>#application.rbFactory.getKeyValue(session.rb,'permissions.readonly')#</th></cfif>
		        <th>#application.rbFactory.getKeyValue(session.rb,'permissions.deny')#</th>
		        <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
		        </tr>
		      	<cfloop query="rc.rslist">
							<cfsilent>
				   			<cfset perm=application.permUtility.getGroupPerm(rc.rslist.userid,rc.contentid,rc.siteid)/>
								<cfif isModule and listFindNoCase('inherit,none',perm)>
									<cfif isModule and listFindNoCase('inherit,none',perm)>
										<cfif rc.moduleid eq "00000000000000000000000000000000000">
											<cfset perm="read">
										<cfelse>
											<cfset perm="deny">
										</cfif>
									</cfif>
								</cfif>
							</cfsilent>
			        <tr>
			         <cfif chains.hasNext()><td><input name="exemptID" type="checkbox" class="checkbox" value="#rc.rslist.userid#" <cfif perm eq 'editior' and len(assignment.getExemptID()) and listFind(assignment.getExemptID(),rc.rslist.userid)>checked</cfif><cfif perm neq 'editior'>disabled</cfif>></td></cfif>
			          <td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="editor" <cfif perm eq 'Editor'>checked</cfif>></td>
			    			<td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="author" <cfif perm eq 'Author'>checked</cfif>></td>
			   				<cfif not isModule><td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="none" <cfif perm eq 'None'>checked</cfif><cfif isModule>disabled</cfif>></td></cfif>
			    			<cfif rc.moduleid eq "00000000000000000000000000000000000"><td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="read" <cfif perm eq 'Read'>checked</cfif>></td></cfif>
			    			<td><input name="p#replacelist(rc.rslist.userid,"-","")#" type="radio" class="checkbox" value="deny" <cfif perm eq 'Deny'>checked</cfif>></td>
								<td nowrap class="var-width">#esapiEncode('html',rc.rslist.GroupName)#</td>
			        </tr>
						</cfloop>
		    	</table>
		    <cfelse>
		        <div class="help-block-empty"> #application.rbFactory.getKeyValue(session.rb,'permissions.nogroups')#</div>
		    </cfif>

			  <cfif chains.hasNext()>
			  <h2>#application.rbFactory.getKeyValue(session.rb,'permissions.approvalchain')#</h2>
			  <div class="mura-control-group">
			    <label>
			      <span data-toggle="popover"
			        title=""
			        data-placement="right"
			        data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.approvalchain"))#"
			        data-original-title="#application.rbFactory.getKeyValue(session.rb,'permissions.selectapprovalchain')#">#application.rbFactory.getKeyValue(session.rb,'permissions.selectapprovalchain')# <i class="mi-question-circle"></i></span>
			      </label>
			      <div>
			        <select name="chainID" class="dropdown">
			          <option value="">#application.rbFactory.getKeyValue(session.rb,'permissions.none')#</option>
			          <cfloop condition="chains.hasNext()">
			            <cfset chain=chains.next()>
			            <option value="#chain.getChainID()#"<cfif assignment.getChainID() eq chain.getChainID()> selected</cfif>>#esapiEncode('html',chain.getName())#</option>
			          </cfloop>
			        </select>
			      </div>
			    </div>
			    </cfif>
			    <div class="mura-actions">
			      <div class="form-actions no-offset">
			         <button class="btn mura-primary" onclick="submitForm(document.forms.form1);"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'permissions.update')#</button>
			      </div>
			    </div>
					<input type="hidden" name="router" value="#esapiEncode('html_attr',cgi.HTTP_REFERER)#">
					<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
					<input type="hidden" name="startrow" value="#esapiEncode('html_attr',rc.startrow)#">
					<input type="hidden" name="topid" value="#esapiEncode('html_attr',rc.topid)#">
					<input type="hidden" name="moduleid" value="#esapiEncode('html_attr',rc.moduleid)#">
					 #rc.$.renderCSRFTokens(context=rc.contentid,format="form")#
			  </td>
			  </tr>
			</table>
		</form>
    </div> <!-- /.block-content -->
  </div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

<script>
  $(function(){
      $("input[type='radio']").click(function(){
        var e=$(this).closest('tr').find("input[name='exemptID']")

        if($("input[name='" + $(this).attr('name') + "']:checked").val() != 'editor'){
          e.attr('checked',false)
          e.attr('disabled',true)
        } else {
          e.attr('disabled',false)
        }
      })
    }
  )
</script>
</cfoutput>
