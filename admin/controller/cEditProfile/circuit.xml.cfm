<circuit access="public">

<prefuseaction>
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<set name="attributes.categoryid" value="" overwrite="false" />
</prefuseaction>

<fuseaction name="Edit">
<if condition="not isdefined('request.userBean')">
	<true>
		<invoke object="application.userManager" methodcall="read(listfirst(getAuthUser(),'^'))" returnVariable="request.userBean" />
	</true>
</if>
<do action="vPrivateUsers.editprofile" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="update">
<invoke object="application.userManager" methodcall="update(attributes,false)" returnVariable="request.userBean" />
	    <if condition="not structIsEmpty(request.userBean.getErrors())"> 
	 <true>
	   <do action="cEditProfile.Edit"/>
	  </true>
	  <false>
	  	<relocate url="index.cfm" addtoken="false"/>
	  </false>
	  </if>
</fuseaction>

</circuit>
