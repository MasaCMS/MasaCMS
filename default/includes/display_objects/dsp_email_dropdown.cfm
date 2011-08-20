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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

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
	<label for="sendto">#$.rbKey('email.sendto')#<ins> (#$.rbKey('email.required')#)</ins></label>
	<select id="sendto" name="sendto" class="dropdown" required="true" message="#htmlEditFormat($.rbKey('email.sendtorequired'))#">
		<option value="">#$.rbKey('email.pleaseselect')#</option>
		<cfif rsEmail1.recordcount>
		<optgroup label="#htmlEditFormat($.rbKey('email.group'))#">
			<cfoutput query="rsEmail1"><option value="#Email#">#groupname#</option></cfoutput>
		</optgroup>
		</cfif>
		<cfif rsEmail2.recordcount><!--- <cfif rsemail1.recordcount and rsemail2.recordcount><option>---------------------</option></cfif> --->
		<optgroup label="#htmlEditFormat($.rbKey('email.person'))#">
			<cfoutput query="rsEmail2"><option value="#Email#">#fname# #lname#</option></cfoutput>
		</optgroup>
		</cfif>
	</select>
</li>
</cfif>
