<cfset rsPluginScripts=application.pluginManager.getScripts("onLinkSelect",session.siteID)>
<cfif not rsPluginScripts.recordcount>
<cfsilent>
<cfscript>
if (NOT IsDefined("attributes"))
    attributes=structNew();
StructAppend(attributes, url, "no");
StructAppend(attributes, form, "no");
</cfscript>

<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.siteid" default="#session.siteid#">
<cfset rsPluginScripts=application.pluginManager.getScripts("onLinkSelect",attributes.siteID)>

<cfset request.rsList=application.contentManager.getPrivateSearch('#attributes.siteid#','#attributes.keywords#')/>
<cfset request.nextn=application.utility.getNextN(request.rsList,30,attributes.startrow) />
<cfset request.contentRenderer = createObject("component","#application.configBean.getWebRootMap()#.#session.siteid#.includes.contentRenderer").init() />
</cfsilent>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<cfoutput>
<html>
	<head>
		<title>Select Link</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">
		<link href="#application.configBean.getContext()#/admin/css/admin.css" rel="stylesheet" type="text/css" />
		<script src="#application.configBean.getContext()#/admin/js/admin.js" type="text/javascript" language="Javascript"></script>
		<script src="#application.configBean.getContext()#/admin/js/prototype.js" type="text/javascript" language="Javascript"></script>
</cfoutput>
<script language="javascript">
var oEditor = window.parent.InnerDialogLoaded() ;
var FCKLang = oEditor.FCKLang ;
var FCKSelectlink = oEditor.FCKSelectlink ;
var FCK	= oEditor.FCK ;

window.parent.SetOkButton( true ) ;
/*window.onload = function ()
{
	// First of all, translate the dialog box texts
	oEditor.FCKLanguageManager.TranslatePage( document ) ;
		
}*/

Ok =function() {
	if(typeof(document.forms.frmLinks.theLinks) != 'undefined'){
	
		var theChoice = -1;
		
		if(document.frmLinks.theLinks.length == undefined){
			theChoice = 0; 
			theLink=document.forms.frmLinks.theLinks.value.split("^")
		}
		else {
			for (counter = 0; counter < document.frmLinks.theLinks.length; counter++)
				{
					if (document.frmLinks.theLinks[counter].checked) {
					theChoice = counter; 
					var theLink=document.forms.frmLinks.theLinks[theChoice].value.split("^");
					}
				}
		}
	
		if(theChoice != -1){
	
	
		 if(document.all)  
   		{
				mySelection = FCK.EditorDocument.selection;
				
				if(mySelection.type=='Text'){
					oEditor.FCK.CreateLink(theLink[0]) ;
				}
				else
				{ 
				FCK.Focus()
				var myRange=mySelection.createRange();
				myRange.text= theLink[1];
				
				myRange.moveStart('character', -theLink[1].length);
				myRange.select();
				oEditor.FCK.CreateLink(theLink[0]);
				
   				}  
		}
   		else  
   		{  
				//mySelection = FCK.EditorDocument.getSelection();
				mySelection = FCK.EditorWindow.getSelection();
			
				if(mySelection.length > 0 ){
					oEditor.FCK.CreateLink(theLink[0]) ;
				}
				else
				{ 
				oEditor.FCK.InsertHtml('<a href="' + theLink[0] + '">' + theLink[1] + '</a>') ;	
				} 
			
		}
		window.parent.Cancel() ;
		}
	
	}
	else
	{
		window.parent.Cancel() ;
	}
}
</script>
	</head>

	<body scroll="no" style="OVERFLOW: hidden">
<cfoutput>
<h3>Keyword Search</h3>
<form id="siteSearch" name="siteSearch" method="post" onSubmit="return validateForm(this);"><input name="keywords" value="#attributes.keywords#" type="text" class="text" maxlength="50" required="true" message="The 'Keyword' field is required."/><!---<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>Search</span></a>--->
	<input type="hidden" name="fuseaction" value="cArch.search">
	<input type="hidden" name="siteid" value="#session.siteid#">
	<input type="hidden" name="moduleid" value="00000000000000000000000000000000000"><input  class="Button" type="submit" onClick="return submitForm(document.forms.siteSearch);" value="Search">
</form>
</cfoutput>
<form name="frmLinks" method="post" onSubmit="return false;">
<cfif attributes.keywords neq ''>
<div style="overflow:scroll;width:375px;height:200px; ">
 <table id="metadata" class="stripe">
    <tr> 
      <th class="varWidth">Title</th>
	  <th class="administration">&nbsp;</th>
    </tr>
    <cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" maxrows="#request.nextn.recordsperPage#" startrow="#attributes.startrow#">
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
        <tr>  
          <td class="varWidth">#application.contentRenderer.dspZoomNoLinks(crumbdata,request.rsList.fileExt)#</td>
		  <td class="administration" id="test"><input type="radio" name="theLinks" value="#htmlEditFormat(request.contentRenderer.createHREF(request.rslist.type,request.rslist.filename,session.siteid,request.rslist.contentid,request.rslist.target,request.rslist.targetParams,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()))#^#htmleditformat(request.rslist.menutitle)#"<cfif request.rslist.currentrow eq 1> checked</cfif>></td>
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
document.forms.siteSearch.keywords.focus();
</script>

	</body>
</html>
<cfelse>
<cfoutput>
<cfset request.pluginConfig=application.pluginManager.getConfig(rsPluginScripts.pluginID)>
<cfset request.pluginConfig.setSetting("pluginMode","admin")>
<cfinclude template="/#application.configBean.getWebRootMap()#/plugins/#rsPluginScripts.pluginID#/#rsPluginScripts.scriptfile#">
</cfoutput>
</cfif>