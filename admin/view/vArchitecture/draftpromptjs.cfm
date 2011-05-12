<cfoutput>
<script type="text/javascript">
jQuery(function($){
	
	$('a.draftprompt').click(function(e){
		e.preventDefault(); // stop the link's normal clicking behavior
		var a = $(this);
			$.ajax({
				  url: "./index.cfm?fuseaction=carch.draftpromptdata&contentid=" + a.attr('data-contentid') + "&siteid=" + a.attr('data-siteid'),
				  context: this,
				  success: function(resp){
				
				   if (resp.showdialog !== undefined && resp.showdialog === "true"){
						$('<div><p>#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.dialog'))#</p></div>').dialog({
							title:"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.title'))#",
							modal:true,
							width:"400px",
							buttons: {
								"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.cancel'))#":function(){
									$(this).dialog('close');
								},
								"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.latest'))#": function(){
									var href = a.attr('href').replace(a.attr('data-contenthistid'),resp.historyid);
									window.location = href;
								},
								"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.published'))#" : function(){
									window.location = a.attr('href');
								}
							}
						});
					} else {
						window.location = a.attr('href');
					}
			}
		});
		
	});
	
});
</script>
</cfoutput>