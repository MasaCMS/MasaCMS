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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cftry>
<cfheader statustext="An Error Occurred" statuscode="500">
<cfcatch></cfcatch>
</cftry>
<cfscript>
if ( isDefined('arguments.exception.rootcause.type') && arguments.exception.rootcause.type == 'coldfusion.runtime.AbortException' ) {
	return;
}
param name="request.muraTemplateMissing" default=false;
if ( !request.muraTemplateMissing ) {
	param name="local" default=structNew();
	local.pluginEvent="";

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

	local.logData={stacktrace=arguments.exception.stacktrace};

	if(structKeyExists(arguments.exception,'message')){
		local.logData.message=arguments.exception.message;
	}

	writeLog( text=serializeJSON(local.logData), file="exception", type="Error" );

	if ( structKeyExists(application,"pluginManager") && structKeyExists(application.pluginManager,"announceEvent") ) {
		if ( structKeyExists(request,"servletEvent") ) {
			local.pluginEvent=request.servletEvent;
		} else if ( structKeyExists(request,"event") && isObject(request.event) ) {
			local.pluginEvent=request.event;
		} else {
			try {
				local.pluginEvent=createObject("component","mura.event");
			} catch (any cfcatch) {}
		}
		if ( isObject(local.pluginEvent) ) {
			local.pluginEvent.setValue("exception",arguments.exception);
			local.pluginEvent.setValue("error",arguments.exception);
			local.pluginEvent.setValue("eventname",arguments.eventname);
			try {
				if ( len(local.pluginEvent.getValue("siteID")) ) {
					application.pluginManager.announceEvent("onSiteError",local.pluginEvent);
				}
				application.pluginManager.announceEvent("onGlobalError",local.pluginEvent);
			} catch (any cfcatch) {
				if(application.configBean.getDebuggingEnabled()){
					arguments.exception=cfcatch;
				}
			}
		}
	}
	if ( structKeyExists(application,"configBean") ) {
		try {
			if ( !application.configBean.getDebuggingEnabled() ) {
				mailto=application.configBean.getMailserverusername();
				if(isDefined('application.serviceFactory')){
					application.serviceFactory.getBean('utility').resetContent();
					application.serviceFactory.getBean('utility').setHeader( statustext="An Error Occurred", statuscode=500 );
				}
				if ( len(application.configBean.getValue("errorTemplate")) ) {
					include application.configBean.getValue('errorTemplate');
				} else {
					include "/muraWRM/core/templates/error.html";
				}
				abort;
			}
		} catch (any cfcatch) {
		}
	}
	try {
		if(isDefined('application.serviceFactory')){
			application.serviceFactory.getBean('utility').setHeader( statustext="An Error Occurred", statuscode=500 );
		}
	} catch (any cfcatch) {
	}

	writeOutput('<style type=""text/css"">
		.errorBox {
			margin: 10px auto 10px auto;
			width: 90%;
		}

		.errorBox h1 {
			font-size: 100px;
			margin: 5px 0px 5px 0px;
		}

	</style>
	<div class=""errorBox"">
		<h1>500 Error</h1>');

	if ( isDefined("arguments.exception.Cause") ) {
		errorData=arguments.exception.Cause;
	} else {
		errorData=arguments.exception;
	}
	if ( isdefined('errorData.Message') && len(errorData.Message) ) {

		writeOutput("<h2>");

		if ( hasesapiencode ) {

			writeOutput("#esapiEncode('html',errorData.Message)#");
		} else if ( hasencodeforhtml ) {

			writeOutput("#encodeForHTML(errorData.Message)#");
		} else {

			writeOutput("#htmlEditFormat(errorData.Message)#");
		}

		writeOutput("<br /></h2>");
	}
	if ( isdefined('errorData.DataSource') && len(errorData.DataSource) ) {

		writeOutput("<h3>");

		writeOutput("Datasource:");
		if ( hasesapiencode ) {

			writeOutput("#esapiEncode('html',errorData.DataSource)#");
		} else if ( hasencodeforhtml ) {

			writeOutput("#encodeForHTML(errorData.DataSource)#");
		} else {

			writeOutput("#htmlEditFormat(errorData.DataSource)#");
		}

		writeOutput("<br /></h3>");
	}
	if ( isdefined('errorData.sql') && len(errorData.sql) ) {

		writeOutput("<h4>");

		writeOutput("SQL:");
		if ( hasesapiencode ) {

			writeOutput("#esapiEncode('html',errorData.sql)#");
		} else if ( hasencodeforhtml ) {

			writeOutput("#encodeForHTML(errorData.sql)#");
		} else {

			writeOutput("#htmlEditFormat(errorData.sql)#");
		}

		writeOutput("<br /></h4>");
	}
	if ( isdefined('errorData.errorCode') && len(errorData.errorCode) ) {

		writeOutput("<h3>");

		writeOutput("Code:");
		if ( hasesapiencode ) {

			writeOutput("#esapiEncode('html',errorData.errorCode)#");
		} else if ( hasencodeforhtml ) {

			writeOutput("#encodeForHTML(errorData.errorCode)#");
		} else {

			writeOutput("#htmlEditFormat(errorData.errorCode)#");
		}

		writeOutput("<br /></h3>");
	}
	if ( isdefined('errorData.type') && len(errorData.type) ) {

		writeOutput("<h3>");

		writeOutput("Type:");
		if ( hasesapiencode ) {

			writeOutput("#esapiEncode('html',errorData.type)#");
		} else if ( hasencodeforhtml ) {

			writeOutput("#encodeForHTML(errorData.type)#");
		} else {

			writeOutput("#htmlEditFormat(errorData.type)#");
		}

		writeOutput("<br /></h3>");
	}
	if ( isdefined('errorData.Detail') && len(errorData.Detail) ) {

		writeOutput("<h3>");

		if ( hasesapiencode ) {

			writeOutput("#esapiEncode('html',errorData.Detail)#");
		} else if ( hasencodeforhtml ) {

			writeOutput("#encodeForHTML(errorData.Detail)#");
		} else {

			writeOutput("#htmlEditFormat(errorData.Detail)#");
		}

		writeOutput("<br /></h3>");
	}
	if ( isdefined('errorData.extendedInfo') && len(errorData.extendedInfo) ) {

		writeOutput("<h3>");

		if ( hasesapiencode ) {

			writeOutput("#esapiEncode('html',errorData.extendedInfo)#");
		} else if ( hasencodeforhtml ) {

			writeOutput("#encodeForHTML(errorData.extendedInfo)#");
		} else {

			writeOutput("#htmlEditFormat(errorData.extendedInfo)#");
		}

		writeOutput("<br /></h3>");
	}
	if ( isdefined('errorData.StackTrace') ) {

		writeOutput("<pre>");

		if ( hasesapiencode ) {

			writeOutput("#esapiEncode('html',errorData.StackTrace)#");
		} else if ( hasencodeforhtml ) {

			writeOutput("#encodeForHTML(errorData.StackTrace)#");
		} else {

			writeOutput("#htmlEditFormat(errorData.StackTrace)#");
		}

		writeOutput("</pre><br />");
	}
	if ( isDefined('errorData.TagContext') && isArray(errorData.TagContext) ) {
		for ( errorContexts in errorData.TagContext ) {

			writeOutput("<hr />");
			if ( hasesapiencode ) {
				if ( isDefined('errorContexts.COLUMN') ) {

					writeOutput("Column: #esapiEncode('html',errorContexts.COLUMN)#<br />");
				}
				if ( isDefined('errorContexts.ID') ) {

					writeOutput("ID: #esapiEncode('html',errorContexts.ID)#<br />");
				}
				if ( isDefined('errorContexts.Line') ) {

					writeOutput("Line: #esapiEncode('html',errorContexts.Line)#<br />");
				}
				if ( isDefined('errorContexts.RAW_TRACE') ) {

					writeOutput("Raw Trace: #esapiEncode('html',errorContexts.RAW_TRACE)#<br />");
				}
				if ( isDefined('errorContexts.TEMPLATE') ) {

					writeOutput("Template: #esapiEncode('html',errorContexts.TEMPLATE)#<br />");
				}
				if ( isDefined('errorContexts.TYPE') ) {

					writeOutput("Type: #esapiEncode('html',errorContexts.TYPE)#<br />");
				}
			} else if ( hasencodeforhtml ) {
				if ( isDefined('errorContexts.COLUMN') ) {

					writeOutput("Column: #encodeForHTML(errorContexts.COLUMN)#<br />");
				}
				if ( isDefined('errorContexts.ID') ) {

					writeOutput("ID: #encodeForHTML(errorContexts.ID)#<br />");
				}
				if ( isDefined('errorContexts.Line') ) {

					writeOutput("Line: #encodeForHTML(errorContexts.Line)#<br />");
				}
				if ( isDefined('errorContexts.RAW_TRACE') ) {

					writeOutput("Raw Trace: #encodeForHTML(errorContexts.RAW_TRACE)#<br />");
				}
				if ( isDefined('errorContexts.TEMPLATE') ) {

					writeOutput("Template: #encodeForHTML(errorContexts.TEMPLATE)#<br />");
				}
				if ( isDefined('errorContexts.TYPE') ) {

					writeOutput("Type: #encodeForHTML(errorContexts.TYPE)#<br />");
				}
			} else {
				if ( isDefined('errorContexts.COLUMN') ) {

					writeOutput("Column: #htmlEditFormat(errorContexts.COLUMN)#<br />");
				}
				if ( isDefined('errorContexts.ID') ) {

					writeOutput("ID: #htmlEditFormat(errorContexts.ID)#<br />");
				}
				if ( isDefined('errorContexts.Line') ) {

					writeOutput("Line: #htmlEditFormat(errorContexts.Line)#<br />");
				}
				if ( isDefined('errorContexts.RAW_TRACE') ) {

					writeOutput("Raw Trace: #htmlEditFormat(errorContexts.RAW_TRACE)#<br />");
				}
				if ( isDefined('errorContexts.TEMPLATE') ) {

					writeOutput("Template: #htmlEditFormat(errorContexts.TEMPLATE)#<br />");
				}
				if ( isDefined('errorContexts.TYPE') ) {

					writeOutput("Type: #htmlEditFormat(errorContexts.TYPE)#<br />");
				}
			}

			writeOutput("<br />");
		}
	}

	writeOutput("</div>");
	abort;
}
request.muraTemplateMissing=false;
</cfscript>
