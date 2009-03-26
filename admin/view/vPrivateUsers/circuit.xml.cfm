<circuit access="internal">

<prefuseaction>
<set name="attributes.Type" value="0" overwrite="false" />
<set name="attributes.ContactForm" value="0" overwrite="false" />
<set name="attributes.isPublic" value="0" overwrite="false" />
<set name="attributes.username" value="" overwrite="false" />
<set name="attributes.email" value="" overwrite="false" />
<set name="attributes.jobtitle" value="" overwrite="false" />
<set name="attributes.password" value="" overwrite="false" />
<set name="attributes.lastupdate" value="" overwrite="false" />
<set name="attributes.lastupdateby" value="" overwrite="false" />
<set name="attributes.lastupdatebyid" value="0" overwrite="false" />
<set name="rsGrouplist.recordcount" value="0" overwrite="false" />
<set name="attributes.groupname" value="" overwrite="false" />
<set name="attributes.fname" value="" overwrite="false" />
<set name="attributes.lname" value="" overwrite="false" />
<set name="attributes.address" value="" overwrite="false" />
<set name="attributes.city" value="" overwrite="false" />
<set name="attributes.state" value="" overwrite="false" />
<set name="attributes.zip" value="" overwrite="false" />
<set name="attributes.phone1" value="" overwrite="false" />
<set name="attributes.phone2" value="" overwrite="false" />
<set name="attributes.fax" value="" overwrite="false" />
<set name="attributes.perm" value="0" overwrite="false" />
<set name="attributes.groupid" value="" overwrite="false" />
<set name="attributes.routeid" value="" overwrite="false" />
<set name="attributes.s2" value="0" overwrite="false" />
<set name="attributes.InActive" value="0" overwrite="false" />
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="request.error" value="#structnew()#" overwrite="false" />
</prefuseaction>

   <fuseaction name="list">
	
	<include template="dsp_list.cfm"/>
	</fuseaction>
	
	 <fuseaction name="editgroup">
	
	<include template="dsp_group.cfm"/>
	</fuseaction>
	
	 <fuseaction name="editprofile">
	
	<include template="dsp_userprofile.cfm"/>
	</fuseaction>
	
	<fuseaction name="search">
	
	<include template="dsp_search.cfm"/>
	</fuseaction>
	
	<fuseaction name="advancedSearchForm">
	
	<include template="dsp_advancedSearchForm.cfm"/>
	</fuseaction>
	
	 <fuseaction name="edituser">
	
	<include template="dsp_user.cfm"/>
	</fuseaction>
	
	<fuseaction name="editAddress">
	<include template="dsp_userAddress.cfm"/>
	</fuseaction>
	
	
</circuit>

