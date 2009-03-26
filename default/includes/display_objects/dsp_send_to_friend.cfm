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
<cfswitch expression="#getJsLib()#">
<cfcase value="jquery">
	<cfset addToHTMLHeadQueue("jquery.cfm")>
	<cfset addToHTMLHeadQueue("shadowbox-jquery.cfm")>
</cfcase>
<cfdefaultcase>
	<cfset addToHTMLHeadQueue("prototype.cfm")>
	<cfset addToHTMLHeadQueue("scriptaculous.cfm")>
	<cfset addToHTMLHeadQueue("shadowbox-prototype.cfm")>
</cfdefaultcase>
</cfswitch>

<cfset addToHTMLHeadQueue("shadowbox.cfm")>

<cfif request.contentBean.getType() eq 'Page'><cfoutput><a rel="shadowbox;width=600;height=500" href="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/#request.siteid#/utilities/sendtofriend.cfm?link=#URLEncodedFormat(getCurrentURL())#&siteid=#request.siteid#">Share</a></cfoutput></cfif>