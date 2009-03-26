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

<cfparam name="request.fuseaction" default="list">
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rssite">
select siteid from tcontent where contentid='#arguments.objectid#' and active=1
</cfquery>
<cfset request.contentBean=application.contentManager.getActiveContent(arguments.objectid,rssite.siteid)/>

<cfswitch expression="#request.fuseaction#">
<cfcase value="list">
<cfinclude template="dsp_list.cfm">
</cfcase>
<cfcase value="detail">
<cfinclude template="dsp_detail.cfm">
</cfcase>
</cfswitch>