<circuit access="internal">

<prefuseaction>

<set name="attributes.fuseaction" value="list" overwrite="false" />
<set name="attributes.subject" value="" overwrite="false" />
<set name="attributes.bodytext" value="" overwrite="false" />
<set name="attributes.bodyhtml" value="" overwrite="false" />
<set name="attributes.createddate" value="" overwrite="false" />
<set name="attributes.deliverydate" value="" overwrite="false" />
<set name="attributes.grouplist" value="" overwrite="false" />
<set name="attributes.groupid" value="" overwrite="false" />
<set name="attributes.emailid" value="" overwrite="false" />
<set name="attributes.status" value="2" overwrite="false" />
<set name="attributes.lastupdatebyid" value="" overwrite="false" />
<set name="attributes.lastupdateby" value="" overwrite="false" />

<set name="session.emaillist.status" value="2" overwrite="false" />
<set name="session.emaillist.groupid" value="" overwrite="false" />
<set name="session.emaillist.subject" value="" overwrite="false" />
<set name="session.emaillist.dontshow" value="1" overwrite="false" />

</prefuseaction>

    <fuseaction name="list">
	<include template="dsp_list.cfm"/>
	</fuseaction>
	
	<fuseaction name="Edit">
	<include template="dsp_form.cfm"/>
	</fuseaction>
	
	<fuseaction name="showBounces">
	<include template="dsp_bounces.cfm"/>
	</fuseaction>
	
	<fuseaction name="showReturns">
	<include template="dsp_returns.cfm"/>
	</fuseaction>
	
	<fuseaction name="ajax">
	<include template="ajax/dsp_javascript.cfm"/>
	</fuseaction>
	
	<fuseaction name="download">
	<include template="act_download.cfm"/>
	</fuseaction>
	
</circuit>
