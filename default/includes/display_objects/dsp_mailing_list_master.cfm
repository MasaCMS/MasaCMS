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
	<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rslist">
	select mlid, name, description from tmailinglist where siteid='#request.siteid#' and isPublic=1 order by isPurge, name 
	</cfquery>
	<cfparam name="request.email" default="">
	<cfset rbFactory=getSite().getRBFactory() />
</cfsilent>

<cfoutput>
<div id="svMasterEmail">
	<cfif request.doaction eq 'masterSubscribe'>
		<p class="response success">#rbFactory.getKey('mailinglist.selectionssaved')#</p>
	<cfelseif request.doaction eq 'validateMember'>
		<cfset application.mailinglistManager.validateMember(request)/>
		<p class="response success">#rbFactory.getKey('mailinglist.hasbeenvalidated')#</p>
	<cfelse>
		<form id="frmEmailMaster" name="frmEmailMaster" action="?nocache=1" method="post" onsubmit="return validate(this);">
			<fieldset>
				<legend>#rbFactory.getKey('mailinglist.mydetails')#</legend>
				<ol>
					<li class="req">
						<label for="txtNameFirst">#rbFactory.getKey('mailinglist.fname')#<ins> (#rbFactory.getKey('mailinglist.required')#)</ins></label>
						<input id="txtNameFirst" class="text" type="text" name="fname" required="true" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.fnamerequired'))#" />
					</li>
					<li class="req">
						<label for="txtNameLast">#rbFactory.getKey('mailinglist.lname')#<ins> (#rbFactory.getKey('mailinglist.required')#)</ins></label>
						<input id="txtNameLast" class="text" type="text" name="lname" required="true" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.lnamerequired'))#" />
					</li>
					<li>
						<label for="txtCompany">#rbFactory.getKey('mailinglist.company')#</label>
						<input id="txtCompany" class="text" type="text" name="company" />
					</li>
					<li class="req">
						<label for="txtEmail">#rbFactory.getKey('mailinglist.email')#<ins> (#rbFactory.getKey('mailinglist.required')#)</ins></label>
						<input id="txtEmail" class="text" type="text" name="email" required="true" validate="email" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.emailvalidate'))#" />
					</li>
				</ol>
			</fieldset>
			<fieldset>
				<legend>Subscription Settings</legend>
				<ol id="subSettings" class="stack"><cfset loopcount = 1><cfloop query="rslist">
					<li>
						<input id="mlid#loopcount#" class="checkbox" type="checkbox" name="mlid" value="#rslist.mlid#" <cfif listfind(request.mlid,rslist.mlid)>checked="checked"</cfif> />
						<label for="mlid#loopcount#">#rslist.name#</label>
						<cfif #rslist.description# neq ''><p class="inputNote">#rslist.description#</p></cfif>
					</li>
				<cfset loopcount = loopcount + 1></cfloop></ol>
			</fieldset>
			<div class="buttons">
				<input type="hidden" name="siteid" value="#request.siteid#" />
				<input type="hidden" name="doaction" value="masterSubscribe" />
				<input type="submit" class="submit" value="#HTMLEditFormat(rbFactory.getKey('mailinglist.submit'))#" />
			</div>
		</form>
	</cfif>
</div>
</cfoutput>