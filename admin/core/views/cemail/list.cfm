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
<cfhtmlhead text="#session.dateKey#">
<cfparam name="rc.rsPublicGroups.recordcount" default="0" />
<cfparam name="rc.direction" default="">
<cfparam name="rc.orderBy" default="">
<cfparam name="rc.page" default="1">
<cfoutput><h1>#application.rbFactory.getKeyValue(session.rb,"email.emailmanager")#</h1></cfoutput>

<cfsilent>
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
	  </cfif></cfsilent>   
	  <cfoutput>
	  <ul class="metadata-horizontal"><li>#application.rbFactory.getKeyValue(session.rb,"email.emailssent")#: <strong>#emailsSent# (#LSDateFormat(startDate,session.dateKeyFormat)# - #LSDateFormat(stopDate, session.dateKeyFormat)#)</strong></li>
	  <li>#application.rbFactory.getKeyValue(session.rb,"email.emailsalloted")#: <strong>#emailLimitText#</strong></li>
	  <li>#application.rbFactory.getKeyValue(session.rb,"email.emailsremaining")#: <strong>#emailsRemainingText#</strong></li></ul>
	  </cfoutput>
	  <!---<div id="bounces" class="divide">
	  <h2>Bounces</h2>
	  <a href="index.cfm?muraAction=cEmail.showAllBounces&siteid=<cfoutput>#rc.siteid#</cfoutput>">View All Bounces</a>
	  </div>--->
	  <cfinclude template="dsp_secondary_menu.cfm">
	  <cfoutput>

	  <div id="filterView" class="row-fluid">
	  <h2>#application.rbFactory.getKeyValue(session.rb,"email.emails")#</h2></cfoutput>

<form novalidate="novalidate" action="index.cfm?muraAction=cEmail.list&siteid=<cfoutput>#rc.siteid#</cfoutput>" method="post" name="form1" id="advancedSearch" class="fieldset-wrap">

<div class="fieldset">
	<div class="control-group">
		<div class="span3">
	      <label class="control-label">
	      	<cfoutput>#application.rbFactory.getKeyValue(session.rb,"email.filterby")#:
	      </label>
	      <div class="controls"><select name="groupID" class="input-medium">
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
	    </div>
<cfoutput>

	<div class="span3">
	      <label class="control-label">
	      	#application.rbFactory.getKeyValue(session.rb,'email.status')#
	      </label>
	      <div class="controls">
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
	</div>
</div>
	
	<div class="control-group">
	      <label class="control-label">
	      	#application.rbFactory.getKeyValue(session.rb,'email.subject')# <span>(#application.rbFactory.getKeyValue(session.rb,'email.leaveblanktoviewall')#)</span>
	  	  </label>
	      <div class="controls"><input type="text"  name="subject" value="#session.emaillist.subject#" class="span6">
	      </div>
	</div>

</div>

<input type="hidden" name="doSearch" value="true"/>
<div class="form-actions">			  
<button type="button" class="btn" onclick="submitForm(document.forms.form1);"><i class="icon-filter"></i> #application.rbFactory.getKeyValue(session.rb,'email.filter')#</button>
</div>
</form>
</div>

</cfoutput>
	  <table id="metadata" class="table table-striped table-condensed table-bordered mura-table-grid">
        <tr> 
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
		  <th class="var-width"><a href="index.cfm?muraAction=cEmail.list&siteid=#URLEncodedFormat(rc.siteid)#&orderBy=subject&direction=#subjectDirection#">#application.rbFactory.getKeyValue(session.rb,'email.subject')#</a></th>
		  <th>#application.rbFactory.getKeyValue(session.rb,'email.clicks')#</th>
		  <th>#application.rbFactory.getKeyValue(session.rb,'email.opens')#</th>
		  <th>#application.rbFactory.getKeyValue(session.rb,'email.bounces')#</th>
		  <th>#application.rbFactory.getKeyValue(session.rb,'email.all')#</th>
		  <th><a href="index.cfm?muraAction=cEmail.list&siteid=#URLEncodedFormat(rc.siteid)#&orderBy=createdDate&direction=#createdDateDirection#">#application.rbFactory.getKeyValue(session.rb,'email.datecreated')#</a></th>
          <th><a href="index.cfm?muraAction=cEmail.list&siteid=#URLEncodedFormat(rc.siteid)#&orderBy=deliveryDate&direction=#deliveryDateDirection#">#application.rbFactory.getKeyValue(session.rb,'email.deliverydate')#</a></th>
          <th><a href="index.cfm?muraAction=cEmail.list&siteid=#URLEncodedFormat(rc.siteid)#&orderBy=status&direction=#statusDirection#">#application.rbFactory.getKeyValue(session.rb,'email.status')#</a></th>
          <th>&nbsp;</th>
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
					  <td class="var-width"><a title="Edit" href="index.cfm?muraAction=cEmail.edit&emailid=#rc.rslist.emailid#&siteid=#URLEncodedFormat(rc.siteid)#">#rc.rslist.subject#</a></td>
					  <td>#clicks#</td>
					  <td>#opens#</td>
					  <td>#bounces#</td>
					  <td>#sent#</td>
					  <td>#LSDateFormat(rc.rslist.createddate,session.dateKeyFormat)#</td>
					  <td><cfif LSisDate(rc.rslist.deliverydate)>#LSDateFormat(rc.rslist.deliverydate,session.dateKeyFormat)# #LSTimeFormat(rc.rslist.deliverydate,"short")#<cfelse>#application.rbFactory.getKeyValue(session.rb,'email.notscheduled')#</cfif></td>
					  <td><cfif LSisDate(rc.rslist.deliverydate)><cfif rc.rslist.status eq 99>In Progress<cfelseif rc.rslist.status eq 1>#application.rbFactory.getKeyValue(session.rb,'email.sent')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'email.queued')#</cfif><cfelse>#application.rbFactory.getKeyValue(session.rb,'email.notscheduled')#</cfif></td>
					  <td class="actions"><ul><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'email.edit')#" href="index.cfm?muraAction=cEmail.edit&emailid=#rc.rslist.emailid#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i></a></li><li class="download"><a title="#application.rbFactory.getKeyValue(session.rb,'email.download')#" href="index.cfm?muraAction=cEmail.download&emailID=#rc.rsList.emailID#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-download-alt"></i></a></li><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'email.delete')#" href="index.cfm?muraAction=cEmail.update&action=delete&emailid=#rc.rslist.emailid#&siteid=#URLEncodedFormat(rc.siteid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'email.deleteconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li></ul></td>
					</tr>
			  </cfloop>
		  
		  </cfoutput>
        <cfelse>
          <tr> 
            <td colspan="9" nowrap class="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.noemails')#</cfoutput></td>
          </tr>
        </cfif>
      </table>
	  <cfoutput>
	  <cfif rc.rslist.recordcount gt recordsPerPage>
		#application.rbFactory.getKeyValue(session.rb,'email.moreresults')#: 
		<cfloop from="1" to="#Ceiling(rc.rslist.recordcount/recordsPerPage)#" index="i">
			<cfif i eq rc.page>
				#i#
			<cfelse>
				<a href="index.cfm?muraAction=cEmail.list&siteid=#URLEncodedFormat(rc.siteid)#&page=#i#&direction=#rc.direction#&orderBy=#rc.orderBy#">#i#</a>
			</cfif>
		</cfloop> 
	  </cfif>
	  </cfoutput>