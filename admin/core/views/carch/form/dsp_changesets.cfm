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

var publishitemfromchangeset="#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.publishitemfromchangeset'))#"
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
	$('##changesetContainer .load-inline').spin(spinnerArgs2);
	jQuery.get(url + "?" + pars, 
			function(data) {
			$('##changesetContainer .load-inline').spin(false);
			jQuery('##changesetContainer').html(data);
			stripe('stripe');
			});
		
		jQuery("##changesetContainer").dialog({
			resizable: false,
			modal: true,
			buttons: {
				'#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.save"))#': function() {
					jQuery(this).dialog('close');
					if (siteManager.configuratorMode == 'backEnd') {
						if(siteManager.ckContent()){
							jQuery("##changesetID").val(currentChangesetSelection);
							jQuery("##removePreviousChangeset").val(document.getElementById("_removePreviousChangeset").checked);
							if(currentChangesetSelection=='other'){
								jQuery("##changesetname").val(jQuery("##_changesetname").val());
							} else {
								jQuery("##changesetname").val('');
							}
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
<div style="display:none" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.assigntochangeset"))#" id="changesetContainer">

</div>
</cfoutput>