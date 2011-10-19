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
	<cfquery datasource="#application.configBean.getDatasource(mode='readOnly')#" username="#application.configBean.getDBUsername(mode='readOnly')#" password="#application.configBean.getDBPassword(mode='readOnly')#" name="rslist">
	select mlid, name, description from tmailinglist where siteid='#$.event('siteID')#' and isPublic=1 order by isPurge, name 
	</cfquery>
</cfsilent>

<cfoutput>
<div id="svMasterEmail">
	<cfif $.event('doaction') eq 'masterSubscribe'>
		<cfif $.event("passedProtect")>
			<p class="response success">#$.rbKey('mailinglist.selectionssaved')#</p>
		<cfelse>
			<p class="error">#$.rbKey('captcha.spam')#</p>
		</cfif>
	<cfelseif $.event('doaction') eq 'validateMember'>
		<cfset application.mailinglistManager.validateMember($.event().getAllValues())/>
		<p class="response success">#$.rbKey('mailinglist.hasbeenvalidated')#</p>
	<cfelse>
		<form id="frmEmailMaster" name="frmEmailMaster" action="?nocache=1" method="post" onsubmit="return validate(this);" novalidate="novalidate" >
			<fieldset>
				<legend>#$.rbKey('mailinglist.mydetails')#</legend>
				<ol>
					<li class="req">
						<label for="txtNameFirst">#$.rbKey('mailinglist.fname')#<ins> (#$.rbKey('mailinglist.required')#)</ins></label>
						<input id="txtNameFirst" class="text" type="text" name="fname" maxlength="50" required="true" message="#HTMLEditFormat($.rbKey('mailinglist.fnamerequired'))#" />
					</li>
					<li class="req">
						<label for="txtNameLast">#$.rbKey('mailinglist.lname')#<ins> (#$.rbKey('mailinglist.required')#)</ins></label>
						<input id="txtNameLast" class="text" type="text" name="lname" maxlength="50" required="true" message="#HTMLEditFormat($.rbKey('mailinglist.lnamerequired'))#" />
					</li>
					<li>
						<label for="txtCompany">#$.rbKey('mailinglist.company')#</label>
						<input id="txtCompany" class="text" type="text" maxlength="50" name="company" />
					</li>
					<li class="req">
						<label for="txtEmail">#$.rbKey('mailinglist.email')#<ins> (#$.rbKey('mailinglist.required')#)</ins></label>
						<input id="txtEmail" class="text" type="text" name="email" maxlength="50" required="true" validate="email" message="#HTMLEditFormat($.rbKey('mailinglist.emailvalidate'))#" />
					</li>
				</ol>
			</fieldset>
			<fieldset>
				<legend>Subscription Settings</legend>
				<ol id="subSettings" class="stack"><cfset loopcount = 1><cfloop query="rslist">
					<li>
						<input id="mlid#loopcount#" class="checkbox" type="checkbox" name="mlid" value="#rslist.mlid#" <cfif listfind($.event('mlid'),rslist.mlid)>checked="checked"</cfif> />
						<label for="mlid#loopcount#">#rslist.name#</label>
						<cfif #rslist.description# neq ''><p class="inputNote">#rslist.description#</p></cfif>
					</li>
				<cfset loopcount = loopcount + 1></cfloop></ol>
			</fieldset>
			<div class="buttons">
				<input type="hidden" name="siteid" value="#$.event('siteID')#" />
				<input type="hidden" name="doaction" value="masterSubscribe" />
				<input type="hidden" name="linkServID" value="#$.content('contentID')#" />
				<input type="submit" class="submit" value="#HTMLEditFormat($.rbKey('mailinglist.submit'))#" />
			</div>
				<cfoutput>#$.dspObject_Include(thefile='dsp_form_protect.cfm')#</cfoutput>
		</form>
	</cfif>
</div>
</cfoutput>