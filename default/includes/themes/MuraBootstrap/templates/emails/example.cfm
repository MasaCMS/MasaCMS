<!---
This file is part of Mura CMS.
Licensed under the GNU GENERAL PUBLIC LICENSE Version 2, June 1991
--->
<cfoutput>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Message from #HTMLEditFormat(rsEmail.site)#</title>
<style type="text/css">
h1,h2,h3,h4,h5,h6 {padding:1em 0 0.5em 0;}
##body,##footer {padding:1em;margin:1em;}
##footer {border-top:1px solid black;}
.container {}
.forward {padding-bottom:0.5em;}
.unsubscribe {font-style:italic;}
</style>
</head>
<body>
	<div class="container">
		<div id="body">
			#bodyHtml#
		</div>
		<div id="footer">
			<p class="forward"><a href="#forward#">Forward To a Friend &gt;</a></p>
			<p class="unsubscribe">To unsubscribe, <a href="#unsubscribe#">please click here</a>.</p>
		</div>
	</div>
	#trackOpen#
</body>
</html>
</cfoutput>