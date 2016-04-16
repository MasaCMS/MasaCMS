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
<cfif isDefined('arguments.exception.rootcause.type') and arguments.exception.rootcause.type eq 'coldfusion.runtime.AbortException'>
	<cfreturn />
</cfif>

<cfif not isDefined('request.muraTemplateMissing')>
	<cfparam name="local" default="#structNew()#">
	<cfset local.pluginEvent="">

	<cfscript>
		try{
			esapiencode('html','test');

			hasesapiencode=true;
		} catch (Any e){
			hasesapiencode=false;

			try{
				encodeForHTML('html');
				hasencodeforhtml=true;
			} catch (Any e){
				hasencodeforhtml=false;
			}
		}
	</cfscript>

	<cflog type="Error" file="exception" text="#exception.stacktrace#">

	<cfif structKeyExists(application,"pluginManager") and structKeyExists(application.pluginManager,"announceEvent")>
		<cfif structKeyExists(request,"servletEvent")>
			<cfset local.pluginEvent=request.servletEvent>
		<cfelseif structKeyExists(request,"event")>
			<cfset local.pluginEvent=request.event>
		<cfelse>
			<cftry>
			<cfset local.pluginEvent=createObject("component","mura.event")>
			<cfcatch></cfcatch>
			</cftry>
		</cfif>

		<cfif isObject(local.pluginEvent)>
			<cfset local.pluginEvent.setValue("exception",arguments.exception)>
			<cfset local.pluginEvent.setValue("eventname",arguments.eventname)>
			<cftry>
				<cfif len(local.pluginEvent.getValue("siteID"))>
					<cfset application.pluginManager.announceEvent("onSiteError",local.pluginEvent)>
				</cfif>
				<cfset application.pluginManager.announceEvent("onGlobalError",local.pluginEvent)>
				<cfcatch></cfcatch>
			</cftry>

		</cfif>
	</cfif>

	<cfif structKeyExists(application,"configBean")>
		<cftry>
		<cfif not application.configBean.getDebuggingEnabled()>
			<cfset mailto=application.configBean.getMailserverusername()>
			<cfcontent reset="true">
			<cfheader statuscode="500" statustext="An Error Occurred" />
			<cfif len(application.configBean.getValue("errorTemplate"))>
				<cfinclude template="#application.configBean.getValue('errorTemplate')#">
			<cfelse>
				<cfinclude template="/muraWRM/config/error.html">
			</cfif>
			<cfabort>
		</cfif>
		<cfcatch></cfcatch>
		</cftry>
	</cfif>
	<cftry>
		<cfheader statuscode="500" statustext="An Error Occurred" />
		<cfcatch></cfcatch>
	</cftry>
	<style type="text/css">
		.errorBox {
			margin: 10px auto 10px auto;
			width: 90%;
		}

		.errorBox h1 {
			font-size: 100px;
			margin: 5px 0px 5px 0px;
		}

	</style>
	<div class="errorBox">
		<h1>500 Error</h1>
		<cfif isDefined("arguments.exception.Cause")>
			<cfset errorData=arguments.exception.Cause>
		<cfelse>
			<cfset errorData=arguments.exception>
		</cfif>
		<cfif isdefined('errorData.Message') and len(errorData.Message)>
			<h2>
			<cfoutput>
			<cfif hasesapiencode>
				#esapiEncode('html',errorData.Message)#
			<cfelseif hasencodeforhtml>
				#encodeForHTML(errorData.Message)#
			<cfelse>
				#htmlEditFormat(errorData.Message)#
			</cfif>
			</cfoutput><br /></h2>
		</cfif>
		<cfif isdefined('errorData.DataSource') and len(errorData.DataSource)>
			<h3><cfoutput>Datasource:
			<cfif hasesapiencode>
				#esapiEncode('html',errorData.DataSource)#
			<cfelseif hasencodeforhtml>
				#encodeForHTML(errorData.DataSource)#
			<cfelse>
				#htmlEditFormat(errorData.DataSource)#
			</cfif>
		</cfoutput><br /></h3>
		</cfif>
		<cfif isdefined('errorData.sql') and len(errorData.sql)>
			<h4><cfoutput>SQL:
			<cfif hasesapiencode>
				#esapiEncode('html',errorData.sql)#
			<cfelseif hasencodeforhtml>
				#encodeForHTML(errorData.sql)#
			<cfelse>
				#htmlEditFormat(errorData.sql)#
			</cfif>
			</cfoutput><br /></h4>
		</cfif>
		<cfif isdefined('errorData.errorCode') and len(errorData.errorCode)>
			<h3><cfoutput>Code:
			<cfif hasesapiencode>
				#esapiEncode('html',errorData.errorCode)#
			<cfelseif hasencodeforhtml>
				#encodeForHTML(errorData.errorCode)#
			<cfelse>
				#htmlEditFormat(errorData.errorCode)#
			</cfif>
			</cfoutput><br /></h3>
		</cfif>
		<cfif isdefined('errorData.type') and len(errorData.type)>
			<h3><cfoutput>Type:
			<cfif hasesapiencode>
				#esapiEncode('html',errorData.type)#
			<cfelseif hasencodeforhtml>
				#encodeForHTML(errorData.type)#
			<cfelse>
				#htmlEditFormat(errorData.type)#
			</cfif>
			</cfoutput><br /></h3>
		</cfif>
		<cfif isdefined('errorData.Detail') and len(errorData.Detail)>
			<h3><cfoutput>
			<cfif hasesapiencode>
				#esapiEncode('html',errorData.Detail)#
			<cfelseif hasencodeforhtml>
				#encodeForHTML(errorData.Detail)#
			<cfelse>
				#htmlEditFormat(errorData.Detail)#
			</cfif>
			</cfoutput><br /></h3>
		</cfif>
		<cfif isdefined('errorData.extendedInfo') and len(errorData.extendedInfo)>
			<h3><cfoutput>
			<cfif hasesapiencode>
				#esapiEncode('html',errorData.extendedInfo)#
			<cfelseif hasencodeforhtml>
				#encodeForHTML(errorData.extendedInfo)#
			<cfelse>
				#htmlEditFormat(errorData.extendedInfo)#
			</cfif>
			</cfoutput><br /></h3>
		</cfif>
		<cfif isdefined('errorData.StackTrace')>
			<pre><cfoutput>
			<cfif hasesapiencode>
				#esapiEncode('html',errorData.StackTrace)#
			<cfelseif hasencodeforhtml>
				#encodeForHTML(errorData.StackTrace)#
			<cfelse>
				#htmlEditFormat(errorData.StackTrace)#
			</cfif></cfoutput></pre><br />
		</cfif>
		<cfif isDefined('errorData.TagContext') and isArray(errorData.TagContext)>
			<cfloop array="#errorData.TagContext#" index="errorContexts">
				<cfoutput>
				<hr />
				<cfif hasesapiencode>
					<cfif isDefined('errorContexts.COLUMN')>
						Column: #esapiEncode('html',errorContexts.COLUMN)#<br />
					</cfif>
					<cfif isDefined('errorContexts.ID')>
						ID: #esapiEncode('html',errorContexts.ID)#<br />
					</cfif>
					<cfif isDefined('errorContexts.Line')>
						Line: #esapiEncode('html',errorContexts.Line)#<br />
					</cfif>
					<cfif isDefined('errorContexts.RAW_TRACE')>
						Raw Trace: #esapiEncode('html',errorContexts.RAW_TRACE)#<br />
					</cfif>
					<cfif isDefined('errorContexts.TEMPLATE')>
						Template: #esapiEncode('html',errorContexts.TEMPLATE)#<br />
					</cfif>
					<cfif isDefined('errorContexts.TYPE')>
						Type: #esapiEncode('html',errorContexts.TYPE)#<br />
					</cfif>
				<cfelseif hasencodeforhtml>
					<cfif isDefined('errorContexts.COLUMN')>
					Column: #encodeForHTML(errorContexts.COLUMN)#<br />
					</cfif>
					<cfif isDefined('errorContexts.ID')>
						ID: #encodeForHTML(errorContexts.ID)#<br />
					</cfif>
					<cfif isDefined('errorContexts.Line')>
						Line: #encodeForHTML(errorContexts.Line)#<br />
					</cfif>
					<cfif isDefined('errorContexts.RAW_TRACE')>
						Raw Trace: #encodeForHTML(errorContexts.RAW_TRACE)#<br />
					</cfif>
					<cfif isDefined('errorContexts.TEMPLATE')>
						Template: #encodeForHTML(errorContexts.TEMPLATE)#<br />
					</cfif>
					<cfif isDefined('errorContexts.TYPE')>
						Type: #encodeForHTML(errorContexts.TYPE)#<br />
					</cfif>
				<cfelse>
					<cfif isDefined('errorContexts.COLUMN')>
					Column: #htmlEditFormat(errorContexts.COLUMN)#<br />
					</cfif>
					<cfif isDefined('errorContexts.ID')>
						ID: #htmlEditFormat(errorContexts.ID)#<br />
					</cfif>
					<cfif isDefined('errorContexts.Line')>
						Line: #htmlEditFormat(errorContexts.Line)#<br />
					</cfif>
					<cfif isDefined('errorContexts.RAW_TRACE')>
						Raw Trace: #htmlEditFormat(errorContexts.RAW_TRACE)#<br />
					</cfif>
					<cfif isDefined('errorContexts.TEMPLATE')>
						Template: #htmlEditFormat(errorContexts.TEMPLATE)#<br />
					</cfif>
					<cfif isDefined('errorContexts.TYPE')>
						Type: #htmlEditFormat(errorContexts.TYPE)#<br />
					</cfif>
				</cfif>
				<br />
				</cfoutput>
			</cfloop>
		</cfif>
	</div>
	<cfabort>
</cfif>
