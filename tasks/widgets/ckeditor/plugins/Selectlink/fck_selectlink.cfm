<cfsilent>
<cfset rsPluginScripts=application.pluginManager.getScripts("onLinkSelect",session.siteID)>
<cfscript>
if (NOT IsDefined("attributes"))
    attributes=structNew();
StructAppend(attributes, url, "no");
StructAppend(attributes, form, "no");
</cfscript>
</cfsilent>
<cfif not rsPluginScripts.recordcount>
<cfsilent>
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.siteid" default="#session.siteid#">
<cfset request.rsList=application.contentManager.getPrivateSearch('#attributes.siteid#','#attributes.keywords#')/>
<cfset request.nextn=application.utility.getNextN(request.rsList,30,attributes.startrow) />
<cfset request.contentRenderer = createObject("component","#application.settingsManager.getSite(session.siteid).getAssetMap()#.includes.contentRenderer").init() />
</cfsilent>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<cfoutput>
<html>
	<head>
		<title>Select Link</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">
		<script src="#application.configBean.getContext()#/admin/js/admin.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
		<script src="#application.configBean.getContext()#/admin/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
		<script src="#application.configBean.getContext()#/admin/js/prototype.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
		<link href="#application.configBean.getContext()#/admin/css/admin.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="#application.configBean.getContext()#/tasks/widgets/ckeditor/skins/mura/dialog.css">
</cfoutput>

	<style>
	.cke_dialog_ui_iframe {
		background-image: none;
		overflow: hidden !important;
	}
	
	body#mura-select-link {
		background: none;
		overflow: hidden;
	}
	
	#mura-select-link form {
		width: 100%;
	}
	
	#mura-select-link form.mura-link-search-result {
		margin-bottom: 0;
		padding-bottom: 0;
	}
	
	#mura-select-link #mura-table-grid-container {
		overflow: auto !important;
		height: 287px;
	}
	
	#mura-select-link .mura-table-grid {
	    margin: 0;
	}
	
	#mura-select-link .cke_skin_mura .cke_resizer {
	    margin-right: 6px;
	    margin-top: 30px;
	}
	
	#cke_84_uiElement {
		height: 375px !important;
		overflow: visible !important;
		zoom: 1;
	}
	
	#cke_dialog_footer_80.cke_dialog_footer {
	    padding: 0 !important;
	}
		
	</style>
</head>

<body id="mura-select-link">
<cfoutput>
<h3>Keyword Search</h3>
<form id="siteSearch" name="siteSearch" method="post"><input name="keywords" value="#HTMLEditFormat(attributes.keywords)#" type="text" class="text" maxlength="50"/>
	<input type="hidden" name="fuseaction" value="cArch.search">
	<input type="hidden" name="siteid" value="#session.siteid#">
	<input type="hidden" name="moduleid" value="00000000000000000000000000000000000">
	<input  class="Button" type="submit" onClick="return submitForm(document.forms.siteSearch);" value="Search">
</form>
</cfoutput>
<form class="mura-link-search-result" name="frmLinks" method="post" onSubmit="return false;">
<cfif attributes.keywords neq ''>
<div id="mura-table-grid-container">
 <table class="mura-table-grid stripe">
    <tr>
	  <th class="administration">&nbsp;</th> 
      <th class="varWidth">Title</th>
    </tr>
    <cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" maxrows="#request.nextn.recordsperPage#" startrow="#attributes.startrow#">
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
        <tr>
        <td class="administration" id="test"><input type="radio" name="theLinks" id="theLinks#request.rslist.currentrow#" value="#htmlEditFormat(request.contentRenderer.createHREF(request.rslist.type,request.rslist.filename,session.siteid,request.rslist.contentid,request.rslist.target,request.rslist.targetParams,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()))#^#htmleditformat(request.rslist.menutitle)#"<cfif request.rslist.currentrow eq 1> checked</cfif>></td>  
          <td class="varWidth"><label for="theLinks#request.rslist.currentrow#">#application.contentRenderer.dspZoomNoLinks(crumbdata,request.rsList.fileExt)#</label></td>
		  
		</tr>
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="2" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
	
    <cfif request.nextn.numberofpages gt 1><tr> 
      <td colspan="7" class="results">More Results: <cfloop from="1"  to="#request.nextn.numberofpages#" index="i"><cfoutput><cfif request.nextn.currentpagenumber eq i> #i# <cfelse> <a href="?keywords=#attributes.keywords#&startrow=#evaluate('(#i#*#request.nextn.recordsperpage#)-#request.nextn.recordsperpage#+1')#">#i#</a> </cfif></cfoutput></cfloop></td></tr></cfif>
  </table>
</td></tr></table></div></cfif></form>

<script type="text/javascript" language="javascript">
stripe('stripe');
<cfif not ( len(attributes.keywords) and request.rslist.recordcount )>
document.forms.siteSearch.keywords.focus();
</cfif>
</script>
<div id="alertDialog" title="Alert" style="display:none">
	<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span><span id="alertDialogMessage"></span></p>
</div>
	</body>
</html>
<cfelse>
<cfoutput>
#application.pluginManager.renderScripts("onLinkSelect",session.siteid, createObject("component","mura.event").init(attributes) ,rsPluginScripts)#
</cfoutput>
</cfif>

