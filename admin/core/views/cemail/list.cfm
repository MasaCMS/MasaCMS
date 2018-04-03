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
<cfinclude template="js.cfm">
<cfhtmlhead text="#session.dateKey#">
<cfsilent>
	<cfparam name="rc.rsPublicGroups.recordcount" default="0" />
	<cfparam name="rc.direction" default="">
	<cfparam name="rc.orderBy" default="">
	<cfparam name="rc.page" default="1">
  <cfset startDate=createDate(year(now()),month(now()),1)>
  <cfset stopDate=createDate(year(now()),month(now()),day(now()))>
  <cfset emailLimit = application.settingsManager.getSite(rc.siteID).getEmailBroadcasterLimit()>
  <cfset emailsSent = application.emailManager.getSentCount(rc.siteID, startDate,stopDate)>
  <cfif emailLimit eq 0>
  	<cfset emailLimitText = "Unlimited">
	<cfset emailsRemainingText = "Unlimited">
  <cfelse>
  	<cfset emailLimitText = emailLimit>
	<cfset emailsRemainingText = emailLimit - emailsSent>
  </cfif>
	</cfsilent>   
	
	<div class="mura-header">
		<cfoutput>	
			<h1>#application.rbFactory.getKeyValue(session.rb,"email.emailmanager")#</h1>
		</cfoutput>
	  <cfinclude template="dsp_secondary_menu.cfm">

		<div class="mura-item-metadata">
			<div class="label-group">
		  <cfoutput>
		  <div class="metadata-horizontal"><span class="label">#application.rbFactory.getKeyValue(session.rb,"email.emailssent")#: <strong>#emailsSent# (#LSDateFormat(startDate,session.dateKeyFormat)# - #LSDateFormat(stopDate, session.dateKeyFormat)#)</strong></span>
		  <span class="label">#application.rbFactory.getKeyValue(session.rb,"email.emailsalloted")#: <strong>#emailLimitText#</strong></span>
		  <span class="label">#application.rbFactory.getKeyValue(session.rb,"email.emailsremaining")#: <strong>#emailsRemainingText#</strong></span></div>
		  </cfoutput>
		  <!---<div id="bounces" class="divide">
		  <h2>Bounces</h2>
		  <a href="./?muraAction=cEmail.showAllBounces&siteid=<cfoutput>#rc.siteid#</cfoutput>">View All Bounces</a>
		  </div>--->
			</div><!-- /.label-group -->
		</div><!-- /.mura-item-metadata -->
	</div> <!-- /.mura-header -->

  <cfoutput>
<div class="block block-constrain">
	<div class="block block-bordered">
	  <div class="block-content">

	  <div id="filterView" class="mura-layout-row">
	  <h2>#application.rbFactory.getKeyValue(session.rb,"email.emails")#</h2></cfoutput>

<form novalidate="novalidate" action="./?muraAction=cEmail.list&siteid=<cfoutput>#rc.siteid#</cfoutput>" method="post" name="form1" id="advancedSearch">

	<div class="mura-control-group">
    <label>
    	<cfoutput>#application.rbFactory.getKeyValue(session.rb,"email.filterby")#:
    </label>
    <select name="groupID" class="input-medium">
    	<optgroup label="#application.rbFactory.getKeyValue(session.rb,'email.all')#">
	<option value="">#application.rbFactory.getKeyValue(session.rb,"email.all")#</option>
	</optgroup></cfoutput>
	<option value=""></option>
	<cfif rc.rsPrivateGroups.recordcount>
		<optgroup label="<cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.privategroups')#</cfoutput>">
			<cfoutput query="rc.rsPrivateGroups">
				<option value="#rc.rsPrivateGroups.UserID#" <cfif listfind(session.emaillist.groupid,rc.rsPrivateGroups.userid)>selected</cfif>>#rc.rsPrivateGroups.groupname#</option>
	  		</cfoutput>
		</optgroup>
	    <option value=""></option>
	</cfif>
	<cfif rc.rsPublicGroups.recordcount>
		<optgroup label="<cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.publicgroups')#</cfoutput>">
			<cfoutput query="rc.rsPublicGroups">
				<option value="#rc.rsPublicGroups.UserID#" <cfif  listfind(session.emaillist.groupid,rc.rsPublicGroups.userid)>selected</cfif>>#rc.rsPublicGroups.groupname#</option>
			</cfoutput>
		</optgroup>
		<option value=""></option>
	</cfif>
	<cfif rc.rsMailingLists.recordcount>
		<optgroup label="<cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.mailinglist')#</cfoutput>">
			<cfoutput query="rc.rsMailingLists">
			<option value="#rc.rsMailingLists.mlid#" <cfif  listfind(session.emaillist.groupid,rc.rsMailingLists.mlid)>selected</cfif>>#rc.rsMailingLists.name#</option>
			</cfoutput>
		</optgroup>
		<option value=""></option>
	</cfif>
  </select>
	</div>	  
