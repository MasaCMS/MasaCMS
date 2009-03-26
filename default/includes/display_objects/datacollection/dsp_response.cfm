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
<cfif rsform.responseChart and not(refind("Mac",cgi.HTTP_USER_AGENT) and refind("MSIE 5",cgi.HTTP_USER_AGENT))>
	
	<cfquery name="rsTotal" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	select count(pollValue) as qty from tformresponsequestions where FormID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#"/> and pollValue is not null
	</cfquery>

	<div id="dsp_response" class="dataCollection">
	<ul class="pollResults">
	<cfloop list="#request.polllist#" index="i">
	<cfsilent>
	<cfquery name="rsSubTotal" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	SELECT tformresponsequestions.pollValue, Count(tformresponsequestions.pollValue) AS qty
	FROM tformresponsequestions
	GROUP BY tformresponsequestions.pollValue, tformresponsequestions.formID
	HAVING tformresponsequestions.formID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#"/>
	and tformresponsequestions.pollValue=<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#"/>
	ORDER BY Count(tformresponsequestions.pollValue)
	</cfquery></cfsilent><cfif rsSubTotal.qty eq ''><cfset lineQty=0><cfelse><cfset lineQty=rsSubtotal.qty></cfif><cfset percent=round((lineQty/rstotal.qty)*100)><li><span class="pollValue">#i#:</span> <span class="pollQty">#lineQty#</span> <span class="pollPercent">(#percent#%)</span><div style="margin: 2px 0 0 0; height: 10px; width: #percent#%; background: ##8C9EB4 url(/default/images/bg_poll_result.gif); font-size: 9px;">&nbsp;</div></li></cfloop></ul></div>

</cfif>
<cfif not acceptdata>
	<cfif acceptError eq "Browser">
		<p class="error">We're sorry the polling feature is not supported for IE 5 on the Mac</p>
	<cfelseif acceptError eq "Duplicate">
		<p class="error">You are only allowed to vote once per poll.</p>
	<cfelseif acceptError eq "Captcha">
		<p class="error">The security code entered was incorrect. <a href="javascript:history.back();">Please try again.</a></p>
	</cfif>
<cfelse><p class="success">#setDynamicContent(rsform.responseMessage)#</p>
		<cfif isdefined("request.redirect_url")>
			<cfif  isdefined("request.redirect_label")>
			<p class="success"><a href="#request.redirect_url#">#request.redirect_label#</a></p>
			<cfelse>
			<cflocation addtoken="false" url="#request.redirect_url#">
			</cfif>
		</cfif>
</cfif>
</cfoutput>