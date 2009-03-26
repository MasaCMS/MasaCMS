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
<h2>Update Plugin Version</h2>

<ul class="metadata">
<li><strong>Name:</strong> #htmlEditFormat(request.pluginConfig.getName())#</li>
<li><strong>Category:</strong> #htmlEditFormat(request.pluginConfig.getCategory())#</li>
<li><strong>Version:</strong> #htmlEditFormat(request.pluginConfig.getVersion())#</li>
<li><strong>Provider:</strong> #htmlEditFormat(request.pluginConfig.getProvider())#</li>
<li><strong>Provider URL:</strong> <a href="#request.pluginConfig.getProviderURL()#" target="_blank">#htmlEditFormat(request.pluginConfig.getProviderURL())#</a></li>
</ul>

Upload New Plugin Version
<form name="frmNewPlugin" action="index.cfm?fuseaction=cSettings.deployPlugin" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);">
<input name="newPlugin" type="file" required="true" message="Please select a plugin file.">
<input type="submit" value="Deploy"/>
<input type="hidden" name="moduleID" value="#request.pluginConfig.getModuleID()#">
</form>

</cfoutput>