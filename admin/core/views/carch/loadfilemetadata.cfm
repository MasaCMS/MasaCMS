<cfset request.layout=false>
<cfset fileMetaData=$.getBean('fileMetaData').loadBy(fileid=rc.fileid,contenthistid=rc.contenthistid,siteid=rc.siteid)>
<cfoutput>
<div class="tabbable">
	<ul class="nav nav-tabs tabs initActiveTab">
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
	<div class="tab-content row-fluid">	
		<div id="tabFileMetaBasic" class="tab-pane active">	
			<div class="fieldset">
			 	<cfif fileMetaData.hasImageFileExt()>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.image')#
					</label>
					<div class="controls">
						<img src="#fileMetaData.getUrlForImage('medium')#"/>
					</div>
				</div>
				</cfif>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.caption')#
					</label>
					<div class="controls">
						<textarea id="file-caption" data-property="caption" class="filemeta span12 htmlEditor">#fileMetaData.getCaption()#</textarea>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.credits')#
					</label>
					<div class="controls">
						<textarea id="file-credits" data-property="credits" class="filemeta span12 htmlEditor">#fileMetaData.getCredits()#</textarea>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.alttext')#
					</label>
					<div class="controls">
						<input type="text" data-property="alttext" value="#esapiEncode('html_attr',fileMetaData.getAltText())#"  maxlength="255" class="filemeta span12">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.updatedefaults')#
					</label>
					<div class="controls checkbox">
						<input type="checkbox" id="filemeta-setasdefault"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.setasdefault')#
					</div>
				</div>
				<!---<input type="hidden" data-property="property" value="#esapiEncode('html_attr',rc.property)#" class="filemeta">--->
			</div>
		</div>
		<div id="tabFileMetaExifData" class="tab-pane">
			<cfset gpsList="GPS Altitude,GPS Altitude Ref,GPS Latitude,GPS Latitude Ref,GPS Longitude,GPS Longitude Ref,GPS Img Direction,GPS Time-Stamp">
			<div class="fieldset">
				<cfloop list="#gpsList#" index="k">
					<div class="control-group">
						<label class="control-label">
							#k#
						</label>
						<div class="controls">
							<input type="text" data-property="#k#" value="#esapiEncode('html_attr',fileMetaData.getExifTag(k))#" class="exif span12">
						</div>
					</div>
				</cfloop>
			</div>
			
		</div>
		<div id="tabFileMetaAdvanced" class="tab-pane">
			<div class="fieldset">
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteid')#
					</label>
					<div class="controls">
						<input type="text" data-property="remoteid" value="#esapiEncode('html_attr',fileMetaData.getRemoteID())#"  maxlength="255" class="filemeta span12">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteurl')#
					</label>
					<div class="controls">
						<input type="text" data-property="remoteurl" value="#esapiEncode('html_attr',fileMetaData.getRemoteURL())#"  maxlength="255" class="filemeta span12">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotepublicationdate')#
					</label>
					<div class="controls">
						<input type="text" data-property="remotepubdate" value="#LSDateFormat(fileMetaData.getRemotePubDate(),session.dateKeyFormat)#"  maxlength="255" class="filemeta span12 datepicker">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesource')#
					</label>
					<div class="controls">
						<input type="text" data-property="remotesource" value="#esapiEncode('html_attr',fileMetaData.getRemoteSource())#"  maxlength="255" class="filemeta span12">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesourceurl')#
					</label>
					<div class="controls">
						<input type="text" data-property="remotesourceurl" value="#esapiEncode('html_attr',fileMetaData.getRemoteSourceURL())#"  maxlength="255" class="filemeta span12">
					</div>
				</div>
			</div>
		</div>
	</div>
</div>	
</cfoutput>