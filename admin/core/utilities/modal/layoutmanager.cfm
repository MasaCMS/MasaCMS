<cfoutput>
<div id="mura-sidebar-container" class="mura" style="display:none">
<div class="mura__layout-manager__controls">
					
	<div class="mura__layout-manager__controls__scrollable">
	
		<div class="mura__layout-manager__controls__objects">
	
			<div id="mura-sidebar-objects" class="mura-sidebar__objects-list">
			 	<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<cfif $.content('type') neq 'Variation'>
						<button id="mura-objects-legacy-btn" class="btn btn-default">View Legacy Objects</button>
						</cfif>
						<h3>Content Objects</h3>
					</div>
					<div class="mura-sidebar__objects-list__object-group-items">
						<cfset contentRendererUtility=$.getBean('contentRendererUtility')>

						<cfset displayObjects=$.siteConfig('displayObjects')>
						
						<cfset objectKeys=listSort(structKeylist(displayObjects),'textNoCase')>
						<cfloop list="#objectKeys#" index="key">
							<cfif (displayobjects['#key#'].contenttypes eq '*'
							or listFindNoCase(displayobjects['#key#'].contenttypes,$.content('type'))
							or listFindNoCase(displayobjects['#key#'].contenttypes,$.content('type') & '/' & $.content('subtype'))
							or listFindNoCase(displayobjects['#key#'].contenttypes,$.content('subtype'))
							)
							and evaluate(displayobjects['#key#'].condition)>

								#contentRendererUtility.renderObjectClassOption(
									object=displayObjects[key].object,
									objectid='',
									objectname=displayObjects[key].name
								)#

							</cfif>
						</cfloop>
					</div>
				</div>
			</div>
			<cfif $.content('type') neq 'Variation'>
			<div id="mura-sidebar-objects-legacy" class="mura-sidebar__objects-list" style="display:none">
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<button class="mura-objects-back-btn btn btn-default">
							<i class="icon-circle-arrow-left"></i> Back
						</button>
						<h3>Legacy Objects</h3>
					</div>
					<div class="mura-sidebar__objects-list__object-group-items controls">
						<select name="classSelector" onchange="mura.loadObjectClass('#esapiEncode("Javascript",$.content('siteid'))#',this.value,'','#$.content('contenthistid')#','#$.content('parentid')#','#$.content('contenthistid')#',0);">
						<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectobjecttype')#</option>
			            <cfif application.settingsManager.getSite($.event('siteid')).getemailbroadcaster()>
			                <option value="mailingList">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mailinglists')#</option>
			            </cfif> 
		                <cfif application.settingsManager.getSite($.event('siteid')).getAdManager()>
		                  <option value="adzone">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adregions')#</option>
		                </cfif>
		                <!--- <option value="category">Categories</option> --->
		                <option value="folder">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.Folders')#</option>
		                <option value="calendar">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendars')#</option>
		                <option value="gallery">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.galleries')#</option>
		                <option value="component">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#</option>
		                <cfif application.settingsManager.getSite($.event('siteid')).getHasfeedManager()>
		                  <option value="localFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexes')#</option>
		                  <option value="slideshow">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshows')#</option>
		                  <option value="remoteFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeeds')#</option>
		                </cfif>
		              </select>

					</div>
				</div>

				<div id="classListContainer" class="mura-sidebar__objects-list__object-group" style="display:none">
					<div class="mura-sidebar__objects-list__object-group-heading">
						Select Object
					</div>
					<div class="mura-sidebar__object-group-items" id="classList"></div>
				</div>
		
			</div>
			</cfif>
			
			<div id="mura-sidebar-configurator" style="display:none">
				<!---
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
					<a href="##" class="mura-objects-back-btn" class="btn btn-default"><i class="icon-circle-arrow-left"></i> Back</a>
					</div>
				</div>
				--->
				<iframe src="" id="frontEndToolsSidebariframe" scrolling="false" frameborder="0" style="overflow:hidden" name="frontEndToolsSidebariframe">
				</iframe>
			
			</div>
			
			<div id="mura-sidebar-editor" style="display:none">
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<h3>Editing Content</h3>
						<button class="mura-objects-back-btn btn btn-default" id="mura-deactivate-editors">Done Editing</button>
					</div>
				</div>

				<div id="classListContainer" class="mura-sidebar__objects-list__object-group" style="display:none">
					<div class="mura-sidebar__objects-list__object-group-heading">
						Select Object
					</div>
					<div class="mura-sidebar__object-group-items" id="classList"></div>
				</div>
		
			</div>
		</div>
	</div>
	
</div>
</div>
<script>
mura.ready(function(){

	mura('body').addClass('mura-sidebar-state__hidden--right');
	mura('##mura-sidebar-container').show();
	mura('##mura-objects-legacy-btn').click(function(e){
		e.preventDefault();
		muraInlineEditor.sidebarAction('showlegacyobjects');
	});

	mura('.mura-objects-back-btn').click(function(e){
		e.preventDefault();
		muraInlineEditor.sidebarAction('showobjects');
	});

	//mura('.mura-region.mura-editable').attr('style','clear:both;');
	mura.rb.saveasdraft='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#';
	mura.adminpath='#variables.$.globalConfig("adminPath")#';
	mura.loader().loadjs('#variables.$.globalConfig("adminpath")#/assets/js/layoutmanager.js');
});
</script>
</cfoutput>


