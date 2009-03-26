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
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.ipwhitelist')#</h2>
<cfset newline= chr(13)& chr(10)>
<p>#application.rbFactory.getKeyValue(session.rb,'advertising.yourcurrentip')#: <strong>#cgi.REMOTE_ADDR#</strong></p>
<form name="form1" method="post" action="index.cfm?fuseaction=cAdvertising.updateIPWhiteList&siteid=#attributes.siteid#">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'advertising.iplist')#</dt>
<dd><em>#application.rbFactory.getKeyValue(session.rb,'advertising.iplistnote')#</em></dd>
<dd><textarea name="IPWhiteList" class="alt"><cfloop query="request.rslist">#request.rslist.ip##newLine#</cfloop></textarea></dd>
</dl>
<a class="submit" href="javascript:document.form1.submit();"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.update')#</span></a>
</form>
</cfoutput>