<style>
	*[draggable=true] {
	  -moz-user-select:none;
	  -khtml-user-drag: element;
	  cursor: move;
	}
	
	/* 
		DEV NOTE
		ie10 does not allow use of 'inherit' on calculated parent
		example: .mura-sidebar uses a calculated height, therefore the child elements cannot use 'inherit' for height
		http://stackoverflow.com/questions/19423384/css-less-calc-method-is-crashing-my-ie10
	*/
	
	.mura-sidebar__objects-list {
		height: 100%;
		width: 100%;
		overflow: scroll;
	}
	
	.mura-sidebar__objects-list__object-group {
		background: #fff;
		margin: 15px;
	}
	
	.mura-sidebar__objects-list__object-group-heading {
		box-sizing: border-box;
		padding: .5em;
		padding-right: 50px;
		
		/*font-weight: bold;
		
		border-bottom: 3px solid rgba(0,0,0,.05);*/
	}
	
	.mura-sidebar__objects-list__object-item {
		box-sizing: border-box;
		padding: .5em;
		padding-right: 50px;
	}
	
	.mura-sidebar__objects-list__object-item:hover {
		background: #f7f7f7;
		cursor: pointer;
	}


	.mura-region-local {
		min-height: 15px;
	}

	.mura-object.active:hover, .mura-async-object.active[data-object="folder"]:hover {
		background: #f7f7f7;
		cursor: pointer;
	}
	
	.mura-sidebar__objects-list__object-item + .mura-sidebar__objects-list__object-item {
		border-top: 1px solid rgba(0,0,0,.05);
	}
					
	.mura-drop-target {
		border-bottom: dotted #ff0000;
		margin-bottom: -1px;
	}

	.mura-object-selected {
		border-style: dotted;
		border-color: red;
	}

	/*
	body {
	    -webkit-touch-callout: none;
	    -webkit-user-select: none;
	    -khtml-user-select: none;
	    -moz-user-select: none;
	    -ms-user-select: none;
	    user-select: none;
	}
	*/

	body {
		padding-left: 0;
		transition: padding-left 0.3s ease;
	}

.-state__pushed--left {
	display: table;
	padding-left: 300px;
	
	transition: padding-left 0.3s ease;
	min-width: 100%;
	
	box-sizing: border-box;
}

.mura__layout-manager__controls {
	width: 300px;
	position: fixed;
	
	left: -300px;
	top: 0;
	bottom: 0;
	
	/*z-index: 1000;*/
	
	transition: left 0.3s ease;
	
	height: 100vh;
}

.mura__layout-manager__controls__scrollable {
	height: inherit;
	width: inherit;
	overflow: scroll;
}

.mura__layout-manager__controls__objects {
	padding: 50px 10px;
}

.-state__pushed--left .mura__layout-manager__controls {
	left: 0;
	transition: left 0.3s ease;
}

.mura__layout-manager__controls {
	background-color: #FFFFFF;
}
</style>
<style>	
	
	img {
		max-width: 100%;
		height: auto;
	}
	
	hr {
		margin: 3em 0;
		border: 0;
		border-top: 1px solid #ddd;
		height: 0;
	}
	
	
	h3,
	.mura-object-meta {
		font-size: 1.5rem;
		font-weight: bold;
		text-transform: uppercase;
		color: #000;
		margin-bottom: 1em;
	}
	

	h4,
	.mura-item-meta__title {
		font-size: 1.125rem;
		color: #000;
		font-weight: bold;
	}
	
	.mura-item-meta__tags {}
	
	.mura-item-meta__tags span {
		background-color: #999;
		color: #fff;
		display: inline-block;
		padding: 3px 9px;
	}
	
	
	@media only screen and (min-width: 480px) {
		.layout-a .mura-collection-item {
			width: 25%;
			float: left;
			box-sizing: border-box;
		}
		
		.layout-b .mura-collection-item {
			width: 50%;
			float: left;
			box-sizing: border-box;
		}
		
		.layout-c .mura-collection-item {
			width: 20%;
			float: left;
			box-sizing: border-box;
		}
		
		/* large item */
		.layout-d .mura-collection-item {
			width: 100%;
			display: block;
		}
		
		/* other items */
		.layout-d .mura-collection-item + .mura-collection-item {
			width: 33.33%;
			float: left;
			box-sizing: border-box;
		}
		
		.layout-e .mura-collection-item {
			position: relative;
			
			padding-left: 100px;
			min-height: 100px;
		}
		
		.layout-e .mura-item-content {
			position: absolute;
			left: 0;
		}
		
		
		
		.mura-collection::after {
			content: '';
			display: table;
			clear: both;
		}
		
		
		.layout-a .mura-collection-item:nth-child(4n+5) {
			clear: left;
		}
		
		.layout-b .mura-collection-item:nth-child(2n+3) {
			clear: left;
		}
		
		.layout-c .mura-collection-item:nth-child(5n+6) {
			clear: left;
		}
		
		.layout-d .mura-collection-item (2) {
			clear: left;
		}
		
		.layout-d .mura-collection-item (3n+5) {
			clear: left;
		}
		
		.layout-a .mura-collection-item__holder,
		.layout-b .mura-collection-item__holder,
		.layout-c .mura-collection-item__holder,
		.layout-d .mura-collection-item__holder {
			padding: 10px;
		}
	}
