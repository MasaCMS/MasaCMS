<circuit access="internal">
<prefuseaction>
<set name="attributes.mlid" value="" overwrite="false" />
<set name="attributes.startrow" value="1" overwrite="false" />
</prefuseaction>
<fuseaction name="list">
<include template="dsp_list.cfm"/>
</fuseaction>
<fuseaction name="edit">
<include template="dsp_form.cfm"/>
</fuseaction>
<fuseaction name="listmembers">
<include template="dsp_list_members.cfm"/>
</fuseaction>
<fuseaction name="download">
<include template="dsp_download.cfm"/>
</fuseaction>
</circuit>