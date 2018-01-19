<cfoutput>
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

var assigningChangeset=false;

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
			close: function( event, ui ) { siteManager.assigningChangeset=false;},
			buttons: {
				#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.save"))#: 
					{click: function() {
							jQuery(this).dialog('close');
						if(siteManager.configuratorMode == 'backEnd') {
							siteManager.assigningChangeset=true;
							if(siteManager.ckContent()){
								//submitForm(document.contentForm, 'add');
							}
						} else {
							siteManager.saveConfiguratorToChangeset(currentChangesetSelection,document.getElementById("_removePreviousChangeset").checked);
						}
							
							return false;						
						}
					, text: '#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.save"))#'
					, class: 'mura-primary'
					} // /Save
			}
		});
	
	
	return false;	
}
</script>
<div style="display:none" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.assigntochangeset"))#" id="changesetContainer">

</div>
</cfoutput>