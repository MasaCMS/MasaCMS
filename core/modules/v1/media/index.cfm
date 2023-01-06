<cfscript>
		param name="objectparams.mediasource" default="";
		param name="objectparams.videoid" default="";//
		param name="objectparams.autoplay" default="false";
</cfscript>

<cfoutput>
	<cfif !len(objectparams.mediasource) or !len(objectparams.videoid)>
		<div class="alert alert-warning">Configuration required; please choose your media source and id.</div>
	<cfelse>
		<cfset autoplay=''/>
		<cfset renderVideo = '' />
		<cfswitch expression="#objectparams.mediasource#">
			<cfcase value="youtube">
				<cfif objectParams.autoplay>
					<cfset autoplay='&autoplay=1&mute=1'/>
				</cfif>
				<cfset con = '<iframe src="//www.youtube.com/embed/#esapiEncode('html',trim(objectparams.videoid))#?rel=0#autoplay#&vq=hd1080&controls=0" frameborder="0" allowfullscreen></iframe>'>
				<cfsavecontent variable="renderVideo">
					<div class="media-container" id="player-#esapiEncode('html',objectparams.instanceid)#">
						#con#
					</div>
				</cfsavecontent>
			</cfcase>
			<cfcase value="dailymotion">
				<cfif objectParams.autoplay>
					<cfset autoplay='1'/>
				</cfif>
				<cfset con = '<iframe style="width:100%;height:100%;position:absolute;left:0px;top:0px;overflow:hidden" frameborder="0" type="text/html" src="https://www.dailymotion.com/embed/video/#esapiEncode('html',trim(objectparams.videoid))#?autoplay=#autoplay#" width="100%" height="100%" allowfullscreen allow="autoplay"></iframe>'>
				<cfsavecontent variable="renderVideo">
					<div class="media-container" id="player-#esapiEncode('html',objectparams.instanceid)#">
						#con#
					</div>
				</cfsavecontent>
			</cfcase>
			<cfcase value="vimeo">
				<cfif objectParams.autoplay>
					<cfset autoplay='autoplay=1&muted=1'/>
				</cfif>
				<cfset con = '<iframe src="https://player.vimeo.com/video/#esapiEncode('url',trim(objectparams.videoid))#?#autoplay#" width="960" height="540" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>'>
				<cfsavecontent variable="renderVideo">
					<div class="media-container" id="player-#esapiEncode('html',objectparams.instanceid)#">
						#con#
					</div>
				</cfsavecontent>
			</cfcase>
			<cfdefaultcase>
				<cfsavecontent variable="renderVideo">
					Configuration required ... please choose your media source and id.
				</cfsavecontent>
			</cfdefaultcase>
		</cfswitch>
		#renderVideo#
		<script type="text/javascript">
			Mura(function(m) {
				m.loader()
					.loadcss(Mura.rootpath + '/core/modules/v1/media/css/media.css');
			});
		</script>
	</cfif>
</cfoutput>
