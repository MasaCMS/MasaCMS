<circuit access="internal">

<prefuseaction>
<set name="attributes.parentid" value="" overwrite="false" />
</prefuseaction>

<fuseaction name="list">
 <include template="dsp_list.cfm"/>
</fuseaction>

<fuseaction name="Edit">
 <include template="dsp_form.cfm"/>
</fuseaction>
  
<fuseaction name="ajax">
	<include template="ajax/dsp_javascript.cfm"/>
</fuseaction>

</circuit>