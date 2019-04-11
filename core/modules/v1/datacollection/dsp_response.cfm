<!---
  This file is part of Mura CMS.

  Mura CMS is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, Version 2 of the License.

  Mura CMS is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

  Linking Mura CMS statically or dynamically with other modules constitutes
  the preparation of a derivative work based on Mura CMS. Thus, the terms
  and conditions of the GNU General Public License version 2 ("GPL") cover
  the entire combined work.

  However, as a special exception, the copyright holders of Mura CMS grant
  you permission to combine Mura CMS with programs or libraries that are
  released under the GNU Lesser General Public License version 2.1.

  In addition, as a special exception, the copyright holders of Mura CMS
  grant you permission to combine Mura CMS with independent software modules
  (plugins, themes and bundles), and to distribute these plugins, themes and
  bundles without Mura CMS under the license of your choice, provided that
  you follow these specific guidelines:

  Your custom code

  • Must not alter any default objects in the Mura CMS database and
  • May not alter the default display of the Mura CMS logo within Mura CMS and
  • Must not alter any files in the following directories:

   	/admin/
	/core/
	/Application.cfc
	/index.cfm

  You may copy and distribute Mura CMS with a plug-in, theme or bundle that
  meets the above guidelines as a combined work under the terms of GPL for
  Mura CMS, provided that you include the source code of that other code when
  and as the GNU GPL requires distribution of source code.

  For clarity, if you create a modified version of Mura CMS, you are not
  obligated to grant this special exception for your modified version; it is
  your choice whether to do so, or to make such modified version available
  under the GNU General Public License version 2 without this exception.  You
  may, if you choose, apply this exception to your own modified versions of
  Mura CMS.
--->
<cfoutput>
<cfset variables.bean=$.event('formBean')>
<cfset variables.rsform=variables.bean.getAllValues()>
<cfif StructKeyExists(request, 'polllist') and  variables.rsform.responseChart and not(refind("Mac",cgi.HTTP_USER_AGENT) and refind("MSIE 5",cgi.HTTP_USER_AGENT))>

	<cfset variables.customResponse=application.pluginManager.renderEvent("onFormSubmitPollRender",variables.event)>
	<cfif len(variables.customResponse)>
		#variables.customResponse#
	<cfelse>
		#$.dspObject_Include(thefile='datacollection/dsp_poll.cfm')#
	</cfif>
</cfif>
<cfset formDataBean=variables.event.getValue('formDataBean')>
<cfif not formDataBean.getValue('acceptdata')>
	<cfset variables.customresponse = application.pluginManager.renderEvent("onFormSubmitErrorRender",variables.event) />
	<cfif Len(variables.customresponse)>
		#variables.customresponse#
	<cfelseif formDataBean.getValue('acceptError') eq "Browser">
		<p class="#this.alertDangerClass#">We're sorry the polling feature is not supported for IE 5 on the Mac</p>
	<cfelseif formDataBean.getValue('acceptError') eq "Duplicate">
		<p class="#this.alertDangerClass#">#$.rbKey("poll.onlyonevote")#</p>
	<cfelseif formDataBean.getValue('acceptError') eq "Captcha">
		<p class="#this.alertDangerClass#">#$.rbKey("captcha.error")# <a href="javascript:history.back();">#$.rbKey("captcha.tryagain")#</a></p>
	<cfelseif formDataBean.getValue('acceptError') eq "Spam">
		<p class="#this.alertDangerClass#">#$.rbKey("captcha.spam")# <a href="javascript:history.back();">#$.rbKey("captcha.tryagain")#</a></p>
  <cfelseif formDataBean.getValue('acceptError') eq 'reCAPTCHA'>
    <p class="#this.alertDangerClass#">#$.rbKey('recaptcha.error')# <a href="javascript:history.back();">#$.rbKey('recaptcha.tryagain')#</a></p>
	<cfelse>
		<div class="#this.alertDangerClass#">#application.utility.displayErrors(formDataBean.getErrors())#</div>
	</cfif>
<cfelse>
		<div id="frm#replace(variables.rsform.contentID,'-','','ALL')#">
		<cfset variables.customResponse=application.pluginManager.renderEvent("onFormSubmitResponseRender",event)>
		<cfif len(customResponse)>
		#variables.customResponse#
		<cfelse>
		#variables.$.setDynamicContent('<p class="success">' & variables.rsform.responseMessage & '</p>')#
		</cfif>

		<cfif isdefined("request.redirect_url")>
			<cfset request.redirect_url=variables.$.getBean('utility').sanitizeHref(request.redirect_url)>
			<cfset variables.customResponse=application.pluginManager.renderEvent("onBeforeFormSubmitRedirect",variables.event)>
			<cfif len(variables.customResponse)>
				#variables.customResponse#
			<cfelse>
				<cfif isdefined("request.redirect_label")>
					<p class="#this.alertSuccessClass#"><a href="#request.redirect_url#">#request.redirect_label#</a></p>
				<cfelse>
					<cfif request.muraFrontEndRequest>
						<cflocation addtoken="false" url="#request.redirect_url#">
					<cfelse>
						<cfset request.muraJSONRedirectURL=request.redirect_url>
					</cfif>

				</cfif>
			</cfif>
		</cfif>
		</div>
</cfif>
</cfoutput>
