<cfoutput>
	<div class="your-component-class">

		<!--- Use this if you do NOT want [mura] tags to render. --->
		#m.component('body')#

		<!--- Use this if you DO want [mura] tags to render. --->
		<!---#m.setDynamicContent(m.component('body'))# --->

	</div>
</cfoutput>
