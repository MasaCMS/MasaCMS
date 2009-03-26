<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfsilent>
	<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rslist">
	select mlid, name, ispurge, description from tmailinglist where siteid='#request.siteid#' and mlid='#arguments.objectid#'
	</cfquery>
	<cfset rbFactory=getSite().getRBFactory() />
</cfsilent>
<cfoutput>
<div class="svMailingList" id="#createCSSID(rsList.name)#">
	<h3>#rslist.name#</h3>
	<cfif request.doaction eq 'unsubscribe'>
	<em>#rbFactory.getKey('mailinglist.youhaveunsubscribed')#</em>
	<cfelseif request.doaction eq 'subscribe' and rslist.isPurge neq 1>
	<em>#rbFactory.getKey('mailinglist.youhavesubscribed')#</em>
	<cfelseif request.doaction eq 'subscribe' and rslist.isPurge eq 1>
	<em>#rbFactory.getKey('mailinglist.emailremoved')#</em>
	<cfelse>
	<cfif #rslist.description# neq ''><p class="description">#rslist.description#</p></cfif>
	<form name="form1" action="#application.configBean.getIndexFile()#?nocache=1" method="post" onsubmit="return validate(this);" class="clearfix">
		<fieldset>
			<legend>#rbFactory.getKey('mailinglist.yourinfo')#</legend>
			<ol>
			<cfif rslist.isPurge neq 1>
				<li class="req">
					<label for="txtNameFirst">#rbFactory.getKey('mailinglist.fname')#<ins> (required)</ins></label>
					<input type="text" id="txtNameFirst" class="text" name="fname" required="true" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.fnamerequired'))#"/>
				</li>
				<li class="req">
					<label for="txtNameLast">#rbFactory.getKey('mailinglist.lname')#<ins> (#rbFactory.getKey('mailinglist.required')#)</ins></label>
					<input type="text" id="txtNameLast" class="text" name="lname" required="true" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.lnamerequired'))#"/>
				</li>
				<li>
					<label for="txtCompany">#rbFactory.getKey('mailinglist.company')#</label>
					<input type="text" id="txtCompany" class="text" name="company" />
				</li>
			</cfif>
				<li class="req">
					<label for="txtEmail">#rbFactory.getKey('mailinglist.email')#<ins> (#rbFactory.getKey('mailinglist.required')#)</ins></label>
					<input type="text" id="txtEmail" class="text" name="email" required="true" validate="email" message="#HTMLEditFormat(rbFactory.getKey('mailinglist.emailvalidate'))#"/>
				</li>
			</ol>
		</fieldset>
		<div class="buttons">
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
		</div>
	</form>
	</cfif>
</div>
</cfoutput>