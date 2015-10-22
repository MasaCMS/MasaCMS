<cfsilent>
	<cfparam name="objectParams.sourcetype" default="free">
	<cfparam name="objectParams.source" default="">
	<cfparam name="objectParams.render" default="server">
</cfsilent>
<cfoutput>
<div class="mura-object-meta">#$.dspObject_Include(thefile='meta/index.cfm',params=objectParams)#</div>
<div class="mura-object-content">
<cfif objectParams.sourceType eq 'component'>
	#$.dspObject(objectid=objectParams.source,object='component')#
<cfelseif objectParams.sourceType eq 'boundattribute'>
	#$.content(objectParams.source)#
<cfelseif objectParams.sourcetype eq 'freetext'>
	#objectParams.source#
<cfelse>
	<p>This text has not been configured.</p>
</cfif>
</div>
</cfoutput>