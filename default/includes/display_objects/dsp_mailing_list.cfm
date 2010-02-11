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
	select mlid, name, ispurge, description from tmailinglist where siteid='#request.siteid#' and mlid='#arguments.objectid#'
	</cfquery>
	<cfset rbFactory=getSite().getRBFactory() />
</cfsilent>
<cfoutput>
<div class="svMailingList" id="#createCSSID(rsList.name)#">
	<#getHeaderTag('subHead1')#>#rslist.name#</#getHeaderTag('subHead1')#>
	
	<cfif request.doaction eq 'unsubscribe'>
		<cfif event.getValue("passedProtect")>
			<p class="success">#rbFactory.getKey('mailinglist.youhaveunsubscribed')#</p>
		<cfelse>
			<p class="error">#rbFactory.getKey('captcha.spam')#</p>
		</cfif>
	<cfelseif request.doaction eq 'subscribe' and rslist.isPurge neq 1>
		<cfif event.getValue("passedProtect")>
			<p class="success">#rbFactory.getKey('mailinglist.youhavesubscribed')#</p>
		<cfelse>
			<p class="error">#rbFactory.getKey('captcha.spam')#</p>
		</cfif>
	<cfelseif request.doaction eq 'subscribe' and rslist.isPurge eq 1>
		<cfif event.getValue("passedProtect")>
			<p class="success">#rbFactory.getKey('mailinglist.emailremoved')#</p>
		<cfelse>
			<p class="error">#rbFactory.getKey('captcha.spam')#</p>
		</cfif>	
	<cfelse>
	<cfif #rslist.description# neq ''><p class="description">#rslist.description#</p></cfif>
	<form name="form1" action="?nocache=1" method="post" onsubmit="return validate(this);" class="clearfix">
		<fieldset>
			<legend>#rbFactory.getKey('mailinglist.yourinfo')#</legend>
			<ol>
			<cfif rslist.isPurge neq 1>
				<li class="req">
					<label for="txtNameFirst">#rbFactory.getKey('mailinglist.fname')#<ins> (required)</ins></label>
					<input type="text" id="txtNameFirst" class="text" name="fname" maxlength="50" required="true" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.fnamerequired'))#"/>
				</li>
				<li class="req">
					<label for="txtNameLast">#rbFactory.getKey('mailinglist.lname')#<ins> (#rbFactory.getKey('mailinglist.required')#)</ins></label>
					<input type="text" id="txtNameLast" class="text" name="lname" maxlength="50" required="true" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.lnamerequired'))#"/>
				</li>
				<li>
					<label for="txtCompany">#rbFactory.getKey('mailinglist.company')#</label>
					<input type="text" id="txtCompany" class="text" maxlength="50" name="company" />
				</li>
			</cfif>
				<li class="req">
					<label for="txtEmail">#rbFactory.getKey('mailinglist.email')#<ins> (#rbFactory.getKey('mailinglist.required')#)</ins></label>
					<input type="text" id="txtEmail" class="text" name="email" maxlength="50" required="true" validate="email" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.emailvalidate'))#"/>
				</li>
			</ol>
		</fieldset>
		<div class="buttons">
			<input type="hidden" name="linkServID" value="#event.getContentBean().getContentID()#" />
			<input type="hidden" name="mlid" value="#rslist.mlid#"><input type="hidden" name="siteid" value="#request.siteid#" />
			<cfif rslist.isPurge eq 0>
			<input type="hidden" name="doaction" value="subscribe" checked="checked" />
			<input type="hidden" name="isVerified" value="1" />
			<input type="submit" class="submit" value="#HTMLEditFormat(rbFactory.getKey('mailinglist.subscribe'))#" />
			<cfelse>
			<input type="hidden" name="doaction" value="subscribe"  />
			<input type="hidden" name="isVerified" value="1"  />
			<input type="submit" class="submit" value="#HTMLEditFormat(rbFactory.getKey('mailinglist.unsubscribe'))#" />
			</cfif>
				#dspObject_Include(thefile='dsp_form_protect.cfm')#
		</div>
	</form>
	</cfif>
</div>
</cfoutput>