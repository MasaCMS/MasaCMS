<!--- At t his point this is experimental --->
<cfsilent>
<cfparam name="rc.fileid" default="">
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfquery name="rsImages">
	select tfiles.fileid,tfiles.siteid from tfiles
	left join tcontent on (tfiles.contentid=tcontent.contentid)
	where tfiles.fileext in ('png','jpg','jpeg','svg')
	and tfiles.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.siteConfig().getFilePoolID()#">
	and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.siteConfig().getSiteID()#">
	and tcontent.active=1

	and (
		tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.contentid#">

		or tcontent.parentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.contentid#">

		or tcontent.parentid in (select tcontent.contentid from tcontent
								where tcontent.parentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.contentid#">
								and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.siteConfig().getSiteID()#">
								and tcontent.active=1
								)
		)
</cfquery>
</cfsilent>
<cfinclude template="js.cfm">
<cfoutput>
<div class="mura-header">
	<h1>Select Image</h1>

	<div class="mura-item-metadata">
		<div class="label-group">

	<!-- optional - the view might use dsp_secondary_menu.cfm instead -->
	<div id="nav-module-specific" class="btn-toolbar">
		<a class="btn" href="javascript:frontEndProxy.post({cmd:'close'});"><i class="icon-circle-arrow-left"></i>  #application.rbFactory.getKeyValue(session.rb,'collections.back')#
		</a>
	</div>
	<!-- /optional nav-module-specific -->

		</div><!-- /.label-group -->
	</div><!-- /.mura-item-metadata -->
</div> <!-- /.mura-header -->

<div class="block block-constrain">
	<div class="block block-bordered">
	  	<div class="block-content">
			<div class="mura-control-group">
				<div class="mura-control">
					<cfif rsImages.recordcount>
						<cfloop query="rsImages">
							<div class="image-option" style="float:left" data-fileid="#rsImages.fileid#">
								<img src="#$.getURLForImage(fileid=rsImages.fileid,size='small')#"/>
							</div>
						</cfloop>
					<cfelse>
						<p class="alert">There are currently no related images available.</p>
					</cfif>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
$(function(){
	$('.image-option').click(function(){
		//alert($('input[name="fileid"]').val())
		//return;
		frontEndProxy.post({
			cmd:'setObjectParams',
			reinit:true,
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			params:{
				fileid:$(this).data('fileid')
				}
			});
	});

	if($("##ProxyIFrame").length){
		$("##ProxyIFrame").load(
			function(){
				frontEndProxy.post({cmd:'setWidth',width:600});
			}
		);
	} else {
		frontEndProxy.post({cmd:'setWidth',width:600});
	}


});
</script>
</cfoutput>
