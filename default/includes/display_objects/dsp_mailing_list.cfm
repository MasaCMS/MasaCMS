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
	select mlid, name, ispurge, description 
	from tmailinglist 
	where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.event('siteID')#">
	and 
	<cfif isValid('UUID',arguments.objectID)>
	mlid
	<cfelse>
	name
	</cfif>
	=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectid#">
	</cfquery>
</cfsilent>
<cfoutput>
<div class="svMailingList" id="#createCSSID(rsList.name)#">
	<#$.getHeaderTag('subHead1')#>#rslist.name#</#$.getHeaderTag('subHead1')#>
	
	<cfif $.event('doaction') eq 'unsubscribe'>
		<cfif $.event("passedProtect")>
			<p class="success">#$.rbKey('mailinglist.youhaveunsubscribed')#</p>
		<cfelse>
			<p class="error">#$.rbKey('captcha.spam')#</p>
		</cfif>
	<cfelseif $.event('doaction') eq 'subscribe' and rslist.isPurge neq 1>
		<cfif $.event("passedProtect")>
			<p class="success">#$.rbKey('mailinglist.youhavesubscribed')#</p>
		<cfelse>
			<p class="error">#$.rbKey('captcha.spam')#</p>
		</cfif>
	<cfelseif $.event('doaction') eq 'subscribe' and rslist.isPurge eq 1>
		<cfif $.event("passedProtect")>
			<p class="success">#$.rbKey('mailinglist.emailremoved')#</p>
		<cfelse>
			<p class="error">#$.rbKey('captcha.spam')#</p>
		</cfif>	
	<cfelse>
	<cfif #rslist.description# neq ''><p class="description">#rslist.description#</p></cfif>
	<form name="frmMailingList" action="?nocache=1" method="post" onsubmit="return validate(this);" class="clearfix" novalidate="novalidate" >
		<fieldset>
			<legend>#$.rbKey('mailinglist.yourinfo')#</legend>
			<ol>
			<cfif rslist.isPurge neq 1>
				<li class="req">
					<label for="txtNameFirst">#$.rbKey('mailinglist.fname')#<ins> (required)</ins></label>
					<input type="text" id="txtNameFirst" class="text" name="fname" maxlength="50" required="true" message="#HTMLEditFormat($.rbKey('mailinglist.fnamerequired'))#"/>
				</li>
				<li class="req">
					<label for="txtNameLast">#$.rbKey('mailinglist.lname')#<ins> (#$.rbKey('mailinglist.required')#)</ins></label>
					<input type="text" id="txtNameLast" class="text" name="lname" maxlength="50" required="true" message="#HTMLEditFormat($.rbKey('mailinglist.lnamerequired'))#"/>
				</li>
				<li>
					<label for="txtCompany">#$.rbKey('mailinglist.company')#</label>
					<input type="text" id="txtCompany" class="text" maxlength="50" name="company" />
				</li>
			</cfif>
				<li class="req">
					<label for="txtEmail">#$.rbKey('mailinglist.email')#<ins> (#$.rbKey('mailinglist.required')#)</ins></label>
					<input type="text" id="txtEmail" class="text" name="email" maxlength="50" required="true" validate="email" message="#HTMLEditFormat($.rbKey('mailinglist.emailvalidate'))#"/>
				</li>
			</ol>
		</fieldset>
		<div class="buttons">
			<input type="hidden" name="linkServID" value="#$.content('contentID')#" />
			<input type="hidden" name="mlid" value="#rslist.mlid#"><input type="hidden" name="siteid" value="#$.event('siteID')#" />
			<cfif rslist.isPurge eq 0>
			<input type="hidden" name="doaction" value="subscribe" checked="checked" />
			<input type="hidden" name="isVerified" value="1" />
			<input type="submit" class="submit" value="#HTMLEditFormat($.rbKey('mailinglist.subscribe'))#" />
			<cfelse>
			<input type="hidden" name="doaction" value="subscribe"  />
			<input type="hidden" name="isVerified" value="1"  />
			<input type="submit" class="submit" value="#HTMLEditFormat($.rbKey('mailinglist.unsubscribe'))#" />
			</cfif>
				#$.dspObject_Include(thefile='dsp_form_protect.cfm')#
		</div>
	</form>
	</cfif>
</div>
</cfoutput>