<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<script src="js/architecture.js" type="text/javascript" language="Javascript" ></script>
<cfif myfusebox.originalfuseaction eq 'edit'>
<script type="text/javascript">
  summaryLoaded=false;
</script>

<cfset rsPluginScripts=application.pluginManager.getScripts("onHTMLEditHeader",attributes.siteID)>
<cfif rsPluginScripts.recordcount>
<cfset request.pluginConfig=application.pluginManager.getConfig(rsPluginScripts.pluginID)>
	<cfinclude template="/#application.configBean.getWebRootMap()#/plugins/#rsPluginScripts.pluginID#/#rsPluginScripts.scriptfile#">
<cfelse>
<cfoutput>
<script type="text/javascript" src="#application.configBean.getContext()#/fckeditor/fckeditor.js"></script>
<script type="text/javascript">
 
 summaryLoaded=false;
 
 editSummary = function(){
 		if(!summaryLoaded){
   		FCKeditor_OnComplete=null;
     	var oFCKeditor = new FCKeditor( 'summary' ) ;
	  	//oFCKeditor.instanceName	= "summary";
		oFCKeditor.value			= document.contentForm.summary.value;
		oFCKeditor.BasePath		= "#application.configBean.getContext()#/fckeditor/";
		oFCKeditor.Config.EditorAreaCSS	= '#application.configBean.getContext()#/#attributes.siteid#/css/editor.css';
		oFCKeditor.Config.StylesXmlPath = '#application.configBean.getContext()#/#attributes.siteid#/css/fckstyles.xml';
		oFCKeditor.width			= "100%";
		oFCKeditor.ToolbarSet			= "Summary";
		oFCKeditor.Config.DefaultLanguage='#lcase(session.rb)#';
		oFCKeditor.Config.AutoDetectLanguage=false;
     	oFCKeditor.ReplaceTextarea() ;
    	summaryLoaded=true;
		}
	}
  </script>
 </cfoutput>
</cfif>
</cfif>


