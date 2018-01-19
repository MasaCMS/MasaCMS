<cfsilent>
	<cfparam name="objectparams.fileid" default="">
	<cfparam name="objectparams.size" default="medium">
	<cfparam name="objectparams.height" default="AUTO">
	<cfparam name="objectparams.width" default="AUTO">
</cfsilent>
<cf_objectconfigurator>
	<cfoutput>
	<div class="mura-layout-row">
			<cfif not len(objectparams.fileid)>
				<div class="mura-control-group">
					<button class="btn" id="selectMedia"><i class="mi-image"></i> Select Image</button>
				</div>
			<cfelse>
				<div class="mura-control-group">
					<img id="selectMedia" src="#$.getURLForImage(fileid=objectparams.fileid,size='small')#"/>
				</div>
				<div class="mura-control-group">
				  	<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
					<select name="size" data-displayobjectparam="size" class="objectParam">

						<cfloop list="Small,Medium,Large" index="i">
							<option value="#lcase(i)#"<cfif i eq objectparams.size> selected</cfif>>#I#</option>
						</cfloop>

						<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>

						<cfloop condition="imageSizes.hasNext()">
							<cfset image=imageSizes.next()>
							<option value="#lcase(image.getName())#"<cfif image.getName() eq objectparams.size> selected</cfif>>#esapiEncode('html',image.getName())#</option>
						</cfloop>

							<option value="custom"<cfif "custom" eq objectparams.size> selected</cfif>>Custom</option>

					</select>
				</div>

				<div id="imageoptionscontainer" class="mura-control-group" style="display:none">
					<div>
						<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
				      	<input class="objectParam" name="height" data-displayobjectparam="height" type="text" value="#objectparams.height#" />
				    </div>
					<div>
						<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</label>
						<input class="objectParam" name="width" data-displayobjectparam="width" type="text" value="#objectparams.width#" />
					</div>
				</div>
			</cfif>
		</div>
	</div>
	<input class="objectParam" data-displayobjectparam="fileid" name="fileid" type="hidden" value="#esapiEncode('html_attr',objectparams.fileid)#" />
	<script>
		$(function(){

			function onSizeChange(){

				if($('select[name="size"]').val() && $('select[name="size"]').val().toLowerCase()=='custom'){
					$('##imageoptionscontainer').show();
				} else {
					$('##imageoptionscontainer').hide();
				}
			}

			$('select[name="size"]').change(onSizeChange);

			$('##selectMedia').click(function(){
				frontEndProxy.post({
					cmd:'openModal',
					src:'?muraAction=cArch.selectmedia&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&contentid=#esapiEncode("url",rc.contentid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true&fileid=#esapiEncode("url",objectparams.fileid)#'
					}
				);

			});

			onSizeChange();

		})
	</script>
	</cfoutput>
	<!--- Include global config object options --->
	<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">
</cf_objectconfigurator>
