<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Select Component</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">
		<link rel="stylesheet" type="text/css" href="<cfoutput>#application.configBean.getContext()#</cfoutput>/tasks/widgets/ckeditor/skins/mura/dialog.css">
		<!---<link href="<cfoutput>#application.configBean.getContext()#</cfoutput>/tasks/widgets/ckeditor/plugins/skins/mura/dialog.css" rel="stylesheet" type="text/css" />--->

		<cfset rs=application.contentManager.getComponents(session.moduleid,session.siteid)/>
	</head>
	<body>
		<div class="cke_dialog">
			<h3>Component Name</h3>
			<cfoutput>
			<select id="btnComponents">
				<option value="">Select a Component</option>
				<cfloop query="rs">
					<option value="<cfif len(trim(rs.body))>#htmleditformat(rs.body)#<cfelse>[mura]$.dspObject('component', '#rs.contentID#')[/mura]</cfif>">#rs.title#</option>
				</cfloop>
			</select>
			</cfoutput>
		</div>
	</body>
</html>