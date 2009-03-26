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
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsForm">
select contentid,title,body,responseChart,responseMessage,responseSendTo,forceSSL,displayTitle, doCache
 from tcontent 
where siteid='#request.siteid#' and 
				    (
					(tcontent.Active = 1
					  AND tcontent.DisplayStart <= #createodbcdate(now())#
					  AND (tcontent.DisplayStop >= #createodbcdate(now())# or tcontent.DisplayStop is null)
					  AND tcontent.Display = 2
					  AND tcontent.Approved = 1
					  AND tcontent.contentid = '#arguments.objectid#')
					  or
					  
                      (tcontent.Active = 1
					  AND tcontent.Display = 1
					  AND tcontent.Approved = 1
					  AND tcontent.contentid = '#arguments.objectid#')
					  
					 ) 
					</cfquery>
</cfsilent>
<cfif rsForm.recordcount>
<cfset request.cacheItem=rsForm.doCache>
<cfif rsForm.forceSSL eq 1>
<cfset request.forceSSL = 1>
</cfif>
<cfoutput>
<cfif rsForm.displayTitle neq 0><h3>#rsForm.title#</h3></cfif>
<cfif isdefined('request.formid') and request.formid eq rsform.contentid>
<cfset acceptdata=1> 
<cfinclude template="act_add.cfm">
<cfinclude template="dsp_response.cfm">
<cfelse>
#setDynamicContent(application.dataCollectionManager.renderForm(rsForm.contentid,request.siteid,rsForm.body,rsForm.responseChart))#
</cfif>

</cfoutput>
</cfif>