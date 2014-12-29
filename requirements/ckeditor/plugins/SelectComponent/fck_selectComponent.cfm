<!doctype html>
<html class="mura">
	<head>
		<title>Select Component</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">
		<link href="../../../../../admin/assets/css/admin.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
		<link href="../../skins/mura/dialog.css" rel="stylesheet" type="text/css" />
		<cfset rs=application.contentManager.getComponents(session.moduleid,session.siteid)/>
	</head>
	<body id="mura-select-component" class="mura-plugin">
		<div class="cke_dialog">
			<h1>Select a Component to Insert</h1>
			<cfoutput>
			<select id="btnComponents">
				<option value="">Select Component</option>
				<cfloop query="rs">
					<option value="<cfif len(trim(rs.body))>#htmleditformat(rs.body)#<cfelse>[mura]$.dspObject('component', '#rs.contentID#')[/mura]</cfif>">#rs.title#</option>
				</cfloop>
			</select>
			</cfoutput>
		</div>
	</body>
</html>