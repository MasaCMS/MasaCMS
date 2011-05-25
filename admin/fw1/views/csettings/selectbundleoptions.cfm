<cfoutput> 
  <script>
function submitBundle(){
	if(jQuery("##saveFileDir").val() != ''){
		var message="Create and Save Bundle to Server?";
	} else {
		var message="Create and Download Bundle File?";
	}
	jQuery("##alertDialogMessage").html(message);
	jQuery("##alertDialog").dialog({
			resizable: false,
			modal: true,
			buttons: {
				'YES': function() {
					jQuery(this).dialog('close');
					//jQuery("##actionButtons").hide();
					//jQuery("##actionIndicator").show();
					jQuery("##pluginSelectFrm").submit();
					},
				'NO': function() {
					jQuery(this).dialog('close');
				}
			}
		});

	return false;	
}

checked=false;
function checkAll (form) {

    if (checked == false) {
        checked = true
    }
    else {
        checked = false
    }
    
    jQuery('input[name="moduleID"]').attr("checked",checked);
   
}
</script>
  <h2>Create Site Bundle</h2>
  <ul id="navTask">
    <li><a href="index.cfm?fuseaction=cSettings.editSite&siteID=#URLEncodedFormat(rc.siteID)#">Back to Site Settings</a></li>
  </ul>
  <p>A Bundle includes a Site's architecture &amp; content, all rendering files (display objects, themes, javascript, etc.) and any of the items you select below. </p>
  <form id="pluginSelectFrm" name="pluginSelectFrm" action="./">
    <dl class="oneColumn ">
      <dt class="separate">Include in Site Bundle:</dt>
      <dd>
        <ul>
          <li>
            <input type="checkbox" name="includeTrash" value="true"/>
            Items in Trash Bin</li>
          <li>
            <input type="checkbox" name="includeVersionHistory" value="true"/>
            Content Version Histories</li>
          <li>
            <input type="checkbox" name="includeMetaData" value="true"/>
            Content Comments and Ratings</li>
          <li>
            <input type="checkbox" name="includeMailingListMembers" value="true" />
            Mailing List Members</li>
          <li>
            <input type="checkbox" name="includeFormData" value="true" />
            Form Response Data</li>
          <cfset siteBean=application.settingsManager.getSite(session.siteID)>
          <cfif siteBean.getPublicUserPoolID() eq siteBean.getSiteID() and siteBean.getPrivateUserPoolID() eq siteBean.getSiteID()>
            <li>
              <input type="checkbox" name="includeUsers" value="true" />
              Site Members &amp; Administrative Users</li>
          </cfif>
        </ul>
      </dd>
      <dt>Also include selected Plugins:</dt>
      <cfif rc.rsplugins.recordcount>
        <dd><a onClick="checkAll('pluginSelectFrm');">Select All</a></dd>
      </cfif>
      <dd>
        <ul>
        <cfif rc.rsplugins.recordcount>
          <cfloop query="rc.rsplugins">
            <li>
              <label for="">
                <input type="checkbox" name="moduleID" value="#rc.rsplugins.moduleID#">
                #HTMLEditFormat(rc.rsplugins.name)#</label>
            </li>
          </cfloop>
          </ul>
          <cfelse>
          <p>This site currently has no plugins assigned to it.</p>
        </cfif>
      </dd>
      <dt class="divide"><a class="tooltip">Server Directory (Optional)<span>You can set the complete server path to the directory where you would like the bundle to be created.  If left blank the bundle file will immediately download from your browser after creation.</span></a></dt>
      <dd>Current Working Directory:#application.configBean.getWebRoot()##application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#temp <input type="button" onclick="jQuery('##saveFileDir').val('#JSStringFormat('#application.configBean.getWebRoot()##application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#temp')#');" value="Select this Directory">
	  <dd>
        <input class="text" type="text" name="saveFileDir" id="saveFileDir">
      </dd>
    </dl>
    
    <div class="clearfix" id="actionButtons">
    
    <!--- <cfif application.settingsManager.getSite(rc.siteid).getAdManager()> --->
      <p class="notice"><strong>Note:</strong> The Advertising Module &amp; Email Broadcaster are not included in Mura Bundles.</p>
      <!--- </cfif>  --->
    
    <a href="javascript:;" onClick="return submitBundle();" class="submit"><span>Create Bundle</span></a> </div>
    <div id="actionIndicator" style="display: none;"> <img class="loadProgress" src="#application.configBean.getContext()#/admin/images/progress_bar.gif"> </div>
    <input type="hidden" name="fuseaction" value="cSettings.createBundle"/>
    <input type="hidden" name="siteID" value="#HTMLEditFormat(rc.siteID)#"/>
  </form>
</cfoutput>