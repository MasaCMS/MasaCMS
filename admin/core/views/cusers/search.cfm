<!--- 
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
<cfoutput>

	<!--- User Search --->
		<cfinclude template="inc/dsp_search_form.cfm" />

	<!--- Page Title --->
		<h1>#rc.$.rbKey('user.usersearchresults')#</h1>

	<!--- Buttons --->
		<div id="nav-module-specific" class="btn-group">

			<!--- Add User --->
				<a class="btn" href="#buildURL(action='cusers.edituser', querystring='siteid=#esapiEncode('url',rc.siteid)#&userid=')#">
					<i class="icon-plus-sign"></i> 
					#rc.$.rbKey('user.adduser')#
				</a>

		  <!--- Add Group --->
				<a class="btn" href="#buildURL(action='cusers.editgroup', querystring='siteid=#esapiEncode('url',rc.siteid)#&userid=')#">
					<i class="icon-plus-sign"></i> 
					#rc.$.rbKey('user.addgroup')#
				</a>

			<!--- View Groups --->
				<a class="btn" href="#buildURL(action='cusers.default', querystring='siteid=#esapiEncode('url',rc.siteid)#')#">
					<i class="icon-eye-open"></i>
					#rc.$.rbKey('user.viewgroups')#
				</a>

			<!--- View Users --->
				<a class="btn" href="#buildURL(action='cusers.listUsers', querystring='siteid=#esapiEncode('url',rc.siteid)#')#">
					<i class="icon-eye-open"></i>
					#rc.$.rbKey('user.viewusers')#
				</a>

		</div>
	<!--- /Buttons --->


	<!--- Tab Nav (only tabbed for Admin + Super Users) --->
    <cfif rc.isAdmin>
        <ul class="nav nav-tabs">
          <!--- Site Members Tab --->
	          <li<cfif rc.ispublic eq 1> class="active"</cfif>>
	            <a href="#buildURL(action='cusers.search', querystring='siteid=#esapiEncode('url',rc.siteid)#&ispublic=1&search=#esapiEncode('url',rc.search)#')#">
	              #rc.$.rbKey('user.sitemembers')#
	            </a>
	          </li>

          <!--- System Users Tab --->
	          <li<cfif rc.ispublic eq 0> class="active"</cfif>>
	            <a href="#buildURL(action='cusers.search', querystring='siteid=#esapiEncode('url',rc.siteid)#&ispublic=0&search=#esapiEncode('url',rc.search)#')#">
	              #rc.$.rbKey('user.systemusers')#
	            </a>
	          </li>
        </ul>
    <cfelse>
      <h3>#rc.$.rbKey('user.sitemembers')#</h3>
    </cfif>
  <!--- /Tab Nav --->


	<cfinclude template="inc/dsp_users_list.cfm" />
</cfoutput>

<!---
<cfif not rc.newSearch>
	<cfoutput>
		<table class="mura-table-grid">
			<tr> 
				<th class="var-width">#rc.$.rbKey('user.name')#</th>
				<th>#rc.$.rbKey('user.email')#</th>
				<th>#rc.$.rbKey('user.update')#</th>
				<th>#rc.$.rbKey('user.time')#</th>
				<th>#rc.$.rbKey('user.authoreditor')#</th>
				<th class="actions">&nbsp;</th>
			</tr>
			</cfoutput>

			<cfif rc.rsList.recordcount>
				<cfoutput query="rc.rsList" maxrows="#rc.nextN.recordsperPage#" startrow="#rc.startrow#"> 
					<tr> 
						<td class="var-width">
							<a title="Edit" href="./?muraAction=cUsers.edituser&amp;userid=#rc.rsList.UserID#&amp;type=2&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;returnURL=#esapiEncode('url',rc.currentURL)#">
								#esapiEncode('html',rc.rsList.lname)#, #esapiEncode('html',rc.rsList.fname)# 
								<cfif company neq ''> 
									(#esapiEncode('html',company)#)
								</cfif>
							</a>
						</td>
						<td>
							<cfif rc.rsList.email gt "">
								<a href="mailto:#esapiEncode('html',rc.rsList.email)#">
									#esapiEncode('html',rc.rsList.email)#
								</a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							#LSDateFormat(rc.rslist.lastupdate,session.dateKeyFormat)#
						</td>
						<td>
							#LSTimeFormat(rc.rslist.lastupdate,"short")#
						</td>
						<td>
							#esapiEncode('html',rc.rsList.LastUpdateBy)#
						</td>
						<td class="actions">
							<ul>
								<li class="edit">
									<a title="#rc.$.rbKey('user.edit')#" href="./?muraAction=cUsers.edituser&amp;userid=#rc.rsList.UserID#&amp;type=2&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;returnURL=#esapiEncode('url',rc.currentURL)#">
										<i class="icon-pencil"></i>
									</a>
								</li>
							</ul>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr> 
					<td colspan="6" class="noResults">
						<cfoutput>
							#rc.$.rbKey('user.nosearchresults')#
						</cfoutput>
					</td>
				</tr>
			</cfif>
		</table>

		<!--- Pagination --->
		<!---
		<cfif rc.nextN.numberofpages gt 1>
			<cfoutput>
				<cfset args=arrayNew(1)>
				<cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
				<cfset args[2]=rc.nextn.totalrecords>
				<div class="mura-results-wrapper">
					<p class="clearfix search-showing">
						#application.rbFactory.getResourceBundle(session.rb).messageFormat(rc.$.rbKey("sitemanager.paginationmeta"),args)#
					</p> 
					<div class="pagination">
						<ul>
							<cfif rc.nextN.currentpagenumber gt 1> 
								<li>
									<a href="./?muraAction=cUsers.search&amp;startrow=#rc.nextN.previous#&amp;lname=#esapiEncode('url',rc.lname)#&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;search=#esapiEncode('url',rc.search)#">&laquo;&nbsp;#rc.$.rbKey('user.prev')#</a>
								</li>
							</cfif>	
					 		<cfloop from="#rc.nextN.firstPage#"  to="#rc.nextN.lastPage#" index="i">
								<cfif rc.nextN.currentpagenumber eq i>
									<li class="active"><a href="##">#i#</a></li>
								<cfelse> 
									<li><a href="./?muraAction=cUsers.search&amp;startrow=#evaluate('(#i#*#rc.nextN.recordsperpage#)-#rc.nextN.recordsperpage#+1')#&amp;lname=#esapiEncode('url',rc.lname)#&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;search=#esapiEncode('url',rc.search)#">#i#</a></li>
								</cfif>
							</cfloop>
							<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
								<li><a href="./?muraAction=cUsers.search&amp;startrow=#rc.nextN.next#&amp;lname=#esapiEncode('url',rc.lname)#&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;search=#esapiEncode('url',rc.search)#">#rc.$.rbKey('user.next')#&nbsp;&raquo;</a>
								</li>
							</cfif> 
						</ul>
					</div>
				</div>
			</cfoutput>
		</cfif>
		--->
		<!--- /Pagination --->
	</cfif>
--->
	<!--- /if not rc.newSearch --->