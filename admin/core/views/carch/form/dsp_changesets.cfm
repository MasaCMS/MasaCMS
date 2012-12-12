<cfoutput>
<!---
<cfif not currentChangeset.getIsNew()>
<p class="alert alert-notice">fff#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnotenotify")#: "#currentChangeset.getName()#"</p>
</cfif>
--->
<script>
<cfif not currentChangeset.getIsNew() and not rc.contentBean.getApproved()>
var currentChangesetSelection="#rc.contentBean.getChangesetID()#";
var currentChangesetID="#rc.contentBean.getChangesetID()#";
<cfelse>
var currentChangesetSelection="";
var currentChangesetID="";
</cfif>

var publishitemfromchangeset="#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.publishitemfromchangeset'))#"
function removeChangesetPrompt(changesetID){
	
	if(currentChangesetID!="" && changesetID!=currentChangesetID){
		jQuery("##removeChangesetContainer").show();
	} else {
		jQuery("##removeChangesetContainer").hide();
		document.getElementById("_removePreviousChangeset").checked=false;
	}
	
	currentChangesetSelection=changesetID;
}

function saveToChangeset(changesetid,siteid,keywords){
	
	var url = 'index.cfm';
	var pars = 'muraAction=cArch.availablechangesets&compactDisplay=true&siteid=' + siteid  + '&keywords=' + keywords + '&changesetid=' + changesetid +'&cacheid=' + Math.random();
	var d = jQuery('##changesetContainer');
	d.html('<div class="load-inline"></div>');
	jQuery.get(url + "?" + pars, 
			function(data) {
			jQuery('##changesetContainer').html(data);
			stripe('stripe');
			});
		
		jQuery("##changesetContainer").dialog({
			resizable: false,
			modal: true,
			buttons: {
				'#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.save"))#': function() {
					jQuery(this).dialog('close');
					if (siteManager.configuratorMode == 'backEnd') {
						if(siteManager.ckContent()){
							jQuery("##changesetID").val(currentChangesetSelection);
							jQuery("##removePreviousChangeset").val(document.getElementById("_removePreviousChangeset").checked);
							submitForm(document.contentForm, 'add');
						}
					} else {
						siteManager.saveConfiguratorToChangeset(currentChangesetSelection,document.getElementById("_removePreviousChangeset").checked);
					}
						
						return false;
					}
			}
		});
	
	
	return false;	
}
</script>
<div style="display:none" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.assigntochangeset"))#" id="changesetContainer">

</div>
</cfoutput>