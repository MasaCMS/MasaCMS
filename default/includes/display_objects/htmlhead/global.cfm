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
<cfparam name="session.dateKey" default=""/>
<cfoutput>
#session.dateKey#	
<script type="text/javascript" src="#application.configBean.getContext()#/#request.siteid#/js/global.js"></script>
<script type="text/javascript">
<cfif not request.exportHtmlSite>var loginURL="#application.settingsManager.getSite(request.siteid).getLoginURL()#"; </cfif>
var siteid="#request.siteid#"; 
var siteID="#request.siteid#"; 
var context="#application.configBean.getContext()#"; 
var jslib="#getJsLib()#";
</script>
</cfoutput>