<cfoutput>
<div id="mura-sidebar-container" class="mura" style="display:none">
<div class="mura__layout-manager__controls">

	<div class="mura__layout-manager__controls__scrollable">

		<div class="mura__layout-manager__controls__objects">

			<div id="mura-sidebar-objects" class="mura-sidebar__objects-list">
			 	<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<div class="mura-sidebar__objects-list__object-group-instruction">#application.rbFactory.getKeyValue(session.rb,'sitemanager.dragtopage')#:</div>
					</div>
					<div class="mura-sidebar__objects-list__object-group-items">
						<cfset contentRendererUtility=$.getBean('contentRendererUtility')>
						<cfset displayObjects=$.siteConfig('displayObjects')>
						<cfset objectKeys=listSort(structKeylist(displayObjects),'textNoCase')>
						<cfloop list="#objectKeys#" index="key">
							<cftry>
								<cfif (displayobjects['#key#'].contenttypes eq '*'
									or listFindNoCase(displayobjects['#key#'].contenttypes,$.content('type'))
									or listFindNoCase(displayobjects['#key#'].contenttypes,$.content('type') & '/' & $.content('subtype'))
									or listFindNoCase(displayobjects['#key#'].contenttypes,$.content('subtype'))
								) and not (
									 listFindNoCase(displayobjects['#key#'].omitcontenttypes,$.content('type'))
									or listFindNoCase(displayobjects['#key#'].omitcontenttypes,$.content('type') & '/' & $.content('subtype'))
									or listFindNoCase(displayobjects['#key#'].omitcontenttypes,$.content('subtype'))
								)
								and evaluate(displayobjects['#key#'].condition)>
									#contentRendererUtility.renderObjectClassOption(
										object=displayObjects[key].object,
										objectid='',
										objectname=displayObjects[key].name,
										objecticonclass=displayObjects[key].iconclass
									)#

								</cfif>
								<cfcatch>
										<cfset writeLog(type="Error", file="exception", text="Error rendering display object as option in sidebar: #serializeJSON(displayObjects[key])#")>
								</cfcatch>
							</cftry>
						</cfloop>
					</div>

					<cfif $.content('type') neq 'Variation'>
						<cfif this.legacyobjects>
							<button id="mura-objects-legacy-btn" class="btn mura-primary"><i class="mi-object-ungroup"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.legacyobjects')#</button>
						</cfif>
						<cfif listLen(request.muraActiveRegions) lt $.siteConfig('columnCount')>
							<button id="mura-objects-openregions-btn" class="btn"><i class="mi-columns"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.additionaldisplayregions')#</button>
						</cfif>
					</cfif>
				</div>
			</div>
			<cfif $.content('type') neq 'Variation' and this.legacyobjects>
			<div id="mura-sidebar-objects-legacy" class="mura-sidebar__objects-list" style="display:none">
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<button class="mura-objects-back-btn btn btn-secondary">
							<i class="mi-arrow-left"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.back')#
						</button>
						<h3>#application.rbFactory.getKeyValue(session.rb,'sitemanager.legacyobjects')#</h3>
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
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.selectobject')#
					</div>
					<div class="mura-sidebar__object-group-items" id="classList"></div>
				</div>

			</div>
			</cfif>

			<div id="mura-sidebar-configurator" style="display:none">
				<!---
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
					<a href="##" class="mura-objects-back-btn" class="btn mura-primary"><i class="mi-arrow-left"></i> Back</a>
					</div>
				</div>
				--->
				<iframe src="" data-preloadsrc="#$.siteConfig().getAdminPath(complete=completeurls)#?muraAction=carch.frontendconfigurator&siteid=#$.content('siteid')#&preloadOnly=true&layoutmanager=true&compactDisplay=true&cacheid=#createUUID()#" id="frontEndToolsSidebariframe" scrolling="false" frameborder="0" style="overflow:hidden;width:100%;" name="frontEndToolsSidebariframe">
				</iframe>

			</div>

			<div id="mura-sidebar-editor" style="display:none">
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<h3>#application.rbFactory.getKeyValue(session.rb,'sitemanager.editingcontent')#</h3>
						<button class="mura-objects-back-btn btn mura-primary" id="mura-deactivate-editors"><i class="mi-check"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.doneediting')#</button>
					</div>
				</div>

				<div id="classListContainer" class="mura-sidebar__objects-list__object-group" style="display:none">
					<div class="mura-sidebar__objects-list__object-group-heading">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.selectobject')#
					</div>
					<div class="mura-sidebar__object-group-items" id="classList"></div>
				</div>

			</div>
		</div>
	</div>

</div>
<cfif listLen(request.muraActiveRegions) lt $.siteConfig('columnCount')>
	<div class="mura__layout-manager__display-regions">
		<div class="mura__layout-manager__display-regions__X">
			<p><button id="mura-objects-closeregions-btn" class="btn mura-primary">Close <i class="mi-angle-right"></i></button><p>
			<h3>Additional Display Regions</h3>

			<cfset regionNames=$.siteConfig('columnNames')>
			<cfset regionCount=$.siteConfig('columnCount')>

			<cfloop from="1" to="#regionCount#" index="r">
			<cfif not listFind(request.muraActiveRegions,r) and listLen(regionNames,'^') gte r>
				<div class="mura-region__item">
					<h4>#esapiEncode('html',listGetAt(regionNames,r,'^'))#</h4>
					#$.dspObjects(columnid=r,allowInheritance=false)#
				</div>
			</cfif>
		</cfloop>
		</div>
	</div>
</cfif>
</div>
<script>
Mura(function(){
	if(typeof Mura.deInitLayoutManager != 'undefined'
		&& typeof Mura.editing != 'undefined'
		&& Mura.editing){
			Mura.deInitLayoutManager();
	}
	Mura.loader().load('#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/js/layoutmanager.js',
		function(){
			<cfif $.content('type') eq 'Variation'>
			if(!Mura('.mxp-editable').length){
				Mura('##adminQuickEdit').remove();
				//Mura('##adminQuickEdit').css('text-decoration','line-through');
			} else {
				//Mura('##mura-edit-var-targetingjs-text').html('Re-Select Editable Content')
			}
			</cfif>
			Mura('body').addClass('mura-sidebar-state__hidden--right');
			Mura('body').removeClass('mura-sidebar-state__pushed--right');
			Mura('##mura-sidebar-container').show();
			Mura('##mura-objects-legacy-btn').click(function(e){
				e.preventDefault();
				MuraInlineEditor.sidebarAction('showlegacyobjects');
			});
			Mura('##mura-objects-openregions-btn').click(function(e){
				e.preventDefault();
				var el=Mura('body');
				if(el.hasClass('mura-regions-state__pushed--right')){
					el.removeClass('mura-regions-state__pushed--right');
				} else {
					el.addClass('mura-regions-state__pushed--right');
				}
			});
			Mura('##mura-objects-closeregions-btn').click(function(e){
				e.preventDefault();
				Mura('body').removeClass('mura-regions-state__pushed--right');
			});
			Mura('.mura-objects-back-btn').click(function(e){
				e.preventDefault();
				MuraInlineEditor.sidebarAction('showobjects');
			});
			//Mura('.mura-region.mura-editable').attr('style','clear:both;');
			Mura.rb.saveasdraft='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#';
			Mura.adminpath='#variables.$.siteConfig().getAdminPath(complete=completeurls)#';
		}
	);
});
</script>
</cfoutput>
