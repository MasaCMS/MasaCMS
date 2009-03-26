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
<h2>#application.rbFactory.getKeyValue(session.rb,'collections.remotefeedimport')#</h2>
<cfif not request.import.success>
<h3>#application.rbFactory.getKeyValue(session.rb,'collections.importfailed')#</h3>
<p>#application.rbFactory.getKeyValue(session.rb,'collections.importfailedtext')#</p>
<cfelse>
<h3>#application.rbFactory.getKeyValue(session.rb,'collections.importsuccessful')#</h3>
<cfset crumbdata=application.contentManager.getCrumbList(request.import.parentBean.getcontentID(), attributes.siteid)/>
#application.contentRenderer.dspZoom(crumbdata)#
</cfif>
</cfoutput>