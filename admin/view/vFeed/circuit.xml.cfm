<circuit access="internal">

<prefuseaction>

</prefuseaction>

<fuseaction name="list">
 <include template="dsp_list.cfm"/>
</fuseaction>

<fuseaction name="Edit">
	<if condition="attributes.type eq 'Local'">
		<true>
 			<include template="dsp_form_local.cfm"/>
		</true>
		<false>
			<include template="dsp_form_remote.cfm"/>
		</false>
	</if>
</fuseaction>
  
<fuseaction name="ajax">
	<include template="ajax/dsp_javascript.cfm"/>
</fuseaction>

<fuseaction name="loadSite">
 <include template="ajax/dsp_loadSite.cfm"/>
</fuseaction>

<fuseaction name="siteParents">
 <include template="ajax/dsp_siteParentsRender.cfm"/>
</fuseaction>

<fuseaction name="import1">
 <include template="dsp_import1.cfm"/>
</fuseaction>

<fuseaction name="import2">
 <include template="dsp_import2.cfm"/>
</fuseaction>

</circuit>