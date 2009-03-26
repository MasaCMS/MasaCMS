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
<cfset rbFactory=getSite().getRBFactory() />
<cfquery name="rsEmail1" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
SELECT userid, groupname, email, type FROM tusers WHERE type=1 and Email>'' and contactform like '%#request.siteid#%'
order by groupname
</cfquery>
<cfquery name="rsEmail2" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
SELECT userid, fname, lname, email, type FROM tusers WHERE type=2 and Email>'' AND contactform like '%#request.siteid#%' order by lname
</cfquery>
</cfsilent>
<cfif rsemail1.recordcount eq 1 and rsemail2.recordcount eq 0 >
<cfoutput>
<input name="sendto" value="#rsemail1.email#" type="hidden" /></cfoutput>
<cfelseif rsemail1.recordcount eq 0 and rsemail2.recordcount eq 1>
<cfoutput><input name="sendto" value="#rsemail2.email#" type="hidden" /></cfoutput>
<cfelse>
<li class="req">
	<label for="sendto">#rbFactory.getKey('email.sendto')#<ins> (#rbFactory.getKey('email.required')#)</ins></label>
	<select id="sendto" name="sendto" class="dropdown" required="true" message="#htmlEditFormat(rbFactory.getKey('email.sendtorequired'))#">
		<option value="">#rbFactory.getKey('email.pleaseselect')#</option>
		<cfif rsEmail1.recordcount>
		<optgroup label="#htmlEditFormat(rbFactory.getKey('email.group'))#">
			<cfoutput query="rsEmail1"><option value="#Email#">#groupname#</option></cfoutput>
		</optgroup>
		</cfif>
		<cfif rsEmail2.recordcount><!--- <cfif rsemail1.recordcount and rsemail2.recordcount><option>---------------------</option></cfif> --->
		<optgroup label="#htmlEditFormat(rbFactory.getKey('email.person'))#">
			<cfoutput query="rsEmail2"><option value="#Email#">#fname# #lname#</option></cfoutput>
		</optgroup>
		</cfif>
	</select>
</li>
</cfif>
