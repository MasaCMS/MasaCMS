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
<cfset request.layout=false>
<cfparam name="rc.keywords" default="">
<cfparam name="rc.isNew" default="1">
<cfparam name="rc.contentpoolid" default="#rc.siteid#">

<cfset counter=0 />
<cfoutput>
	<div id="contentSearch" class="form-inline">
		<!--- <h2>#application.rbFactory.getKeyValue(session.rb,'collections.contentsearch')#</h2> --->
		<div class="mura-input-set">
			<input class="form-control" id="parentSearch" name="parentSearch" value="#esapiEncode('html_attr',rc.keywords)#" type="text" maxlength="50" placeholder="#application.rbFactory.getKeyValue(session.rb,'collections.search')#" onclick="return false;">
			<button type="button" class="btn btn-default" onclick="feedManager.loadSiteFilters('#rc.siteid#',document.getElementById('parentSearch').value,0,$('##contentPoolID').val());"><i class="mi-search"></i></button>
		</div>	
	</div>
</cfoutput>

<cfif not rc.isNew>
	<cfif listFindNoCase(rc.contentPoolID,rc.siteid) or not len(rc.contentPoolID)>
		<cfset rc.rsList=application.contentManager.getPrivateSearch(rc.siteid,rc.keywords)/>
		<div class="mura-control justify">
			<table class="mura-table-grid">
				<thead>
					<tr> 
						<th class="actions"></th>
						<th class="var-width">
							<cfoutput>#$.getBean('settingsManager').getSite(rc.siteid).getSite()#: #application.rbFactory.getKeyValue(session.rb,'collections.selectnewsection')#</cfoutput>
						</th>
					</tr>
				</thead>
				<tbody>
					<cfif rc.rslist.recordcount>
						<cfoutput query="rc.rslist" startrow="1" maxrows="100">	
							<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid)/>
							<cfset zoomText=$.dspZoomNoLinks(crumbdata,"&raquo;")>
							<cfif rc.rslist.type neq 'File' and rc.rslist.type neq 'Link'>
								<cfset counter=counter+1/>
								<tr <cfif not(counter mod 2)>class="alt"</cfif>>
									<td class="actions">
										<ul><li class="add"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.add')#" href="javascript:;" onClick="feedManager.addContentFilter('#rc.rslist.contentid#','#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.rslist.type#'))#','#esapiEncode('javascript','mura-opt-#rc.rslist.contentid#')#'); return false;"><i class="mi-plus-circle"></i></a></li></ul>
									</td>
									<td class="var-width" id="#esapiEncode('html_attr','mura-opt-#rc.rslist.contentid#')#">#zoomText#</td>
								</tr>
							</cfif>
						</cfoutput>
					<cfelse>
						<cfoutput>
							<tr class="alt"> 
								<td class="noResults" colspan="2">#application.rbFactory.getKeyValue(session.rb,'collections.nosearchresults')#</td>
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
			</table>
		</cfif>
		<cfif listLen(rc.contentPoolID) gt 1>
			<cfloop list="#rc.contentPoolID#" index="p">
				<cfif p neq rc.siteid>
					<cfset rc.rsList=application.contentManager.getPrivateSearch(p,rc.keywords)/>
					<table class="mura-table-grid">
						<thead>
							<tr> 
								<th class="var-width">
									<cfoutput>#$.getBean('settingsManager').getSite(p).getSite()#: #application.rbFactory.getKeyValue(session.rb,'collections.selectnewsection')#</cfoutput>
								</th>
								<th class="actions">&nbsp;</th>
							</tr>
						</thead>
						<tbody>
							<cfif rc.rslist.recordcount>
								<cfoutput query="rc.rslist" startrow="1" maxrows="100">	
									<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, p)/>
									<cfset zoomText=$.dspZoomNoLinks(crumbdata,"&raquo;")>
									<cfif rc.rslist.type neq 'File' and rc.rslist.type neq 'Link'>
										<cfset counter=counter+1/>
										<tr <cfif not(counter mod 2)>class="alt"</cfif>>
											<td class="var-width" id="#esapiEncode('html_attr','mura-opt-#p#-#rc.rslist.contentid#')#">#zoomText#</td>
											<td class="actions">
												<ul><li class="add"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.add')#" href="javascript:;" onClick="feedManager.addContentFilter('#rc.rslist.contentid#','#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.rslist.type#'))#','#esapiEncode('javascript','mura-opt-#p#-#rc.rslist.contentid#')#'); return false;"><i class="mi-plus-circle"></i></a></li></ul>
											</td>
										</tr>
									</cfif>
								</cfoutput>
							<cfelse>
								<cfoutput>
									<tr class="alt"> 
										<td class="noResults" colspan="2">#application.rbFactory.getKeyValue(session.rb,'collections.nosearchresults')#</td>
									</tr>
								</cfoutput>
							</cfif>
						</tbody>
					</table>
				</div><!-- /.mura-control -->	
			</cfif>
		</cfloop>
	</cfif>
</cfif>