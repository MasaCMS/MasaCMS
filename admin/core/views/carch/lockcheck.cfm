
<cfset stats=$.getBean('content').loadBy(contenthistid=$.event('contenthistid')).getStats()>
<cfif stats.getLockID() eq session.mura.userid>
	<cflocation addtoken="false" url="./?#replace(cgi.query_string,'carch.lockcheck',$.event('destAction'))#">
</cfif>
<cfinclude template="js.cfm">
<cfoutput>
<div id="configuratorContainer">
	<h1 id="configuratorHeader">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.title')#</h1>
	<div id="configurator">
	<div class="load-inline"></div>
	</div>
</div>
<script type="text/javascript">
$(function(){

	if (top.location != self.location) {
		if(jQuery("##ProxyIFrame").length){
			jQuery("##ProxyIFrame").load(
				function(){
					frontEndProxy.post({cmd:'setWidth',width:'configurator'});
				}
			);	
		} else {
			frontEndProxy.post({cmd:'setWidth',width:'configurator'});
		}
	}

	$('##configuratorContainer .load-inline').spin(spinnerArgs2);

	var href = './?#esapiEncode('javascript',cgi.query_string)#';
	var locknode=false;

	$.ajax({
		  url: "./index.cfm?muraAction=carch.draftpromptdata&contentid=#esapiEncode('javascript',$.event('contentid'))#&siteid=#esapiEncode('javascript',$.event('siteid'))#&targetversion=true&contenthistid=#esapiEncode('javascript',$.event('contenthistid'))#&homeid=#esapiEncode('javascript',$.event('homeid'))#",
		  context: this,
		  success: function(resp){

			  if (resp.showdialog !== undefined && resp.showdialog === "true"){
				
				$('##configurator').html(resp.message);

				$(".draft-prompt-option").click(function(e){
					e.preventDefault();
					href = href.replace('carch.lockcheck','#esapiEncode('javascript',$.event("destAction"))#&locknode=' + locknode );
					actionModal(href);
				});

				$("##locknodetoggle").on("change",function(){
					locknode=$(this).is(":checked");
				});

			} else {
				href = href.replace('carch.lockcheck','#esapiEncode('javascript',$.event("destAction"))#&locknode=' + locknode );
				actionModal(href);
			}
		}
	});
});
</script>
</cfoutput>