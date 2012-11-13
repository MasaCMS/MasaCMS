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
<cfset event=request.event>
<cfsavecontent variable="rc.ajax">
<cfoutput>
<script src="assets/js/architecture.min.js?coreversion=#application.coreversion#" type="text/javascript" ></script>
</cfoutput>
<cfif listLast(rc.muraAction,".") eq 'edit'>
<script type="text/javascript">
  summaryLoaded=false;
</script>

<cfset rsPluginScripts=application.pluginManager.getScripts("onHTMLEditHeader",rc.siteID)>
<cfif rsPluginScripts.recordcount>
	<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
	<cfoutput>#application.pluginManager.renderScripts("onHTMLEditHeader",rc.siteid,pluginEvent,rsPluginScripts)#</cfoutput>
<cfelse>
<cfoutput>
<script type="text/javascript">
 
 summaryLoaded=true;

 editSummary = function(){
 		<cfif application.configBean.getValue("htmlEditorType") neq "none">
 		if(!summaryLoaded){
 		<cfif application.configBean.getValue("htmlEditorType") eq "fckeditor">
	   		FCKeditor_OnComplete=htmlEditorOnComplete;
	     	var oFCKeditor = new FCKeditor( 'summary' ) ;
		  	//oFCKeditor.instanceName	= "summary";
			oFCKeditor.value			= document.contentForm.summary.value;
			oFCKeditor.BasePath		= "#application.configBean.getContext()#/wysiwyg/";
			oFCKeditor.Config.EditorAreaCSS	= '#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/css/editor.css';
			oFCKeditor.Config.StylesXmlPath = '#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/css/fckstyles.xml';
			<cfif fileExists("#expandPath(application.settingsManager.getSite(rc.siteid).getThemeIncludePath())#/js/fckconfig.js.cfm")>
			oFCKeditor.Config.CustomConfigurationsPath='#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/js/fckconfig.js.cfm?EditorType=Summary,';
			</cfif>		
			oFCKeditor.width			= "98%";
			oFCKeditor.ToolbarSet			= "Summary";
			oFCKeditor.Config.DefaultLanguage='#lcase(session.rb)#';
			oFCKeditor.Config.AutoDetectLanguage=false;
	     	oFCKeditor.ReplaceTextarea();
	     <cfelse>
		     if(jQuery('##summary').html()==''){
		     	jQuery('##summary').html('<p></p>');
		     }
	     	jQuery('##summary').ckeditor(
	     		{ toolbar:'Summary',
	     		  customConfig : 'config.js.cfm'},
	     		htmlEditorOnComplete
	     	);
    		summaryLoaded=true;
	     </cfif>
	     	
		}
		</cfif>
	}

  </script>
 </cfoutput>
</cfif>
</cfif>
</cfsavecontent>


