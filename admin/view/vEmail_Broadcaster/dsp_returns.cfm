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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"email.clickdetail")#</h2>
<strong>#application.rbFactory.getKeyValue(session.rb,"email.userswhoclicked")#:</strong></cfoutput>
<cfif request.rsReturnsByUser.recordcount>
	<ul class="metadata">
	<cfoutput query="request.rsReturnsByUser">
	<li>#request.rsReturnsByUser.email#</li>
	</cfoutput>
	</ul>
</cfif>
<cfoutput><strong>#application.rbFactory.getKeyValue(session.rb,"email.toplinks")#:</strong></cfoutput>
<cfif request.rsReturns.recordcount>
	<ul class="metadata">
	<cfoutput query="request.rsReturns">
	<li>#request.rsReturns.url# - #request.rsReturns.returnCount#</li>
	</cfoutput>
	</ul>
</cfif>