</style>
<cfoutput>
<div class="mura__layout-manager__controls">
					
	<div class="mura__layout-manager__controls__scrollable">
	
		<div class="mura__layout-manager__controls__objects">
	
			<div id="mura-sidebar-objects" class="mura-sidebar__objects-list">
			 	<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<cfif $.content('type') neq 'Variation'>
						<a href="##" id="mura-objects-legacy-btn">View Legacy Objects</a>
						</cfif>
						<h3>Content Objects</h3>
						
						<cfset contentRendererUtility=$.getBean('contentRendererUtility')>

						#contentRendererUtility.renderObjectClassOption(
							object='container',
							objectid='',
							objectname='Container'
						)#

						#contentRendererUtility.renderObjectClassOption(
							object='collection',
							objectid='',
							objectname='Collection'
						)#

						#contentRendererUtility.renderObjectClassOption(
							object='text',
							objectid='',
							objectname='Text'
						)#

						#contentRendererUtility.renderObjectClassOption(
							object='socialembed',
							objectid='',
							objectname='Social Embed'
						)#

						#contentRendererUtility.renderObjectClassOption(
							object='form',
							objectid='',
							objectname='Form'
						)#

						<cfif $.content('type') neq 'Variation'>
							#contentRendererUtility.renderObjectClassOption(
								object='navigation',
								objectid='',
								objectname='Navigation'
							)#

							#contentRendererUtility.renderObjectClassOption(
								object='system',
								objectid='',
								objectname='System Object'
							)#

							#contentRendererUtility.renderObjectClassOption(
								object='mailing_list',
								objectid='',
								objectname='Mailing List'
							)#
						</cfif>

						#contentRendererUtility.renderObjectClassOption(
							object='plugin',
							objectid='',
							objectname='Plugin'
						)#
						

					</div>
				</div>
			</div>
			<cfif $.content('type') neq 'Variation'>
			<div id="mura-sidebar-objects-legacy" class="mura-sidebar__objects-list" style="display:none">
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<a href="##" class="mura-objects-back-btn">&lt Back</a>
						<h3>Legacy Objects</h3>
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
				
				<a href="##" class="mura-objects-back-btn">&lt Back</a>
				
				<iframe src="" id="frontEndToolsSidebariframe" scrolling="false" frameborder="0" style="overflow:hidden" name="frontEndToolsSidebariframe">
				</iframe>
			</div>
			
			<div id="mura-sidebar-editor" class="mura-sidebar__objects-list" style="display:none">
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<h3>Editing Content</h3>
						<button class="btn" id="mura-deactivate-editors">Done</button>
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
		</div>
	</div>
	
</div>

<script>
mura.ready(function(){
	mura('##mura-objects-legacy-btn').click(function(e){
		e.preventDefault();
		muraInlineEditor.sidebarAction('showlegacyobjects');
	});

	mura('.mura-objects-back-btn').click(function(e){
		e.preventDefault();
		muraInlineEditor.sidebarAction('showobjects');
	});

	mura.adminpath='#variables.$.globalConfig("adminPath")#';
	mura.loader().loadjs('#variables.$.globalConfig("adminpath")#/assets/js/layoutmanager.js');
});
</script>
</cfoutput>


