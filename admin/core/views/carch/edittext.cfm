<cfsilent>
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
</cfsilent>
<cfinclude template="js.cfm">
<cfoutput>
<h1>Edit Text</h1>
<div id="nav-module-specific" class="btn-group">
	<a class="btn" href="javascript:frontEndProxy.post({cmd:'close'});"><i class="icon-circle-arrow-left"></i>  #application.rbFactory.getKeyValue(session.rb,'collections.back')#
	</a>
</div>
<div class="fieldset-wrap">
<div class="fieldset">
	<div class="control-group">
		<div class="controls">
		<textarea name="source" id="source" class="htmlEditor"></textarea>
		</div>	
	</div>
	
</div>
<div class="form-actions">
	<button class="btn" id="updateBtn">Update</button>
</div>
</div>

<script>
$(function(){
	$('##updateBtn').click(function(){

		CKEDITOR.instances['source'].updateElement();

		frontEndProxy.post({
			cmd:'setObjectParams',
			reinit:true,
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			params:{
				source:$('##source').val(),
				render:'client',
				async:false,
				sourcetype:'custom'
				}
			});
	});

	function initConfiguratorProxy(){

		function onFrontEndMessage(messageEvent){
			
			var parameters=messageEvent.data;
			
			if (parameters["cmd"] == "setObjectParams") {
				
				if(parameters["params"]){
					originParams=parameters["params"];
				}

				//console.log(parameters)
				if(parameters["params"].sourcetype == 'custom'){}
					$('##source').val(parameters["params"].source);
				}
				
		}

		frontEndProxy.addEventListener(onFrontEndMessage);
		frontEndProxy.post({cmd:'setWidth',width:'standard'});
		frontEndProxy.post({
			cmd:'requestObjectParams',
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			targetFrame:'modal'
			}
		);


	}

	if($("##ProxyIFrame").length){
		$("##ProxyIFrame").load(initConfiguratorProxy);
	} else {
		initConfiguratorProxy();
	}
	
});
</script>
</cfoutput>