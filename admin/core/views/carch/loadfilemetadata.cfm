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
<cfset request.layout=false>
<cfset fileMetaData=$.getBean('fileMetaData').loadBy(fileid=rc.fileid,contenthistid=rc.contenthistid,siteid=rc.siteid)>
<cfoutput>
<div class="block block-constrain">
	<ul class="mura-tabs nav-tabs">
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
					<div class="block-header">
						<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.tabs.basic')#</h3>
					</div>
				<div class="block-content">
				 	<cfif fileMetaData.hasImageFileExt()>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.image')#
						</label>
						<div class="mura-control justify">
							<img src="#fileMetaData.getUrlForImage(size='medium',useProtocol=false)#"/>
						</div>
					</div>
					</cfif>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.caption')#
						</label>
						<textarea id="file-caption" data-property="caption" class="filemeta htmlEditor">#fileMetaData.getCaption()#</textarea>
					</div>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.credits')#
						</label>
						<textarea id="file-credits" data-property="credits" class="filemeta htmlEditor">#fileMetaData.getCredits()#</textarea>
					</div>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.alttext')#
						</label>
						<input type="text" data-property="alttext" value="#esapiEncode('html_attr',fileMetaData.getAltText())#"  maxlength="255" class="filemeta">
					</div>
					<div class="mura-control-group">
<!--- 						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.updatedefaults')#
						</label> --->
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
					<div class="block-header">
						<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.exifdata')#</h3>
	  			</div>
  				<div class="block-content">
				<cfset gpsList="GPS Altitude,GPS Altitude Ref,GPS Latitude,GPS Latitude Ref,GPS Longitude,GPS Longitude Ref,GPS Img Direction,GPS Time-Stamp">
				<cfloop list="#gpsList#" index="k">
					<div class="mura-control-group">
						<label>
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
					<div class="block-header">
						<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.tabs.advanced')#</h3>
				</div>
				<div class="block-content">
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteid')#
						</label>
						<input type="text" data-property="remoteid" value="#esapiEncode('html_attr',fileMetaData.getRemoteID())#"  maxlength="255" class="filemeta">
					</div>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteurl')#
						</label>
						<input type="text" data-property="remoteurl" value="#esapiEncode('html_attr',fileMetaData.getRemoteURL())#"  maxlength="255" class="filemeta">
					</div>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotepublicationdate')#
						</label>
						<input type="text" data-property="remotepubdate" value="#LSDateFormat(fileMetaData.getRemotePubDate(),session.dateKeyFormat)#"  maxlength="255" class="filemeta datepicker">
					</div>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesource')#
						</label>
						<input type="text" data-property="remotesource" value="#esapiEncode('html_attr',fileMetaData.getRemoteSource())#"  maxlength="255" class="filemeta">
					</div>
					<div class="mura-control-group">
						<label>
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
