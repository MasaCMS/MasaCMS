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
<cfset tabList=listAppend(tabList,"tabRelatedcontent")>
<cfset subtype = application.classExtensionManager.getSubTypeByName(rc.contentBean.getType(), rc.contentBean.getSubType(), rc.contentBean.getSiteID())>
<cfset relatedContentSets = subtype.getRelatedContentSets()>

<cfoutput>
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-relatedcontent">
			<h4 class="mura-panel-title">
				<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-relatedcontent" aria-expanded="false" aria-controls="panel-relatedcontent">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.relatedcontent")#</a>
			</h4>
		</div>
		<div id="panel-relatedcontent" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-relatedcontent" aria-expanded="false" style="height: 0px;">
			<div class="mura-panel-body">


				<!--- 'big ui' flyout panel --->
				<!--- todo: resource bundle key for 'manage related content' --->
				<div class="bigui" id="bigui__related" data-label="Manage Related Content">
					<div class="bigui__title">#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.relatedcontent"))#</div>
					<div class="bigui__controls">

						<span id="extendset-container-tabrelatedcontenttop" class="extendset-container"></span>
						<div id="selectRelatedContent"><!--- target for ajax ---></div>
						<div id="selectedRelatedContent" class="mura-control-group">

					</div>
				</div> <!--- /.bigui --->

			</div>
			<input id="relatedContentSetData" type="hidden" name="relatedContentSetData" value="" />	
		</div>
	</div>
</div> 
</cfoutput>