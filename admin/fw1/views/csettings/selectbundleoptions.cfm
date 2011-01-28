<cfoutput>
<script>
function submitBundle(){
	jQuery("##alertDialogMessage").html("Create and Download Bundle File?");
	jQuery("##alertDialog").dialog({
			resizable: false,
			modal: true,
			buttons: {
				'YES': function() {
					jQuery(this).dialog('close');
					jQuery("##actionButtons").hide();
					jQuery("##actionIndicator").show();
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
	<li><input type="checkbox" name="includeTrash" value="true"/> Items in Trash Bin</li>
	<li><input type="checkbox" name="includeVersionHistory" value="true"/> Content Version Histories</li>
	<li><input type="checkbox" name="includeMetaData" value="true"/> Content Comments and Ratings</li>
	<li><input type="checkbox" name="includeMailingListMembers" value="true" /> Mailing List Members</li>
	<li><input type="checkbox" name="includeUsers" value="true" /> Site Members &amp; Administrative Users</li>
</ul>
</dd>

<dt>Also include selected Plugins:</dt>
<cfif rc.rsplugins.recordcount>
<dd><a onclick="checkAll('pluginSelectFrm');">Select All</a></dd>
</cfif>
<dd>
<ul>
<cfif rc.rsplugins.recordcount>
<cfloop query="rc.rsplugins">
<li><label for=""><input type="checkbox" name="moduleID" value="#rc.rsplugins.moduleID#">#HTMLEditFormat(rc.rsplugins.name)#</label></li>
</cfloop>
</ul>
<cfelse>
<p>This site currently has no plugins assigned to it.</p>
</cfif></dd>
<!--- <cfif application.settingsManager.getSite(rc.siteid).getAdManager()> --->
<dd class="notice"><strong>Note:</strong> The Advertising Module &amp; Email Broadcaster are not included in Mura Bundles.</dd>
<!--- </cfif>  --->
</dl>
<div class="clearfix" id="actionButtons">
	<a href="javascript:;" onclick="return submitBundle();" class="submit"><span>Create and Download Bundle</span></a>
</div>
<div id="actionIndicator" style="display: none;">
	<img src="#application.configBean.getContext()#/admin/images/progress_bar.gif">
</div>
<input type="hidden" name="fuseaction" value="cSettings.createBundle"/>
<input type="hidden" name="siteID" value="#HTMLEditFormat(rc.siteID)#"/>

</form>

</cfoutput>