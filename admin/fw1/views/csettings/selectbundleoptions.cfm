 <!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
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
  <form id="pluginSelectFrm" name="pluginSelectFrm" action="./index.cfm">
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