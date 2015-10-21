<cfsilent>
	<cfparam name="objectParams.source" default="">
</cfsilent>
<cfoutput>
<div class="mura-object-meta">#$.dspObject_Include(thefile='meta/index.cfm',params=objectParams)#</div>
<div class="mura-object-content">
	#objectParams.source#
</div>
</cfoutput>