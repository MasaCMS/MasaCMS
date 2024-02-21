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
    <script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
		<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/oneui.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript"></script>
		<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/admin.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="#application.configBean.getContext()#/core/vendor/ckeditor/skins/mura/dialog.css">
	</head>
</cfoutput>
<body id="mura-select-link">
<cfoutput>
<h4>Keyword Search</h4>
<form id="mura-link-search" class="form-inline" name="siteSearch" method="post">
  <div class="mura-input-set">
   <input id="keywords" name="keywords" value="#HTMLEditFormat(attributes.keywords)#" type="text" class="span4" maxlength="50"/>
    <input class="btn" type="submit" onclick="document.getElementById('mura-link-search').submit();" value="Search">
  </div>
  	<input type="hidden" name="fuseaction" value="cArch.search">
  	<input type="hidden" name="siteid" value="#session.siteid#">
  	<input type="hidden" name="moduleid" value="00000000000000000000000000000000000">
</form>

</cfoutput>
<form class="mura-link-search-result" name="frmLinks" method="post" onSubmit="return false;">
<cfif attributes.keywords neq ''>
<div id="mura-table-grid-container">
 <table class="table table-condensed table-bordered table-striped mura-table-grid">
 <thead>
    <tr>
	  <th class="actions"></th>
      <th class="var-width">Title</th>
    </tr>
 </thead>
 <tbody>
    <cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" maxrows="#request.nextn.recordsperPage#" startrow="#attributes.startrow#">
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
        <tr>
        <td class="actions"><input type="radio" name="theLinks" id="theLinks#request.rslist.currentrow#" value="#htmlEditFormat(request.contentRenderer.createHREF(request.rslist.type,request.rslist.filename,session.siteid,request.rslist.contentid,request.rslist.target,request.rslist.targetParams,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()))#^#htmleditformat(request.rslist.menutitle)#"<cfif request.rslist.currentrow eq 1> checked</cfif>></td>
        <td class="var-width">
          	 #application.contentRenderer.dspZoomNoLinks(crumbdata,request.rsList.fileExt)#
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
	<div  class="pagination-wrapper">
      <ul class="pagination">
      <cfloop from="1"  to="#request.nextn.numberofpages#" index="i">
      	<cfoutput>
      	<cfif request.nextn.currentpagenumber eq i><li class="active"><a href="##">#i#</a></li>
      	<cfelse>
      		<li><a href="?keywords=#attributes.keywords#&startrow=#val((i*request.nextn.recordsperpage)-request.nextn.recordsperpage+1)#">#i#</a></li>
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
