<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Select Component</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">
		<script language="javascript">

var oEditor = window.parent.InnerDialogLoaded() ;
var FCKLang = oEditor.FCKLang ;
var FCKSelectComponent = oEditor.FCKSelectComponent ;
var FCK	= oEditor.FCK ;

window.parent.SetOkButton( true ) ;
window.onload = function ()
{
	// First of all, translate the dialog box texts
	oEditor.FCKLanguageManager.TranslatePage( document ) ;
	
	
}

Ok =function() {
	if(document.getElementById('btnComponents').value != ''){
		oEditor.FCK.InsertHtml(document.getElementById('btnComponents').value);
		
		/*if(document.all){
		var html=FCK.GetXHTML();
		<cfoutput>
		var reReplace = "http#iif(application.configBean.getAdminSSL(),de('s'),de(''))#://#application.configBean.getAdminDomain()#";
		</cfoutput>
		reReplace = new RegExp(reReplace)
		html = html.replace(reReplace, "");
		//FCK.SetXHTML(html);
		} */
		window.parent.Cancel() ;
	}else{
		alert('Please select a component.');
	}
}
</script>
<cfset rs=application.contentManager.getComponents(session.moduleid,session.siteid)/>
	</head>
	<body scroll="no" style="OVERFLOW: hidden">
		<table height="100%" cellSpacing="0" cellPadding="0" width="100%" border="0">
			<tr>
				<td>
					<table cellSpacing="0" cellPadding="0" align="center" border="0">
						<tr>
							<td>
								<span fckLang="SelectComponentDlgName">Placeholder Name</span><br/>
<cfoutput><select id="btnComponents"><option value="">Select a Component</option><cfloop query="rs">
<option value="#htmleditformat('#rs.body#')#">#rs.title#</option>
</cfloop></select></cfoutput>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>