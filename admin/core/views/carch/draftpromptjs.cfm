<cfoutput>
<script type="text/javascript">
$(function(){
	initDraftPrompt();	
});

function initDraftPrompt(){
	$('a.draftprompt').click(function(e){
		e.preventDefault(); // stop the link's normal clicking behavior
		var node = jQuery(this).parents(".mura-node-data:first");		
		var a = jQuery(this);
		
		$.ajax({
			  url: "./index.cfm?muraAction=carch.draftpromptdata&contentid=" + node.attr('data-contentid') + "&siteid=" + node.attr('data-siteid'),
			  context: this,
			  success: function(resp){
				  
				  if (resp.showdialog !== undefined && resp.showdialog === "true"){
					var dialog=jQuery(resp.message).dialog({
						title:"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.title'))#",
						modal:true,
						width:"600px"
					});
					
					$(".draft-prompt-option").click(function(e){
						e.preventDefault();
						var href = a.attr('href').replace(node.attr('data-contenthistid'),$(this).attr('data-contenthistid'));
						actionModal(href);
					});

					$(".draft-prompt-approval").click(function(e){
						e.preventDefault();
						preview($(this).attr('href'));
						jQuery(dialog).dialog('close');
						return false;
					});
				} else {
					actionModal(a.attr('href'));
				}
			}
		});
		
	});
}
</script>
</cfoutput>