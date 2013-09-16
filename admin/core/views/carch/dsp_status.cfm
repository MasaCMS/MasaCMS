
<cfoutput>
<cfif requiresApproval and listFindNoCase('Pending,Rejected',rc.contentBean.getApprovalStatus())  >
	<p class="alert alert-error">
		<cfif rc.contentBean.getApprovalStatus() eq 'Rejected'>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.rejectedmessage")#: 
		<cfelseif rc.contentBean.getApprovalStatus() eq 'Cancelled'>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.canceledmessage")#: 
		<cfelse>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.pendingmessage")#: 
		</cfif>
		<strong><a href="##" onclick="return viewStatusInfo('#JSStringFormat(rc.contentBean.getContentHistID())#','#JSStringFormat(rc.contentBean.getSiteID())#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewdetails")#</a></strong>
	</p>
</cfif>
<script>
function viewStatusInfo(contenthistid,siteid){
	
	var url = 'index.cfm';
	var pars = 'muraAction=cArch.statusmodal&compactDisplay=true&siteid=' + siteid  + '&contenthistid=' + contenthistid +'&cacheid=' + Math.random();
	var d = jQuery('##approvalModalContainer');
	d.html('<div class="load-inline"></div>');
	$('##approvalModalContainer .load-inline').spin(spinnerArgs2);
	$.get(url + "?" + pars, 
			function(data) {
			$('##approvalModalContainer .load-inline').spin(false);
			jQuery('##approvalModalContainer').html(data);
			stripe('stripe');
			});
		
		$("##approvalModalContainer").dialog({
			resizable: false,
			modal: true,
			width: 600,
			position:["top",20]
		});
	
	
	return false;	
}

function applyApprovalAction(requestid,action,comment,siteid){
	
	if(action == 'Reject' && comment == ''){
		alertDialog('#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"approvalchains.rejectioncommentrequired"))#');
	} else {
		var pars={
					muraAction:'carch.approvalaction',
					siteid: siteid,
					requestid: requestid,
					comment: comment,
					action:action
				};

		actionModal(
			function(){
				$.post('index.cfm',
					pars,
					function(data) {
						if(typeof(data) == 'string'){
							$('html').html(data);
						} else {
							var href = window.location.href.replace('#rc.contentBean.getContentHistID()#',data.contenthistid);
							//alert(href)
							window.location = href;
						}
					}
				);
			}
		);
	}
}
</script>
<div style="display:none" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"layout.status"))#" id="approvalModalContainer">

</div>
</cfoutput>