<!doctype html>
<html class="mura">
	<head>
		<title>Select Component</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">
		<link href="#application.configBean.getContext()#/admin/assets/css/admin-min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="<cfoutput>#application.configBean.getContext()#</cfoutput>/tasks/widgets/ckeditor/skins/mura/dialog.css">

		<cfset rs=application.contentManager.getComponents(session.moduleid,session.siteid)/>
	</head>
	<body id="mura-select-component">
		<div class="cke_dialog">
			<h2>Component Name</h2>
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