<cfoutput>

	<div class="mura-control-group">
  <label>
  	#application.rbFactory.getKeyValue(session.rb,'email.status')#
  </label>
  <label class="radio inline">
  <input type="radio"  name="status" value="2"  <cfif session.emaillist.status eq 2>checked</cfif>> 
  <span class="text">#application.rbFactory.getKeyValue(session.rb,'email.all')#</span> 
  </label>
  <label class="radio inline">
  <input type="radio"  name="status" value="1" <cfif session.emaillist.status eq 1>checked</cfif>> 
  <span class="text">#application.rbFactory.getKeyValue(session.rb,'email.sent')#</span> 
  </label>
   <label class="radio inline">
   	<input type="radio"  name="status" value="0"  <cfif session.emaillist.status eq 0>checked</cfif>> 
   <span class="text">#application.rbFactory.getKeyValue(session.rb,'email.queued')#</span>
		</label>
</div>
	
	<div class="mura-control-group">
    <label>
    	#application.rbFactory.getKeyValue(session.rb,'email.subject')# <span>(#application.rbFactory.getKeyValue(session.rb,'email.leaveblanktoviewall')#)</span>
	  </label>
	  <input type="text"  name="subject" value="#session.emaillist.subject#">
	</div>

</div>

<input type="hidden" name="doSearch" value="true"/>

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->

	<div class="mura-actions">
		<div class="form-actions">			  
		<button type="button" class="btn mura-primary" onclick="submitForm(document.forms.form1);"><i class="mi-filter"></i> #application.rbFactory.getKeyValue(session.rb,'email.filter')#</button>
		</div>
	</div>

</form>
</cfoutput>

