<cfsilent>
	<cfparam name="objectParams.source" default="">
</cfsilent>
<cfoutput>
<div class="mura-meta">#$.dspObject_Include(thefile='meta/index.cfm',params=objectParams)#</div>
<div class="mura-content">
	#objectParams.source#
</div>
</cfoutput>