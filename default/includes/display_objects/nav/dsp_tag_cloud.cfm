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

<!---
<cfif request.muraFrontEndRequest and this.asyncObjects>
	<cfoutput>
		<div class="mura-async-object" 
			data-object="tag_cloud">
		</div>
	</cfoutput>
<cfelse>
--->
	<cfsilent>
		<cfset variables.tags=variables.$.getBean('contentGateway').getTagCloud(variables.$.event('siteID'),arguments.parentID,arguments.categoryID,arguments.rsContent,'00000000000000000000000000000000000',arguments.taggroup) />
		<cfset variables.tagValueArray = ListToArray(ValueList(variables.tags.tagCount))>
		<cfset variables.max = ArrayMax(variables.tagValueArray)>
		<cfset variables.min = Arraymin(variables.tagValueArray)>
		<cfset variables.diff = variables.max - variables.min>
		<cfset variables.distribution = variables.diff>
		<cfset variables.rbFactory=getSite().getRbFactory()>

		<cfif not isDefined("arguments.filename")>
			<cfset arguments.filename=variables.$.event('currentFilenameAdjusted')>
		</cfif>
	</cfsilent>
	<cfoutput>
		<div id="svTagCloud" class="mura-tag-cloud #this.tagCloudWrapperClass#">
			<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('tagcloud.tagcloud')#</#variables.$.getHeaderTag('subHead1')#>
			<cfif variables.tags.recordcount>
				<ol>
					<cfloop query="variables.tags">
						<cfsilent>
							<cfif variables.tags.tagCount EQ variables.min>
								<cfset variables.class="not-popular" />
							<cfelseif variables.tags.tagCount EQ variables.max>
								<cfset variables.class="ultra-popular" />
							<cfelseif variables.tags.tagCount GT (variables.min + (variables.distribution/2))>
								<cfset variables.class="somewhat-popular" />
							<cfelseif variables.tags.tagCount GT (variables.min + variables.distribution)>
								<cfset variables.class="mediumTag" />
							<cfelse>
								<cfset variables.class="not-very-popular" />
							</cfif>
							<cfset variables.args = [] />
							<cfset variables.args[1] = variables.tags.tagcount />
						</cfsilent>
						<li class="#variables.class#">
							<span>
								<cfif variables.tags.tagcount gt 1>
									#variables.rbFactory.getResourceBundle().messageFormat(variables.$.rbKey('tagcloud.itemsare'), variables.args)#
								<cfelse>
									#variables.rbFactory.getResourceBundle().messageFormat(variables.$.rbKey('tagcloud.itemis'), variables.args)#
								</cfif>
							</span>
							<cfif len(arguments.taggroup)>
								<a href="#variables.$.createHREF(filename='#arguments.filename#/tag/#urlEncodedFormat(variables.tags.tag)#/_/taggroup/#urlEncodedFormat(arguments.taggroup)#')#" class="tag">#HTMLEditFormat(variables.tags.tag)#</a>
							<cfelse>
								<a href="#variables.$.createHREF(filename='#arguments.filename#/tag/#urlEncodedFormat(variables.tags.tag)#')#" class="tag">#HTMLEditFormat(variables.tags.tag)#</a>
							</cfif>
						</li>
					</cfloop>
				</ol>
			<cfelse>
				<p>#variables.$.rbKey('tagcloud.notags')#</p>
			</cfif>
		</div>
	</cfoutput>
<!---</cfif>--->