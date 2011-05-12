<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Select Component</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">

		<link href="<cfoutput>#application.configBean.getContext()#</cfoutput>/wysiwyg/editor/skins/mura/fck_dialog.css" rel="stylesheet" type="text/css" />

<cfset rs=application.contentManager.getComponents(session.moduleid,session.siteid)/>
	</head>
	<body scroll="no" style="OVERFLOW: hidden">
		<table height="100%" cellSpacing="0" cellPadding="0" width="100%" border="0">
			<tr>
				<td>
					<table cellSpacing="0" cellPadding="0" align="center" border="0">
						<tr>
							<td>
								<span fckLang="SelectComponentDlgName">Component Name</span><br/>
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