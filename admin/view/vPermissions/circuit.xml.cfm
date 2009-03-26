<circuit access="internal">

<prefuseaction>
<set name="attributes.parentid" value="" overwrite="false" />
<set name="attributes.topid" value="" overwrite="false" />
<set name="attributes.contentid" value="" overwrite="false" />
<set name="attributes.body" value="" overwrite="false" />
<set name="attributes.Contentid" value="" overwrite="false" />
<set name="attributes.groupid" value="" overwrite="false" />
<set name="attributes.url" value="" overwrite="false" />
<set name="attributes.type" value="" overwrite="false" />
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.siteid" value="" overwrite="false" />
<set name="attributes.topid" value="00000000000000000000000000000000001" overwrite="false" />
</prefuseaction>

  <fuseaction name="main">

	  <include template="dsp_perm.cfm"/>
	 </fuseaction>
	 <fuseaction name="module">
       
	  <include template="dsp_perm_module.cfm"/>
	  </fuseaction>
</circuit>