<div class="block-content">
  <table id="metadata" class="mura-table-grid">
    <tr> 
      <th class="actions"></th>
		  <cfset subjectDirection = "asc">
		  <cfset createdDateDirection = "desc">
		  <cfset deliveryDateDirection = "desc">
		  <cfset statusDirection = "asc">
		  <cfswitch expression="#rc.orderBy#">
		  	<cfcase value="subject">
				 <cfif rc.direction eq "asc">
				 	<cfset subjectDirection = "desc">
				</cfif>
			</cfcase>
			<cfcase value="createdDate">
				<cfif rc.direction eq "desc">
					<cfset createdDateDirection = "asc">
				</cfif>
			</cfcase>
			<cfcase value="deliveryDate">
				<cfif rc.direction eq "desc">
					<cfset deliveryDateDirection = "asc">
				</cfif>
			</cfcase>
			<cfcase value="status">
				<cfif rc.direction eq "asc">
					<cfset statusDirection = "desc">
				</cfif>
			</cfcase>
		  </cfswitch>
	  <cfoutput>
	  <th class="var-width"><a href="./?muraAction=cEmail.list&siteid=#esapiEncode('url',rc.siteid)#&orderBy=subject&direction=#subjectDirection#">#application.rbFactory.getKeyValue(session.rb,'email.subject')#</a></th>
	  <th>#application.rbFactory.getKeyValue(session.rb,'email.clicks')#</th>
	  <th>#application.rbFactory.getKeyValue(session.rb,'email.opens')#</th>
	  <th>#application.rbFactory.getKeyValue(session.rb,'email.bounces')#</th>
	  <th>#application.rbFactory.getKeyValue(session.rb,'email.all')#</th>
	  <th><a href="./?muraAction=cEmail.list&siteid=#esapiEncode('url',rc.siteid)#&orderBy=createdDate&direction=#createdDateDirection#">#application.rbFactory.getKeyValue(session.rb,'email.datecreated')#</a></th>
        <th><a href="./?muraAction=cEmail.list&siteid=#esapiEncode('url',rc.siteid)#&orderBy=deliveryDate&direction=#deliveryDateDirection#">#application.rbFactory.getKeyValue(session.rb,'email.deliverydate')#</a></th>
        <th><a href="./?muraAction=cEmail.list&siteid=#esapiEncode('url',rc.siteid)#&orderBy=status&direction=#statusDirection#">#application.rbFactory.getKeyValue(session.rb,'email.status')#</a></th>
	  </cfoutput>
      </tr>
	<cfset recordsPerPage = 20>
      <cfif rc.rslist.recordcount>
        <cfif isNumeric(rc.page)>
	  	<cfset startRow = ((rc.page-1) * recordsPerPage) + 1>
	  <cfelse>
	  	<cfset startRow = 1>
	  </cfif>
	  <cfset endRow = startRow + (recordsPerPage - 1)>
	  <cfoutput>
		  <cfloop query="rc.rslist" startRow="#startRow#" endRow="#endRow#"> 
			  <cfset clicks=application.emailManager.getStat(rc.rslist.emailid,'returnClick')/>
			  <cfset opens=application.emailManager.getStat(rc.rslist.emailid,'emailOpen')/>
			  <cfset sent=application.emailManager.getStat(rc.rslist.emailid,'sent')/>
			  <cfset bounces=application.emailManager.getStat(rc.rslist.emailid,'bounce')/>
				<tr> 
				  <td class="actions">
						<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
						<div class="actions-menu hide">
					  	<ul class="actions-list">
					  		<li class="edit"><a href="./?muraAction=cEmail.edit&emailid=#rc.rslist.emailid#&siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-pencil"></i></a></li><li class="download"><a title="#application.rbFactory.getKeyValue(session.rb,'email.download')#" href="./?muraAction=cEmail.download&emailID=#rc.rsList.emailID#&siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-download-alt"></i>#application.rbFactory.getKeyValue(session.rb,'email.edit')#</a></li>
					  		<li class="delete"><a href="./?muraAction=cEmail.update&action=delete&emailid=#rc.rslist.emailid#&siteid=#esapiEncode('url',rc.siteid)#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'email.deleteconfirm'))#',this.href)"><i class="mi-trash"></i>#application.rbFactory.getKeyValue(session.rb,'email.delete')#</a></li>
							</ul>
						</div>
					</td>
				  <td class="var-width"><a title="Edit" href="./?muraAction=cEmail.edit&emailid=#rc.rslist.emailid#&siteid=#esapiEncode('url',rc.siteid)#">#rc.rslist.subject#</a></td>
				  <td>#clicks#</td>
				  <td>#opens#</td>
				  <td>#bounces#</td>
				  <td>#sent#</td>
				  <td>#LSDateFormat(rc.rslist.createddate,session.dateKeyFormat)#</td>
				  <td><cfif LSisDate(rc.rslist.deliverydate)>#LSDateFormat(rc.rslist.deliverydate,session.dateKeyFormat)# #LSTimeFormat(rc.rslist.deliverydate,"short")#<cfelse>#application.rbFactory.getKeyValue(session.rb,'email.notscheduled')#</cfif></td>
				  <td><cfif LSisDate(rc.rslist.deliverydate)><cfif rc.rslist.status eq 99>In Progress<cfelseif rc.rslist.status eq 1>#application.rbFactory.getKeyValue(session.rb,'email.sent')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'email.queued')#</cfif><cfelse>#application.rbFactory.getKeyValue(session.rb,'email.notscheduled')#</cfif></td>
				</tr>
		  </cfloop>
	  
	  </cfoutput>
      <cfelse>
        <tr> 
          <td colspan="9" nowrap class="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.noemails')#</cfoutput></td>
        </tr>
      </cfif>
    </table>
	</div> <!-- /.block-content -->
</div> <!-- /.block-constrain -->

<cfoutput>
<cfif rc.rslist.recordcount gt recordsPerPage>
#application.rbFactory.getKeyValue(session.rb,'email.moreresults')#: 
<cfloop from="1" to="#Ceiling(rc.rslist.recordcount/recordsPerPage)#" index="i">
	<cfif i eq rc.page>
		#i#
	<cfelse>
		<a href="./?muraAction=cEmail.list&siteid=#esapiEncode('url',rc.siteid)#&page=#i#&direction=#rc.direction#&orderBy=#rc.orderBy#">#i#</a>
	</cfif>
</cfloop> 
</cfif>
</cfoutput>