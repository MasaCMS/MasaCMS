<cf_objectconfigurator>
	<cfscript>
		param name="objectparams.mediasource" default="";
		param name="objectparams.videoid" default="";//
		param name="objectparams.autoplay" default="false";
	</cfscript>
	
	<cfoutput>
	<div class="container">
		<div class="mura-control-group">
			<label>Media Platform</label>
			<select class="objectparam" name="mediasource">
				<option value="">Media Source</option>
				<cfloop list="Youtube,Vimeo,Dailymotion" item="i">
				<option <cfif objectparams.mediasource eq i>selected </cfif>value="#i#">#i#</option>
				</cfloop>
			</select>
		</div>
	
		<div class="mura-control-group">
			<label>Video ID</label>
			<input type="text" name="videoid" class="objectparam" value="#esapiEncode('html_attr',objectparams.videoid)#"/>
		</div>

		<!--- Autoplay --->
		<div class="mura-control-group">
			<label>Auto Play?</label>
			<div class="radio-group">
				<label class="radio"><input type="radio" class="objectparam" name="autoplay" value="false"<cfif !objectparams.autoplay> checked</cfif>>No</label>
				<label class="radio"><input type="radio" class="objectparam" name="autoplay" value="true"<cfif objectparams.autoplay> checked</cfif>/>Yes</label>
			</div>
		</div>
   </div>
	</cfoutput>
</cf_objectconfigurator>