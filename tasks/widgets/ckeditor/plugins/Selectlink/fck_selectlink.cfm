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
<cfset request.contentRenderer = application.settingsManager.getSite(attributes.siteID).getContentRenderer() />
</cfsilent>
<!doctype html>
<cfoutput>
<html class="mura">
	<head>
		<title>Select Link</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">
		<script src="#application.configBean.getContext()#/admin/assets/js/admin.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
		<link href="#application.configBean.getContext()#/admin/assets/css/admin.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="#application.configBean.getContext()#/tasks/widgets/ckeditor/skins/mura/dialog.css">
	</head>
</cfoutput>
<body id="mura-select-link">
<cfoutput>
<h2>Keyword Search</h2>
<form id="mura-link-search" name="siteSearch" method="post">
 <input id="keywords" name="keywords" value="#HTMLEditFormat(attributes.keywords)#" type="text" class="span4" maxlength="50"/>
	<input type="hidden" name="fuseaction" value="cArch.search">
	<input type="hidden" name="siteid" value="#session.siteid#">
	<input type="hidden" name="moduleid" value="00000000000000000000000000000000000">
	<input class="btn" type="submit" onClick="return submitForm(document.forms.siteSearch);" value="Search">
</form>

</cfoutput>
<form class="mura-link-search-result" name="frmLinks" method="post" onSubmit="return false;">
<cfif attributes.keywords neq ''>
<div id="mura-table-grid-container">
 <table class="table table-condensed table-bordered table-striped mura-table-grid">
 <thead>
    <tr>
	  <!--- <th class="actions">&nbsp;</th>  --->
      <th class="varWidth">Title</th>
    </tr>
 </thead>
 <tbody>
    <cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" maxrows="#request.nextn.recordsperPage#" startrow="#attributes.startrow#">
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
        <tr><td class="varWidth">
          	<input type="radio" name="theLinks" id="theLinks#request.rslist.currentrow#" value="#htmlEditFormat(request.contentRenderer.createHREF(request.rslist.type,request.rslist.filename,session.siteid,request.rslist.contentid,request.rslist.target,request.rslist.targetParams,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()))#^#htmleditformat(request.rslist.menutitle)#"<cfif request.rslist.currentrow eq 1> checked</cfif>> #application.contentRenderer.dspZoomNoLinks(crumbdata,request.rsList.fileExt)#
          </td>
		  
		</tr>
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="2" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
</table>

<cfif request.nextn.numberofpages gt 1>
	<div  class="pagination">
      <ul>
      <cfloop from="1"  to="#request.nextn.numberofpages#" index="i">
      	<cfoutput>
      	<cfif request.nextn.currentpagenumber eq i><li class="active"><a href="##">#i#</a></li>
      	<cfelse>
      		<li><a href="?keywords=#attributes.keywords#&startrow=#evaluate('(#i#*#request.nextn.recordsperpage#)-#request.nextn.recordsperpage#+1')#">#i#</a></li>
      	</cfif>
      </cfoutput>
      </cfloop>
      </ul>
	</div>
</cfif>

</div></cfif></form>


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

