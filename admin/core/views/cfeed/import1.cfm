<!---
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the
same licensing model. It is, therefore, licensed under the Gnu General Public License
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing
notice set out below. That exception is also granted by the copyright holders of Masa CMS
also applies to this file and Masa CMS in general.

This file has been modified from the original version received from Mura CMS. The
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained
only to ensure software compatibility, and compliance with the terms of the GPLv2 and
the exception set out below. That use is not intended to suggest any commercial relationship
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa.

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com

Masa CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.
Masa CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>.

The original complete licensing notice from the Mura CMS version of this file is as
follows:

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
<cfset rc.formatsupported=true>
<cfinclude template="js.cfm">

<style type="text/css">
	.mura-import-item img{
		max-width: 200px !important;
		margin-top: .5em !important;
	}
	.mura-import-item br:first-child,
	.mura-import-item br:first-child + br{
		display: none;
	}
</style>


<cfoutput>
<div class="mura-header">
	<h1>#application.rbFactory.getKeyValue(session.rb,'collections.remotefeedimportselection')#</h1>
	<cfinclude template="dsp_secondary_menu.cfm">
	</div> <!-- /.mura-header -->

	<div class="block block-constrain">
			<div class="block block-bordered">
				<div class="block-content">

					<form novalidate="novalidate" action="./?muraAction=cFeed.import2&feedid=#esapiEncode('url',rc.feedid)#&siteid=#esapiEncode('url',rc.siteid)#" method="post" name="contentForm" onsubmit="return false;">
						<cfset feedBean=application.feedManager.read(rc.feedID) />
						<h2>#feedBean.getName()#</h2>
							</cfoutput>

						<CFHTTP url="#feedBean.getChannelLink()#" method="GET" resolveurl="Yes" throwOnError="Yes" />
						<cfset xmlFeed=parseXML( REReplace( CFHTTP.FileContent, "^[^<]*", "", "all" ) )/>
						<cfswitch expression="#feedBean.getVersion()#">
							<cfcase value="RSS 0.920,RSS 2.0">

								<cfset items = xmlFeed.rss.channel.item>
								<cfset maxItems=arrayLen(items) />

								<cfif maxItems gt feedBean.getMaxItems()>
									<cfset maxItems=feedBean.getMaxItems()/>
								</cfif>

					<cfloop from="1" to="#maxItems#" index="i">
							<cfsilent>
							<cftry>
								<cfset remoteID=hash(left(items[i].guid.xmlText,255),"CFMX_COMPAT") />
								<cfcatch>
									<cfset remoteID=hash(left(items[i].link.xmlText,255),"CFMX_COMPAT") />
								</cfcatch>
							</cftry>

							<cfset rc.newBean=application.contentManager.getActiveByRemoteID(remoteID,rc.siteid) />

							</cfsilent>
							<cfif not (not rc.newBean.getIsNew() and (items[i].pubDate.xmlText eq rc.newBean.getRemotePubDate())) >
							<cfset rc.rsCategoryAssign = application.contentManager.getCategoriesByHistID(rc.newBean.getcontenthistID()) />

								<cfoutput>
									<div class="mura-layout-row mura-import-item clearfix">
										<div class="mura-12">
											<label><input name="remoteID" value="#esapiEncode('html_attr',remoteID)#" type="checkbox" checked>&nbsp;&nbsp;#application.rbFactory.getKeyValue(session.rb,'collections.import')#&nbsp;&nbsp;</label>
											<label><strong><a href="#esapiEncode('html_attr',items[i].link.xmlText)#" target="_blank">#esapiEncode('html',items[i].title.xmlText)#<cfif not rc.newBean.getIsNew()> [#application.rbFactory.getKeyValue(session.rb,'collections.update')#]</cfif></a></strong></label>
										</div>
										<div class="mura-12">#items[i].description.xmlText#</div>
									</div>

								</cfoutput>
							</cfif>
							</cfloop>

							</cfcase>
							<cfcase value="atom">
								<cfset rc.formatsupported=false>
								<cfoutput><p>#application.rbFactory.getKeyValue(session.rb,'collections.formatnotsupport')#</p></cfoutput>
							</cfcase>
						</cfswitch>
						<cfif rc.formatsupported>
						<div class="mura-actions">
							<div class="form-actions">
							<cfoutput><button class="btn mura-primary" onclick="feedManager.confirmImport();"><i class="mi-sign-in"></i>#application.rbFactory.getKeyValue(session.rb,'collections.import')#</button></cfoutput>
							</div>
						</div>
						<input type="hidden" name="action" value="import" />
						</cfif>
					</form>

				<div class="clearfix"></div>
			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
	</div> <!-- /.block-constrain -->