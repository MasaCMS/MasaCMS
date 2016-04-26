<cfsilent>
	<cfparam name="objectparams.fileid" default="">
	<cfparam name="objectparams.size" default="medium">
	<cfparam name="objectparams.height" default="AUTO">
	<cfparam name="objectparams.width" default="AUTO">
</cfsilent>
<cf_objectconfigurator>
	<cfoutput>
	<div class="fieldset-wrap">
		<div class="fieldset">
			<cfif not len(objectparams.fileid)>
				<div class="control-group">
					<button class="btn" id="selectMedia">Select Image</button>
				</div>
			<cfelse>
				<div class="control-group">
					<img id="selectMedia" src="#$.getURLForImage(fileid=objectparams.fileid,size='small')#"/>
				</div>
				<div class="control-group">	
				  	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
					<div class="controls">
						<select name="size" data-displayobjectparam="size" class="objectParam span12">
							
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
				</div>
				
				<div id="imageoptionscontainer" class="control-group" style="display:none">
					<div class="span6">	
						<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
						<div class="controls">
				      		<input class="objectParam span12" name="height" data-displayobjectparam="height" type="text" value="#objectparams.height#" />
				      	</div>
				    </div>
					<div class="span6">						
						<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</label>
						<div class="controls">
							<input class="objectParam span12" name="width" data-displayobjectparam="width" type="text" value="#objectparams.width#" />
						</div>
					</div>		
				</div>
			</cfif>
		</div>
	</div>
	<input class="objectParam" data-displayobjectparam="fileid" name="fileid" type="hidden" value="#esapiEncode('html_attr',objectparams.fileid)#" />
	<script>
		$(function(){

			function onSizeChange(){

				if($('select[name="size"]').val().toLowerCase()=='custom'){
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