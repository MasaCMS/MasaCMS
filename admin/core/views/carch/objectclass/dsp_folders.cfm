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
<cfsilent>
<cfset rc.rsSections = application.contentManager.getSections(rc.siteid, 'Folder')/>

<cfset pathStrings=arrayNew(1)>
<cfloop query="rc.rsSections">
	<cfset arrayAppend(pathStrings, $.dspZoomText(application.contentGateway.getCrumblist(contentid=rc.rsSections.contentid,siteid=rc.rsSections.siteid, path=rc.rsSections.path)))>
</cfloop>

<cfset queryAddColumn(rc.rsSections, "pathString", "cf_sql_varchar",pathStrings)>

<cfquery name="rc.rsSections" dbtype="query">
	select * from rc.rsSections order by pathString
</cfquery>
</cfsilent>
<cfoutput>
<div class="control-group">
	<div class="controls">
	<select name="subClassSelector" 
	        onchange="siteManager.loadObjectClass('#rc.siteid#','Folder',this.value,'#rc.contentid#','#rc.parentid#','#rc.contenthistid#',0,0);" 
	        class="dropdown">
		<option value="">
			#application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.selectFolder')#
		</option>
		<cfloop query="rc.rsSections">
			<option value="#rc.rsSections.contentID#" <cfif rc.rsSections.contentID eq rc.subclassid>selected</cfif>>#esapiEncode('html',rc.rsSections.pathString)#</option>
		</cfloop>
	</select>
	</div>
	
	<cfif rc.subclassid neq ''>
		<div class="controls">
		<select name="availableObjects" id="availableObjects" class="multiSelect" 
		        size="#evaluate((application.settingsManager.getSite(rc.siteid).getcolumnCount() * 6)-4)#" 
		        >
			<cfloop query="rc.rsSections">
				<cfif rc.rsSections.contentID eq rc.subclassid>
					<cfset title=rc.rsSections.pathString
						& ' - '  
						& application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.categorysummary')>

					<option title="#esapiEncode('html_attr',title)#" value="{'object':'category_summary','name':'#esapiEncode('javascript',title)#','objectid':'#rc.rsSections.contentid#'}">
						#esapiEncode('html',title)#
					</option>

					<cfset title=rc.rsSections.pathString 
						& ' - ' 
						& application.rbFactory.getKeyValue(session.rb, 
					                                    'sitemanager.content.fields.relatedcontent')>

					<option title="#esapiEncode('html_attr',title)#" value="{'object':'related_section_content','name':'#esapiEncode('javascript',title)#','objectid':'#rc.rsSections.contentid#'}">
						#esapiEncode('html',title)#
					</option>

					<cfset title=rc.rsSections.pathString
						& ' - ' 
						& application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.calendarnavigation')>

					<option titlie="#esapiEncode('html_attr',title)#" value="calendar_nav~#esapiEncode('html',title)#~#rc.rsSections.contentid#">
						#esapiEncode('html',title)#
					</option>

					<cfset title=rc.rsSections.pathString
						& ' - '  
						& application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.archivenavigation')>

					<option title="#esapiEncode('html_attr',title)#" value="archive_nav~#esapiEncode('html',title)#~#rc.rsSections.contentid#">
						#esapiEncode('html',title)#
					</option>
				</cfif>
			</cfloop>
		</select>
		</div>
	</cfif>
</div>
</cfoutput>