<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#$.getTopID()#" class="threeCol depth#arrayLen($.event('crumbdata'))#">
<div id="container" class="#$.createCSSid($.content('menuTitle'))# container">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix span-24">
		<div id="left" class="sidebar span-6">
			#$.dspObjects(1)#
		</div>
		<div id="primary" class="content span-12">
			#$.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")#
			#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
			#$.dspObjects(2)#
		</div>
		<div id="right" class="sidebar span-6 last">
			#$.dspObjects(3)#
		</div>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>