<circuit access="internal">

<prefuseaction>
<set name="attributes.contentid" value="" overwrite="false" />
<set name="attributes.contenthistid" value="" overwrite="false" />
<set name="attributes.topid" value="" overwrite="false" />
<set name="attributes.type" value="" overwrite="false" />
<set name="attributes.moduleid" value="" overwrite="false" />
<set name="attributes.redirect" value="" overwrite="false" />
<set name="attributes.parentid" value="" overwrite="false" />
<set name="attributes.siteid" value="" overwrite="false" />
<set name="attributes.status" value="" overwrite="false" />
</prefuseaction>

<fuseaction name="main">
<include template="dsp_main.cfm"/>
</fuseaction>
 
<fuseaction name="failed">
<include template="dsp_main.cfm"/>
</fuseaction>

</circuit>