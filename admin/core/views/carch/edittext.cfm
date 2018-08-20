<cfsilent>
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
</cfsilent>
<cfinclude template="js.cfm">
<cfoutput>
<div class="mura-header">
	<h1>Edit Text</h1>
</div> <!-- /.mura-header -->

<div class="block block-constrain">
	<div class="block block-bordered">
	  	<div class="block-content">
		  	<div class="mura-control-group">
				<textarea name="source" id="source" class="htmlEditor" data-width="100%"></textarea>
			</div>
			<div class="mura-actions">
				<div class="form-actions">
					<button class="btn mura-primary" id="updateBtn"><i class="mi-check-circle"></i>Update</button>
				</div>
			</div>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

<script>
$(function(){
	$('##updateBtn').click(function(){

		frontEndProxy.post({
			cmd:'setObjectParams',
			reinit:true,
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			params:{
				source:CKEDITOR.instances['source'].getData(),
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
					if(typeof CKEDITOR.instances['source'] != 'undefined'){
						CKEDITOR.instances['source'].setData(parameters["params"].source);
					}
				}

		}

		frontEndProxy.addEventListener(onFrontEndMessage);
		frontEndProxy.post({cmd:'setWidth',width:800});
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
