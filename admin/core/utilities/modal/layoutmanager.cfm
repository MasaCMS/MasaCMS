<style>
	.mura-sidebar {
		font-family: Helvetica, sans-serif;
		font-size: 12px;
		position: absolute;
		top: 100%;
		height: calc(100vh - 32px);
		background: #fff;
		
		width: 350px;
		
		transform: translateX(-300px);
		opacity: 0;
		
		transition: all .3s ease;
	}

	.mura-sidebar select {
		width:250px;
	}
	
	.mura-sidebar.active:hover {
		transform: translateX(0);
		opacity: 1;
	}

	.mura-sidebar.active.mura-sidebar--dragging {
		transform: translateX(-300px);
		opacity: 0;
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


	.mura-displayregion {
		min-height: 15px;
	}

	.mura-object.active:hover, .mura-async-object.active[data-object="folder"]:hover {
		background: #f7f7f7;
		cursor: pointer;
	}
	
	.mura-sidebar__objects-list__object-item + .mura-sidebar__objects-list__object-item {
		border-top: 1px solid rgba(0,0,0,.05);
	}
					
	.mura-var-target {
		border-bottom: dotted #ff0000;
		margin-bottom: -1px;
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
</style>
<cfoutput>
<div class="mura-sidebar">
	<div class="mura-sidebar__objects-list">
		<div class="mura-sidebar__objects-list__object-group">
			<div class="mura-sidebar__objects-list__object-group-heading">
				<select name="classSelector" onchange="mura.loadObjectClass('#esapiEncode("Javascript",$.content('siteid'))#',this.value,'','#$.content('contenthistid')#','#$.content('parentid')#','#$.content('contenthistid')#',0);">
				<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectobjecttype')#</option>
                <option value="system">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.system')#</option>
                <option value="navigation">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.navigation')#</option>
                <cfif application.settingsManager.getSite($.event('siteid')).getDataCollection()>
	                <option value="form">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forms')#</option>
	            </cfif>
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
            	<option value="plugins">#application.rbFactory.getKeyValue(session.rb,'layout.plugins')#</option>
              </select>

			</div>
		</div>

		<div id="classListContainer" class="mura-sidebar__objects-list__object-group" style="display:none">
			<div class="mura-sidebar__objects-list__object-group-heading">Select Object</div>
			<div class="mura-sidebar__object-group-items" id="classList">
			</div>
		</div>

	</div>
</div>

<script>
mura.ready(function(){
	mura.adminpath='#variables.$.globalConfig("adminPath")#';
	mura.loader().loadjs('#variables.$.globalConfig("adminpath")#/assets/js/layoutmanager.js');
});
</script>
</cfoutput>