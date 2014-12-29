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
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

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
<cfsilent>
	<cfset variables.data.sortby=variables.formBean.getValue('sortBy')/>
	<cfset variables.data.sortDirection=variables.formBean.getValue('sortDirection')/>
	<cfset variables.data.siteid=variables.formBean.getValue('siteID')/>
	<cfset variables.data.contentid=variables.formBean.getValue('contentID')/>
	<cfset variables.data.keywords=request.keywords />
	<cfif Right(variables.formBean.getValue('ResponseDisplayFields'), 1) neq '~'>
		<cfset variables.data.fieldnames=Replace(ListLast(variables.formBean.getValue('ResponseDisplayFields'),"~"),"^",",","ALL")/>
	<cfelse>
		<cfset variables.data.fieldnames=application.dataCollectionManager.getCurrentFieldList(variables.data.contentid)/>
	</cfif>
	<cfset variables.rsdata=application.dataCollectionManager.getdata(variables.data)/>
</cfsilent>
<div id="dsp_list" class="dataResponses">
	<cfif variables.rsdata.recordcount and ListLen(variables.data.fieldnames)>
		<cfsilent>
			<cfset variables.nextN=variables.$.getBean('utility').getnextN(variables.rsdata,variables.formBean.getValue('nextN'),request.StartRow)>
		</cfsilent>
		<cfoutput>
			<#variables.$.getHeaderTag('subHead2')#>
				#HTMLEditFormat(variables.formBean.getValue('title'))# #variables.$.rbKey('form.dataresponses.responses')#
			</#variables.$.getHeaderTag('subHead2')#>
		</cfoutput>
		<table class="<cfoutput>#this.dataResponseTableClass#</cfoutput>">
			<thead>
				<tr>
					<cfloop list="#variables.data.fieldnames#" index="variables.f">
						<th>
							<cfoutput>#variables.f#</cfoutput>
						</th>
					</cfloop>
				</tr>
			</thead>
			<tbody>
				<cfoutput 
					query="variables.rsdata" 
					startrow="#request.startRow#" 
					maxrows="#variables.nextN.RecordsPerPage#">
					<tr>
						<cfsilent>
							<cfwddx action="wddx2cfml" input="#variables.rsdata.data#" output="variables.info">
						</cfsilent>
						<cfloop list="#variables.data.fieldnames#" index="variables.f">
							<cfsilent>
								<cftry>
									<cfset variables.fValue=variables.info['#variables.f#']>
									<cfcatch>
										<cfset variables.fValue="">
									</cfcatch>
								</cftry>
							</cfsilent>
							<td>
								<cfif findNoCase('attachment',variables.f) and isValid("UUID",variables.fvalue)>
									<a  href="http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/index.cfm/_api/render/file//index.cfm?fileID=#variables.fvalue#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.viewattachment')#</a>
								<cfelse>
									<a href="./?dataResponseView=detail&amp;responseid=#variables.rsdata.responseid#">
										#HTMLEditFormat(variables.fvalue)#
									</a>
								</cfif>	
							</td>
						</cfloop>
					</tr>
				</cfoutput>
			</tbody>
		</table>
		<cfif variables.nextN.numberofpages gt 1>
			<cfoutput>
				<div class="mura-next-n navSequential #this.dataResponsePaginationClass#">
					<ul>
						<cfif variables.nextN.currentpagenumber gt 1>
							<li>
								<a href="./?startrow=#variables.nextN.previous#&amp;categoryID=#variables.$.event('categoryID')#&amp;relatedID=#request.relatedID#">&laquo;&nbsp;#variables.$.rbKey('list.previous')#</a>
							</li>
						</cfif>
						<cfloop from="#variables.nextN.firstPage#"  to="#variables.nextN.lastPage#" index="i">
							<cfif variables.nextN.currentpagenumber eq i>
								<li class="current active"><span>#i#</span></li>
							<cfelse>
								<li>
									<a href="./?startrow=#evaluate('(#i#*#variables.nextN.recordsperpage#)-#variables.nextN.recordsperpage#+1')#&amp;categoryID=#variables.$.event('categoryID')#&amp;relatedID=#request.relatedID#">#i#</a>
								</li>
							</cfif>
						</cfloop>
						<cfif variables.nextN.currentpagenumber lt variables.nextN.NumberOfPages>
							<li>
								<a href="./?startrow=#variables.nextN.next#&amp;categoryID=#variables.$.event('categoryID')#&amp;relatedID=#request.relatedID#">#variables.$.rbKey('list.next')#&nbsp;&raquo;</a>
							</li>
						</cfif>
					</ul>
				</cfoutput>
			</div>
		</cfif>
	<cfelseif variables.rsdata.recordcount and not ListLen(variables.data.fieldnames)>
		<div class="alert alert-info">
			<cfoutput>#variables.$.rbKey('form.dataresponses.nofieldnames')#</cfoutput>
		</div>
	<cfelse>
		<div class="alert alert-info">
			<cfoutput>#variables.$.rbKey('form.dataresponses.nodata')#</cfoutput>
		</div>
	</cfif>
</div>
