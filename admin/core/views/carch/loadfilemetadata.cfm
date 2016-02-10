<cfset request.layout=false>
<cfset fileMetaData=$.getBean('fileMetaData').loadBy(fileid=rc.fileid,contenthistid=rc.contenthistid,siteid=rc.siteid)>
<cfoutput>
<div class="block block-constrain">
	<ul class="mura-tabs nav-tabs nav-tabs-alt initActiveTab">
		<li class="active">
			<a href="##tabFileMetaBasic" data-toggle="tab"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.tabs.basic')#</span></a>
		</li>
		<li>
			<a href="##tabFileMetaExifData" data-toggle="tab"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.exifdata')#</span></a>
		</li>
		<li>
			<a href="##tabFileMetaAdvanced" data-toggle="tab"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.tabs.advanced')#</span></a>
		</li>
	</ul>
	<div class="tab-content block-content">
		<div id="tabFileMetaBasic" class="tab-pane active">
			<!-- block -->
		  	<div class="block block-bordered">
				<div class="block-header bg-gray-lighter">
					<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.tabs.basic')#</h3>
				</div>
				<div class="block-content">
				 	<cfif fileMetaData.hasImageFileExt()>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.image')#
						</label>
						<div class="mura-control">
							<img src="#fileMetaData.getUrlForImage('medium')#"/>
						</div>
					</div>
					</cfif>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.caption')#
						</label>
						<textarea id="file-caption" data-property="caption" class="filemeta span12 htmlEditor">#fileMetaData.getCaption()#</textarea>
					</div>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.credits')#
						</label>
						<textarea id="file-credits" data-property="credits" class="filemeta span12 htmlEditor">#fileMetaData.getCredits()#</textarea>
					</div>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.alttext')#
						</label>
						<input type="text" data-property="alttext" value="#esapiEncode('html_attr',fileMetaData.getAltText())#"  maxlength="255" class="filemeta">
					</div>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.updatedefaults')#
						</label>
						<label class="checkbox" for="filemeta-setasdefault">
							<input type="checkbox" id="filemeta-setasdefault"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.setasdefault')#
						</label>
					</div>
					<!---<input type="hidden" data-property="property" value="#esapiEncode('html_attr',rc.property)#" class="filemeta">--->
				</div>
			</div>
		</div>
		<div id="tabFileMetaExifData" class="tab-pane">
			<!-- block -->
			  <div class="block block-bordered">
				<div class="block-header bg-gray-lighter">
					<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.exifdata')#</h3>
	  			</div>
  				<div class="block-content">
				<cfset gpsList="GPS Altitude,GPS Altitude Ref,GPS Latitude,GPS Latitude Ref,GPS Longitude,GPS Longitude Ref,GPS Img Direction,GPS Time-Stamp">
				<cfloop list="#gpsList#" index="k">
					<div class="mura-control-group">
						<label class="mura-control-label">
							#k#
						</label>
						<input type="text" data-property="#k#" value="#esapiEncode('html_attr',fileMetaData.getExifTag(k))#" class="exif">
					</div>
				</cfloop>
				</div>
			</div>
		</div>
		<div id="tabFileMetaAdvanced" class="tab-pane">
			<!-- block -->
		  	<div class="block block-bordered">
				<div class="block-header bg-gray-lighter">
					<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.tabs.advanced')#</h3>
				</div>
				<div class="block-content">
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteid')#
						</label>
						<input type="text" data-property="remoteid" value="#esapiEncode('html_attr',fileMetaData.getRemoteID())#"  maxlength="255" class="filemeta">
					</div>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteurl')#
						</label>
						<input type="text" data-property="remoteurl" value="#esapiEncode('html_attr',fileMetaData.getRemoteURL())#"  maxlength="255" class="filemeta">
					</div>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotepublicationdate')#
						</label>
						<input type="text" data-property="remotepubdate" value="#LSDateFormat(fileMetaData.getRemotePubDate(),session.dateKeyFormat)#"  maxlength="255" class="filemeta datepicker">
					</div>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesource')#
						</label>
						<input type="text" data-property="remotesource" value="#esapiEncode('html_attr',fileMetaData.getRemoteSource())#"  maxlength="255" class="filemeta">
					</div>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesourceurl')#
						</label>
						<input type="text" data-property="remotesourceurl" value="#esapiEncode('html_attr',fileMetaData.getRemoteSourceURL())#"  maxlength="255" class="filemeta">
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</cfoutput>
