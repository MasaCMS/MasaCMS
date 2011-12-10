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

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfoutput>
<cfif rsform.responseChart and not(refind("Mac",cgi.HTTP_USER_AGENT) and refind("MSIE 5",cgi.HTTP_USER_AGENT))>
	
	<cfset customResponse=application.pluginManager.renderEvent("onFormSubmitPollRender",event)>
	<cfif len(customResponse)>
		#customResponse#
	<cfelse>
		<cfquery name="rsTotal" datasource="#application.configBean.getDatasource(mode='readOnly')#" username="#application.configBean.getDBUsername(mode='readOnly')#" password="#application.configBean.getDBPassword(mode='readOnly')#">
		select count(pollValue) as qty from tformresponsequestions where FormID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#"/> and pollValue is not null
		</cfquery>
	
		<div id="dsp_response" class="dataCollection">
		<ul class="pollResults">
		<cfloop list="#request.polllist#" index="i">
		<cfsilent>
		<cfquery name="rsSubTotal" datasource="#application.configBean.getDatasource(mode='readOnly')#" username="#application.configBean.getDBUsername(mode='readOnly')#" password="#application.configBean.getDBPassword(mode='readOnly')#">
		SELECT tformresponsequestions.pollValue, Count(tformresponsequestions.pollValue) AS qty
		FROM tformresponsequestions
		GROUP BY tformresponsequestions.pollValue, tformresponsequestions.formID
		HAVING tformresponsequestions.formID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#"/>
		and tformresponsequestions.pollValue=<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#"/>
		ORDER BY Count(tformresponsequestions.pollValue)
		</cfquery></cfsilent><cfif rsSubTotal.qty eq ''><cfset lineQty=0><cfelse><cfset lineQty=rsSubtotal.qty></cfif><cfset percent=round((lineQty/rstotal.qty)*100)><li><span class="pollValue">#i#:</span> <span class="pollQty">#lineQty#</span> <span class="pollPercent">(#percent#%)</span><div style="margin: 2px 0 0 0; height: 10px; width: #percent#%; background: ##8C9EB4 url(/default/images/bg_poll_result.gif); font-size: 9px;">&nbsp;</div></li></cfloop></ul></div>
	</cfif>
</cfif>
<cfif not acceptdata>
	<cfif acceptError eq "Browser">
		<p class="error">We're sorry the polling feature is not supported for IE 5 on the Mac</p>
	<cfelseif acceptError eq "Duplicate">
		<p class="error">#getSite().getRBFactory().getKey("poll.onlyonevote")#</p>
	<cfelseif acceptError eq "Captcha">
		<p class="error">#getSite().getRBFactory().getKey("captcha.error")# <a href="javascript:history.back();">#getSite().getRBFactory().getKey("captcha.tryagain")#</a></p>
	<cfelseif acceptError eq "Spam">
		<p class="error">#getSite().getRBFactory().getKey("captcha.spam")# <a href="javascript:history.back();">#getSite().getRBFactory().getKey("captcha.tryagain")#</a></p>
	</cfif>
<cfelse>
		<div id="frm#replace(rsform.contentID,'-','','ALL')#">
		<cfset customResponse=application.pluginManager.renderEvent("onFormSubmitResponseRender",event)>
		<cfif len(customResponse)>
		#customResponse#
		<cfelse>
		#$.setDynamicContent('<p class="success">' & rsform.responseMessage & '</p>')#
		</cfif>
	
		<cfif isdefined("request.redirect_url")>
			<cfset customResponse=application.pluginManager.renderEvent("onBeforeFormSubmitRedirect",event)>
			<cfif len(customResponse)>
				#customResponse#
			<cfelse>
				<cfif  isdefined("request.redirect_label")>
					<p class="success"><a href="#request.redirect_url#">#request.redirect_label#</a></p>
				<cfelse>
					<cflocation addtoken="false" url="#request.redirect_url#">
				</cfif>
			</cfif>
		</cfif>
		</div>
</cfif>
</cfoutput>